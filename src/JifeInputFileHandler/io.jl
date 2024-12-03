#import XMLParser.IOState
function Base.read(::Type{JifeModelDef}, file)
	#state = IOState(file)
	#element = readXMLElement(state)
	#close(state.f)
	xmlfile = read(XMLFile, file)
	return JifeModelDef(file,xmlfile,xmlfile.element)
end

function Base.write(ogsmodel::JifeModelDef)
	#f = open(ogsmodel.name,"w")
	#writeXMLElement(f,ogsmodel.xmlroot)
	#close(f)
	write(ogsmodel.name, ogsmodel.xmlfile)
end