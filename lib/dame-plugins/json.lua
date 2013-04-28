

groups = DAME.GetGroups()
groupCount = as3.tolua(groups.length) -1

DAME.SetFloatPrecision(3)

tab1 = "\t"
tab2 = "\t\t"
tab3 = "\t\t\t"
tab4 = "\t\t\t\t"
tab5 = "\t\t\t\t\t"

-- slow to call as3.tolua many times so do as much as can in one go and store to a lua variable instead.
exportOnlyCSV = as3.tolua(VALUE_ExportOnlyCSV)
flixelPackage = as3.tolua(VALUE_FlixelPackage)
baseClassName = as3.tolua(VALUE_BaseClass)
baseExtends = as3.tolua(VALUE_BaseClassExtends)
IntermediateClass = as3.tolua(VALUE_IntermediateClass)
as3Dir = as3.tolua(VALUE_AS3Dir)
tileMapClass = as3.tolua(VALUE_TileMapClass)
GamePackage = as3.tolua(VALUE_GamePackage)
csvDir = as3.tolua(VALUE_CSVDir)
importsText = as3.tolua(VALUE_Imports)
-- Version can be "2.43" or "2.5"
flixelVersion = as3.tolua(VALUE_FlixelVersion)

-- This is the file for the map base class
baseFileText = "";
fileText = "";

pathLayers = {}

containsBoxData = false
containsCircleData = false
containsTextData = false
containsPaths = false

------------------------
-- TILEMAP GENERATION
------------------------

function jsonMap(mapLayer, mapName)
	mapText = mapName..":\""..as3.tolua(DAME.ConvertMapToText(mapLayer,"","ROWEND","",",",""))
	mapText = string.sub(mapText, 1, -1)
	return mapText .."\""
end
	
------------------------
-- PATH GENERATION
------------------------

for groupIndex = 0,groupCount do

	maps = {}
	spriteLayers = {}
	shapeLayers = {}
	pathLayers = {}
	masterLayerAddText = ""
	stageAddText = ""
	jsonText = "{";
	
	group = groups[groupIndex]
	groupName = as3.tolua(group.name)
	groupName = string.gsub(groupName, " ", "_")
	
	DAME.ResetCounters()
	
	
	layerCount = as3.tolua(group.children.length) - 1
	
	for layerIndex = 0,layerCount do
		layer = group.children[layerIndex]
		isMap = as3.tolua(layer.map)~=nil
		layerName = as3.tolua(layer.name)
		layerName = string.gsub(layerName, " ", "_")
		if isMap == true then
			mapFileName = groupName..".json"
			-- Generate the map file.
			jsonText = jsonText ..  jsonMap( layer, '"'..layerName..'"' ) .. ","
			
			
			-- This needs to be done here so it maintains the layer visibility ordering.
			if exportOnlyCSV == false then
				table.insert(maps,{layer,layerName})
				-- For maps just generate the Embeds needed at the top of the class.
				fileText = fileText..tab2.."[Embed(source=\""..as3.tolua(DAME.GetRelativePath(as3Dir, csvDir.."/"..mapFileName)).."\", mimeType=\"application/octet-stream\")] public var CSV_"..layerName..":Class;\n"
				fileText = fileText..tab2.."[Embed(source=\""..as3.tolua(DAME.GetRelativePath(as3Dir, layer.imageFile)).."\")] public var Img_"..layerName..":Class;\n"
				masterLayerAddText = masterLayerAddText..tab3.."masterLayer.add(layer"..layerName..");\n"
			end

		elseif exportOnlyCSV == false then
			addGroup = false;
			if as3.tolua(layer.IsSpriteLayer()) == true then
				table.insert( spriteLayers,{groupName,layer,layerName})
				addGroup = true;
				
				--stageAddText = stageAddText..tab3.."addSpritesForLayer"..layerName.."(onAddCallback);\n"
				--jsonText = jsonText .. layerName .. ":"
			elseif as3.tolua(layer.IsShapeLayer()) == true then
				table.insert(shapeLayers,{groupName,layer,layerName})
				addGroup = true
				--jsonText = jsonText .. layerName .. ":"
			elseif as3.tolua(layer.IsPathLayer()) == true then
				table.insert(pathLayers,{groupName,layer,layerName})
				addGroup = true
				--jsonText = jsonText .. layerName .. ":"
			end
			
			if addGroup == true then
				masterLayerAddText = masterLayerAddText..tab3.."masterLayer.add("..layerName.."Group);\n"
				if flixelVersion ~= "2.5" then
					masterLayerAddText = masterLayerAddText..tab3..layerName.."Group.scrollFactor.x = "..string.format("%.4f",as3.tolua(layer.xScroll))..";\n"
					masterLayerAddText = masterLayerAddText..tab3..layerName.."Group.scrollFactor.y = "..string.format("%.4f",as3.tolua(layer.yScroll))..";\n"
				end
			end
		end
		--if layerIndex+1<layerCount then
		--	jsonText = jsonText .. "," 
		--end
	end
	
	--jsonText = jsonText .. "["
	layerText=""
	for i,v in ipairs(spriteLayers) do
		layer = spriteLayers[i][2]

		propertiesString = ",\"properties\":{ %%proploop%%"
		propertiesString = propertiesString.."\"%propname%\": %propvaluestring%%separator:,%"
		propertiesString = propertiesString.."%%proploopend%%"

		creationText = "{\"type\":\"%class%\", \"x\":\"%xpos%\", \"y\":\"%ypos%\"" .. propertiesString .. "}}"
		layerText = layerText.."],"..'"'..spriteLayers[i][3]..'"'..":[";
		layerText = layerText..as3.tolua(DAME.CreateTextForSprites(layer,creationText,"Avatar"))
	end
	layerText= string.gsub(layerText, "}{", "},{")
	jsonText = jsonText .. string.sub(layerText, 3)
	jsonText = jsonText .. "]}" 
	DAME.WriteFile(as3Dir.."/"..mapFileName, jsonText )
end

return 1