local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
local Collector = GatherMate:NewModule("Collector", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate2",true)																
local NL = LibStub("AceLocale-3.0"):GetLocale("GatherMate2Nodes")   -- for get the local name of Gas Cloud´s

-- Workaround for WoW 12.0.0 Midnight: Create our own event frame to bypass AceEvent taint issues
local CollectorEventFrame = CreateFrame("Frame", "GatherMate2CollectorFrame")
local eventHandlers = {}																							 
-- prevSpell, curSpell are markers for what has been cast now and the lastcast
-- gatherevents if a flag for wether we are listening to events
local prevSpell, curSpell, foundTarget, ga

local GetSpellName = C_Spell.GetSpellName

--[[
Convert for 2.4 spell IDs
]]
local miningSpell = (GetSpellName(2575))
local miningSpell2 = (GetSpellName(195122))
local miningSpell3 = (GetSpellName(423341)) -- Khaz Algar
local miningSpell4 = (GetSpellName(471013)) -- Midnight													   
local herbSpell = (GetSpellName(2366))
local herbSpell2 = (GetSpellName(423340)) -- Khaz Algar
local herbSpell3 = (GetSpellName(471009)) -- Midnight													   												 
local herbSkill = ((GetSpellName(170691)) or (string.gsub((GetSpellName(9134)),"%A","")))
local fishSpell = (GetSpellName(7620)) or (GetSpellName(131476))
local gasSpell = (GetSpellName(30427))
--local gasSpell = (GetSpellName(48929))  --other gasspell
local openSpell = (GetSpellName(3365))
local openNoTextSpell = (GetSpellName(22810))
local pickSpell = (GetSpellName(1804))
local archSpell = (GetSpellName(73979)) -- Searching for Artifacts spell
local sandStormSpell = (GetSpellName(93473)) -- Sandstorm spell cast by the camel
local loggingSpell = (GetSpellName(167895))
local loggingSpell2 = (GetSpellName(1239682)) -- Woodchopping / Holzhacken  Patch: 11.2.7
-- Midnight Fishing: These pools are clicked directly (no fishing spell cast)
-- They apply an aura when you interact with them
local midnightFishingAuraID = 1224771 -- "Void Hole Fishing" / "Leerenlochangeln"
local midnightFishingPools = {
	["Oceanic Vortex"] = true,
	-- Add more Midnight fishing pools here as they are discovered
}												 
local spells =
{ -- spellname to "database name"
	[miningSpell] = "Mining",
	[miningSpell2] = "Mining",
	[miningSpell3] = "Mining",
	[herbSpell] = "Herb Gathering",
	[fishSpell] = "Fishing",
	[gasSpell] = "Extract Gas",
	[openSpell] = "Treasure",
	[openNoTextSpell] = "Treasure",
	[pickSpell] = "Treasure",
	[archSpell] = "Archaeology",
	[sandStormSpell] = "Treasure",
	[loggingSpell] = "Logging",
	[loggingSpell2] = "Logging",
	[205243] = "Treasure", -- skinning ground warts
	[469894] = "Treasure", -- Erde ebnen / Level Earth (Disturbed Earth)
}

-- Midnight/TTW spells
if miningSpell4 then spells[miningSpell4] = "Mining" end
if herbSpell2 then spells[herbSpell2] = "Herb Gathering" end
if herbSpell3 then spells[herbSpell3] = "Herb Gathering" end					  
local tooltipLeftText1 = _G["GameTooltipTextLeft1"]
local strfind = string.find
local pii = math.pi
local sin = math.sin
local cos = math.cos
--[[
	This search string code no longer needed since we use CombatEvent to detect gas clouds harvesting
]]
-- buffsearchstring is for gas extartion detection of the aura event
-- local buffSearchString
--local sub_string = GetLocale() == "deDE" and "%%%d$s" or "%%s"
--buffSearchString = string.gsub(AURAADDEDOTHERHELPFUL, sub_string, "(.+)")

-- Workaround for WoW 12.0.0 Midnight: Setup event handler and register PLAYER_LOGIN immediately
-- This registration happens at file load time (before OnEnable), which is allowed
CollectorEventFrame:SetScript("OnEvent", function(self, event, ...)
	-- Special handling for PLAYER_LOGIN to register other events
	if event == "PLAYER_LOGIN" then
		Collector:RegisterGatherEvents()
		CollectorEventFrame:UnregisterEvent("PLAYER_LOGIN")
		return
	end

	-- Handle normal events
	local handler = eventHandlers[event]
	if handler then
		handler(Collector, event, ...)
	end
end)

-- Register PLAYER_LOGIN immediately at file load time (this is allowed)
CollectorEventFrame:RegisterEvent("PLAYER_LOGIN")

--[[
	Enable the collector
]]
function Collector:OnEnable()
	-- Event registration is now handled by PLAYER_LOGIN event
	-- Nothing needed here for WoW 12.0.0 Midnight compatibility
end

--[[
	Disable the collector
]]
function Collector:OnDisable()
	self:UnregisterGatherEvents()
end

--[[
	Register the events we are interesting
]]
function Collector:RegisterGatherEvents()
	-- Map events to handler functions
	eventHandlers["UNIT_SPELLCAST_SENT"] = self.SpellStarted
	eventHandlers["UNIT_SPELLCAST_STOP"] = self.SpellStopped
	eventHandlers["UNIT_SPELLCAST_FAILED"] = self.SpellFailed
	eventHandlers["UNIT_SPELLCAST_INTERRUPTED"] = self.SpellFailed
	eventHandlers["CURSOR_CHANGED"] = self.CursorChange
	eventHandlers["UI_ERROR_MESSAGE"] = self.UIError
	-- COMBAT_LOG_EVENT_UNFILTERED is BLOCKED in WoW 12.0.0 Midnight
	-- This event is no longer available to addons due to combat restrictions
	-- eventHandlers["COMBAT_LOG_EVENT_UNFILTERED"] = self.GasBuffDetector
	eventHandlers["CHAT_MSG_LOOT"] = self.SecondaryGasCheck
	eventHandlers["ZONE_CHANGED_NEW_AREA"] = self.ZoneChanged
	eventHandlers["UNIT_AURA"] = self.MidnightFishingCheck

	-- Register events on our custom frame
	CollectorEventFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
	CollectorEventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	CollectorEventFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
	CollectorEventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	CollectorEventFrame:RegisterEvent("CURSOR_CHANGED")
	CollectorEventFrame:RegisterEvent("UI_ERROR_MESSAGE")
	-- COMBAT_LOG_EVENT_UNFILTERED is now PROTECTED in Midnight 12.0.0
	-- CollectorEventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	CollectorEventFrame:RegisterEvent("CHAT_MSG_LOOT")
	CollectorEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	CollectorEventFrame:RegisterEvent("UNIT_AURA")
end

--[[
	Unregister the events
]]
function Collector:UnregisterGatherEvents()
											
	CollectorEventFrame:UnregisterEvent("UNIT_SPELLCAST_SENT")
	CollectorEventFrame:UnregisterEvent("UNIT_SPELLCAST_STOP")
	CollectorEventFrame:UnregisterEvent("UNIT_SPELLCAST_FAILED")
	CollectorEventFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	CollectorEventFrame:UnregisterEvent("CURSOR_CHANGED")
	CollectorEventFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	-- COMBAT_LOG_EVENT_UNFILTERED no longer registered
	-- CollectorEventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	CollectorEventFrame:UnregisterEvent("CHAT_MSG_LOOT")
	CollectorEventFrame:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	CollectorEventFrame:UnregisterEvent("UNIT_AURA")

	-- Clear handlers
	wipe(eventHandlers)
end

--[[
	Zone Changed - Debug output for zone IDs
]]
function Collector:ZoneChanged()
	if not GatherMate.db.profile.debugZones then return end

	local mapID = C_Map.GetBestMapForUnit("player")
	local mapInfo = mapID and C_Map.GetMapInfo(mapID)
	local zoneName = mapInfo and mapInfo.name or "Unknown"
	local parentMapID = mapInfo and mapInfo.parentMapID
	local parentInfo = parentMapID and C_Map.GetMapInfo(parentMapID)
	local parentName = parentInfo and parentInfo.name or "None"

	-- Get real zone name from API
	local realZone = GetRealZoneText() or "Unknown"
	local subZone = GetSubZoneText() or ""

	print(string.format("|cff00ff00GatherMate2 DEBUG:|r MapID: |cffffd200%s|r | %s | Parent: %s (%s) | SubZone: %s",
		tostring(mapID), zoneName, parentName, tostring(parentMapID), subZone))
end

--[[
	Midnight Fishing Detection
	These fishing pools are creatures that you click directly (no fishing rod cast)
	When clicked, they apply an aura. We detect the aura and save the location.
]]
function Collector:MidnightFishingCheck(event, unit)
	if unit ~= "player" then return end

	-- Check if we have the midnight fishing aura using the secure API
	-- Use GetPlayerAuraBySpellID instead of GetAuraDataBySpellName (which is protected)
	local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(midnightFishingAuraID)

	if auraInfo then
		-- We have the fishing aura, check what we're targeting/mousing over
		local targetName = UnitName("target") or tooltipLeftText1:GetText()

		if targetName and midnightFishingPools[targetName] then
			-- Found a known midnight fishing pool
			self:addItem(fishSpell, targetName)
			if GatherMate.db.profile.debugSpells then
				print("|cFF00FF00GatherMate2:|r Midnight fishing pool detected: " .. targetName)
			end
		end
	end
end

local CrystalizedWater = (C_Item.GetItemNameByID(37705)) or ""
local MoteOfAir = (C_Item.GetItemNameByID(22572)) or ""

function Collector:SecondaryGasCheck(event,msg)
	if ga ~= gasSpell then return end
	if not msg then return end
	if foundTarget then return end
	if ga == gasSpell and strfind(msg,CrystalizedWater) then
		-- check for Steam Clouds by assuming your always getting water from Steam Clouds
		foundTarget = true
		self:addItem(ga,NL["Steam Cloud"])
		ga = "No"
	end
	if ga == gasSpell and strfind(msg,MoteOfAir) then
		-- check for Steam Clouds by assuming your always getting water from Steam Clouds
		foundTarget = true
		self:addItem(ga,NL["Windy Cloud"])
		ga = "No"
	end
end

--[[
	This is a hack for scanning mote extraction, hopefully blizz will make the mote mobs visible so we can mouse over
	or get a better event instead of cha msg parsing
	UNIT_DISSIPATES,0x0000000000000000,nil,0x80000000,0xF1307F0A00002E94,"Cinder Cloud",0xa28 now fires in cataclysm so hack not needed any more
]]
function Collector:GasBuffDetector(b)
	if foundTarget or (prevSpell and prevSpell ~= gasSpell) then return end
	local _timestamp, eventType, _hideCaster, _srcGUID, srcName, _srcFlags, _srcRaidFlags, _dstGUID, dstName, _dstFlags, _dstRaidFlags, _spellId, spellName = CombatLogGetCurrentEventInfo()

	if eventType == "SPELL_CAST_SUCCESS" and  spellName == gasSpell then
		ga = gasSpell
	elseif eventType == "UNIT_DISSIPATES" and  ga == gasSpell then
		foundTarget = true
		self:addItem(ga,dstName)
		ga = "No"
	end
	-- Try to detect the camel figurine
	if eventType == "SPELL_CAST_SUCCESS" and spellName == sandStormSpell and srcName == NL["Mysterious Camel Figurine"] then
		foundTarget = true
		self:addItem(sandStormSpell,NL["Mysterious Camel Figurine"])
	end

end

--[[
	Any time we close a loot window stop checking for targets ala the Fishing bobber
]]
function Collector:GatherCompleted()
	prevSpell, curSpell = nil, nil
	foundTarget = false
end

--[[
	When the hand icon goes to a gear see if we can find a nde under the gear ala for the fishing bobber OR herb of mine
]]
function Collector:CursorChange()
	if foundTarget then return end
	if (MinimapCluster:IsMouseOver()) then return end
	if spells[prevSpell] then
		self:GetWorldTarget()
	end
end

--[[
	We stopped casting the spell
]]
function Collector:SpellStopped(event,unit)
	if unit ~= "player" then return end
	if spells[prevSpell] then
		self:GetWorldTarget()
	end
	-- prev spel needs set since it is used for cursor changes
	prevSpell, curSpell = curSpell, curSpell
end

--[[
	We failed to cast
]]
function Collector:SpellFailed(event,unit)
	if unit ~= "player" then return end
	prevSpell, curSpell = nil, nil
end

--[[
	UI Error from gathering when you dont have the required skill
]]
function Collector:UIError(event,token,msg)
	local what = tooltipLeftText1:GetText();
	if not what then return end
	if strfind(msg, miningSpell) or (miningSpell2 and strfind(msg, miningSpell2)) or (miningSpell3 and strfind(msg, miningSpell3)) or (miningSpell4 and strfind(msg, miningSpell4)) then
		self:addItem(miningSpell,what)
	elseif strfind(msg, herbSkill) then
		self:addItem(herbSpell,what)
	elseif strfind(msg, pickSpell) or strfind(msg, openSpell) then -- locked box or failed pick
		self:addItem(openSpell, what)
	elseif strfind(msg, NL["Lumber Mill"]) then -- timber requires lumber mill
		self:addItem(loggingSpell, what)
	end
end

--[[
	spell cast started
]]
function Collector:SpellStarted(event,unit,target,guid,spellcast)
	if unit ~= "player" then return end
	-- Debug output if enabled in settings
	if GatherMate.db.profile.debugSpells then
		local debugSpellName = GetSpellName(spellcast) or "Unknown"
		print(string.format("|cff00ff00GatherMate2 DEBUG:|r SpellID: %s | Name: %s | Target: %s", tostring(spellcast), debugSpellName, tostring(target)))
	end	
	foundTarget = false
	ga ="No"
	local spellname = GetSpellName(spellcast)
	if spellname and (spells[spellname] or spells[spellcast]) then
		if spells[spellname] then
			curSpell = spellname
			prevSpell = spellname
		else
			curSpell = spellcast
			prevSpell = spellcast
		end
		local nodeID = GatherMate:GetIDForNode(spells[prevSpell], target)
		if nodeID then -- seem 2.4 has the node name now as the target
			self:addItem(prevSpell,target)
			foundTarget = true
		else
			self:GetWorldTarget()
		end
	else
		prevSpell, curSpell = nil, nil
	end
end

--[[
	add an item to the map (we delgate to GatherMate)
]]
local lastNode = ""
local lastNodeCoords = 0

function Collector:addItem(skill,what)
	-- Use C_Map.GetBestMapForUnit to get the most specific zone (including instances/subzones eg: Atal'Aman in Zul'Aman)
	local zone = C_Map.GetBestMapForUnit("player")
	if not zone then return end

	-- Get player position in world coordinates
	local wx, wy = GatherMate.HBD:GetPlayerWorldPosition()
	if not wx or not wy then return end

	-- Convert to zone coordinates
	local x, y = GatherMate.HBD:GetZoneCoordinatesFromWorld(wx, wy, zone)						  
	if not x or not y then return end -- no valid data

	-- don't collect any data in the garrison, its always the same location and spams the map
	-- TODO: garrison ids
	if GatherMate.mapBlacklist[zone] then return end
	if GatherMate.phasing[zone] then zone = GatherMate.phasing[zone] end

	local node_type = spells[skill]
	if not node_type or not what then return end
	-- db lock check
	if GatherMate.db.profile.dbLocks[node_type] then return	end

	-- special case for fishing and gas extraction guage the pointing direction
	if node_type == fishSpell or node_type == gasSpell then
		local yw, yh = GatherMate.HBD:GetZoneSize(zone)
		if yw == 0 or yh == 0 then return end -- No zone size data
		x,y = self:GetFloatingNodeLocation(x, y, yw, yh)
	end
	-- avoid duplicate readds
	local foundCoord = GatherMate:EncodeLoc(x, y)
	if foundCoord == lastNodeCoords and what == lastNode then return end

	-- tell the core to add it
	local nodeID = GatherMate:GetIDForNode(node_type, what)
	local added = GatherMate:AddNodeChecked(zone, x, y, node_type, what)
	
	-- DEBUG: Always output collection info
	print(string.format("|cFF00FF00GatherMate2 Collect:|r MapID: |cFFFFD200%s|r | Node: |cFF00FFFF%s|r | NodeID: |cFFFF00FF%s|r | Added: %s",
		tostring(zone), tostring(what), tostring(nodeID), tostring(added)))
	if added then
		lastNode = what
		lastNodeCoords = foundCoord
	end
	self:GatherCompleted()
end

--[[
	move the node 20 yards in the direction the player is looking at
]]
function Collector:GetFloatingNodeLocation(x,y,yardWidth,yardHeight)
	local facing = GetPlayerFacing()
	if not facing then	-- happens when minimap rotation is on
		return x,y
	else
		local rad = facing + pii
		return x + sin(rad)*15/yardWidth, y + cos(rad)*15/yardHeight
	end
end

--[[
	get the target your clicking on
]]
function Collector:GetWorldTarget()
	if foundTarget or not spells[curSpell] then return end
	if (MinimapCluster:IsMouseOver()) then return end
	local what = tooltipLeftText1:GetText()

	-- DEBUG: Output tooltip text to chat
	if what and prevSpell then
		print("|cFF00FF00GatherMate2 Debug:|r Spell: " .. tostring(prevSpell) .. " | Tooltip: " .. tostring(what))
	end

	local nodeID = GatherMate:GetIDForNode(spells[prevSpell], what)

	-- DEBUG: Output whether node was found
	if what and prevSpell then
		if nodeID then
			print("|cFF00FF00GatherMate2:|r Node found! ID: " .. tostring(nodeID))
		else
			print("|cFFFF0000GatherMate2:|r Node NOT found in database!")
		end
	end
	if what and prevSpell and what ~= prevSpell and nodeID then
		self:addItem(prevSpell,what)
		foundTarget = true
	end
end
