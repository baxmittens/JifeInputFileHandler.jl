include("../src/JifeInputFileHandler.jl")

import .JifeInputFileHandler: JifeModelDef, getAllPathesbyAttribute, getElementbyPath, setAttributeValbyPath!, rename!

jmd = read(JifeModelDef,"TUC-V2_CS_red.xdj");
pathes = getAllPathesbyAttribute(jmd, "V")


jmdout = deepcopy(jmd)
setAttributeValbyPath!(jmd, pathes[12], "12")
rename!(jmdout, "test.xdj")
write(jmdout)
