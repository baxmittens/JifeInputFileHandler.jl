module JifeInputFileHandler

using XMLParser

mutable struct JifeModelDef
	name::String
	xmlfile::XMLFile
	xmlroot::XMLElement
end

include(joinpath(".","JifeInputFileHandler","io.jl"))
include(joinpath(".","JifeInputFileHandler","utils.jl"))

export JifeModelDef, getAllPathesbyAttribute, rename!, getElementbyPath,  format_ogs_path, setAttributeValbyPath!, getAllPathesbyAttribute!

end # module