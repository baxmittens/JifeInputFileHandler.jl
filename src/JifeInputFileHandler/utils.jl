
function rename!(ogsmodel::JifeModelDef,name::String)
	ogsmodel.name = name
	return nothing
end

function getAllPathesbyAttribute!(ret::Vector{String},xmlroot::XMLElement,attrname::String,path="./")
	for (i,con) in enumerate(xmlroot.content)
		if typeof(con) <: AbstractXMLElement
			_path = joinpath(path,con.tag.name*"[$i]")
			if hasAttributekey(con,attrname)
				push!(ret,_path*"@$attrname")
			else
				if typeof(con) == XMLElement
					getAllPathesbyAttribute!(ret,con,attrname,_path)
				end
			end
		end
	end
	return nothing
end


function getAllPathesbyAttribute(xmlroot::XMLElement,attrname::String,path="./")
	ret = Vector{String}()
	getAllPathesbyAttribute!(ret,xmlroot,attrname,path)
	return ret
end
getAllPathesbyAttribute(ogsmodel::JifeModelDef,attrname::String,path="./") = getAllPathesbyAttribute(ogsmodel.xmlroot,attrname,path)


function getElementbyPath(xmlroot::XMLElement, path::String)
	route = map(x->parse(Int,x), map(x->split(split(x,"[")[2],"]")[1], filter(x->x!=".", splitpath(path))))
	el = xmlroot
	for i in route
		el = el.content[i]
	end
	return el
end
getElementbyPath(ogsmodel::JifeModelDef, path::String) = getElementbyPath(ogsmodel.xmlroot, path)

function setAttributeValbyPath!(jmd::JifeModelDef, path::String, value::String)
	splitstr = split(path,"@")
	@assert length(splitstr) > 1 "No attribute found in $path"
	el = getElementbyPath(jmd, string(splitstr[1]))
	setAttribute(el, string(splitstr[2]), value)
	return nothing
end

function Base.string(md::JifeModelDef)
	str = "JifeModelDef: \n"
	str *= "projectfile: "*md.name*"\n"
	str *= "XML: \n"
	str *= string(md.xmlroot)
	return str
end

function displacement_order(ogsmodel::JifeModelDef)
	process_variables = getElements(ogsmodel.xmlroot,"process_variable")
	pv_displ = filter(x->getElements(x,"name")[1].content[1]=="displacement", process_variables)
	@assert length(pv_displ) == 1
	return parse(Int,getElements(pv_displ[1],"order")[1].content[1])
end

function format_ogs_path(path)
	ret = ""
	splitstr = split(path,"/")
	ind = findfirst(x->x=="@id",splitstr)
	inds = findall(x->contains(x,"?"),splitstr)
	if inds != nothing && length(inds)>0
		matpar = replace(foldl((x,y)->String(x)*"_"*String(y),splitstr[inds]),"?"=>"")
	else
		matpar = replace(splitstr[end-1],"?"=>"")
	end
	if ind != nothing
		matpar *= "_"*splitstr[ind+1]
	end
	return replace(matpar,","=>"_")
end

#function Base.display(cpt::CollocationPoint)
#	print(cpt)
#end
#
#function Base.print(io::IO, cpt::CollocationPoint)
#	return print(io,Base.string(cpt))
#end
#
#function Base.show(io::IO, cpt::CollocationPoint)
#	return Base.print(io,cpt)
#end
