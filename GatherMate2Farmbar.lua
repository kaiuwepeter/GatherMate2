-- GatherMate2 Farmbar Module
-- Tracks gathered herbs and ores - Simple version without quality overlays

local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate2")

-- Create Farmbar module
local Farmbar = GatherMate:NewModule("Farmbar", "AceEvent-3.0", "AceTimer-3.0")

-- Constants for UI layout
local ICON_SIZE = 32
local ITEM_SPACING = 3
local BAR_HEIGHT = 42
local BAR_PADDING = 8
local PROF_ICON_SIZE = 36

-- Profession colors
local PROFESSION_COLORS = {
	herbalism = {0.2, 0.8, 0.2, 1.0},   -- Green
	mining = {0.8, 0.6, 0.2, 1.0},      -- Orange
	fishing = {0.2, 0.6, 1.0, 1.0},     -- Blue
}

-- Midnight Herbs - Format: {name, iconItemID, trackItemID1, trackItemID2}
-- iconItemID = Item für das Icon
-- trackItemID1 & trackItemID2 = Die beiden IDs die gezählt werden
local MIDNIGHT_HERBS = {
	{
		name = "Argentleaf",
		icon = 236777,  -- Item-ID für Icon
		track1 = 236776,  -- Erste zu trackende ID
		track2 = 236777,  -- Zweite zu trackende ID
	},
	{
		name = "Mana Lily",
		icon = 236778,
		track1 = 236778,
		track2 = 236779,
	},
	{
		name = "Tranquility Bloom",
		icon = 236761,
		track1 = 236761,
		track2 = 236767,
	},
	{
		name = "Sanguithorn",
		icon = 236770,
		track1 = 236770,
		track2 = 236771,
	},
	{
		name = "Azeroot",
		icon = 236774,
		track1 = 236774,
		track2 = 236775,
	},
}

-- Midnight Ores - Format: {name, iconItemID, trackItemID1, trackItemID2}
local MIDNIGHT_ORES = {
	{
		name = "Refulgent Copper",
		icon = 237359,  -- Icon-ID
		track1 = 237359,  -- ID 1
		track2 = 237361,  -- ID 2
	},
	{
		name = "Umbral Tin",
		icon = 237362,
		track1 = 237362,
		track2 = 237363,
	},
	{
		name = "Brilliant Silver",
		icon = 237364,
		track1 = 237364,
		track2 = 237365,
	},
}

-- Midnight Fish - Format: {name, iconItemID, trackItemID}
-- Fische werden einzeln gezählt (nicht paarweise wie Erze/Kräuter)
local MIDNIGHT_FISH = {
	{
		name = "Fish 1",  -- TODO: Namen hinzufügen wenn bekannt
		icon = 238370,
		track = 238370,
	},
	{
		name = "Fish 2",
		icon = 238383,
		track = 238383,
	},
	{
		name = "Fish 3",
		icon = 238366,
		track = 238366,
	},
	{
		name = "Fish 4",
		icon = 238371,
		track = 238371,
	},
	{
		name = "Fish 5",
		icon = 238384,
		track = 238384,
	},
	{
		name = "Fish 6",
		icon = 238372,
		track = 238372,
	},
	{
		name = "Fish 7",
		icon = 238365,
		track = 238365,
	},
	-- Weitere Fische können hier hinzugefügt werden
}

-- Active farmbar frames
local activeBars = {}

function Farmbar:OnInitialize()
	-- Initialize database for farmbar settings
	if not GatherMate.db.profile.farmbar then
		GatherMate.db.profile.farmbar = {
			enabled = true,
			showHerbs = true,
			showOres = true,
			showFish = true,
			positions = {},
			debug = false
		}
	end

	self.db = GatherMate.db.profile.farmbar
	self.initialized = false

	-- Register config options
	self:SetupConfig()
end

function Farmbar:OnEnable()
	if not self.db.enabled then
		self:Debug("Farmbar deaktiviert in Einstellungen")
		return
	end

	-- Register for inventory updates
	self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateAllBars")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "DelayedInitialize")

	self:Print("Farmbar geladen! Verwende /gmfarmbar für Optionen.")
end

function Farmbar:DelayedInitialize()
	self:ScheduleTimer("Initialize", 2)
end

function Farmbar:Initialize()
	if self.initialized then return end

	self:Debug("Farmbar wird initialisiert...")
	self:UpdateAllBars()
	self.initialized = true

	self:Debug("Farmbar erfolgreich initialisiert")
end

function Farmbar:UpdateAllBars()
	if not self.db.enabled then
		self:HideAll()
		return
	end

	self:Debug("UpdateAllBars wird ausgeführt...")

	-- Check herbs
	if self.db.showHerbs then
		local shouldShow, items = self:ShouldShowBar("herbalism", MIDNIGHT_HERBS)
		self:Debug(string.format("Kräuter: shouldShow=%s, items=%d", tostring(shouldShow), #items))

		if shouldShow then
			if not activeBars.herbalism then
				activeBars.herbalism = self:CreateProfessionBar("herbalism")
				self:Debug("Kräuter-Bar erstellt")
			end
			self:UpdateBar(activeBars.herbalism, items)
			activeBars.herbalism:Show()
		elseif activeBars.herbalism then
			activeBars.herbalism:Hide()
		end
	end

	-- Check ores
	if self.db.showOres then
		local shouldShow, items = self:ShouldShowBar("mining", MIDNIGHT_ORES)
		self:Debug(string.format("Erze: shouldShow=%s, items=%d", tostring(shouldShow), #items))

		if shouldShow then
			if not activeBars.mining then
				activeBars.mining = self:CreateProfessionBar("mining")
				self:Debug("Erz-Bar erstellt")
			end
			self:UpdateBar(activeBars.mining, items)
			activeBars.mining:Show()
		elseif activeBars.mining then
			activeBars.mining:Hide()
		end
	end

	-- Check fish
	if self.db.showFish then
		local shouldShow, items = self:ShouldShowBar("fishing", MIDNIGHT_FISH, true)
		self:Debug(string.format("Fische: shouldShow=%s, items=%d", tostring(shouldShow), #items))

		if shouldShow then
			if not activeBars.fishing then
				activeBars.fishing = self:CreateProfessionBar("fishing")
				self:Debug("Fisch-Bar erstellt")
			end
			self:UpdateBar(activeBars.fishing, items)
			activeBars.fishing:Show()
		elseif activeBars.fishing then
			activeBars.fishing:Hide()
		end
	end

	self:ArrangeBars()
end

function Farmbar:ShouldShowBar(profession, itemList, isFish)
	local items = {}
	local hasItems = false

	for _, itemData in ipairs(itemList) do
		local totalCount

		-- Fish haben nur eine ID, Erze/Kräuter haben zwei
		if isFish then
			totalCount = GetItemCount(itemData.track, true)
		else
			local count1 = GetItemCount(itemData.track1, true)
			local count2 = GetItemCount(itemData.track2, true)
			totalCount = count1 + count2
		end

		if totalCount > 0 then
			hasItems = true

			-- Get icon texture
			local itemTexture = C_Item.GetItemIconByID(itemData.icon)

			-- Fallback to first tracked item if icon not available
			if not itemTexture then
				if isFish then
					itemTexture = C_Item.GetItemIconByID(itemData.track)
				else
					itemTexture = C_Item.GetItemIconByID(itemData.track1)
				end
			end

			if isFish then
				self:Debug(string.format("Gefunden: %s x%d (ID:%d)",
					itemData.name, totalCount, itemData.track))
			else
				local count1 = GetItemCount(itemData.track1, true)
				local count2 = GetItemCount(itemData.track2, true)
				self:Debug(string.format("Gefunden: %s x%d (ID1:%d=%d, ID2:%d=%d)",
					itemData.name, totalCount, itemData.track1, count1, itemData.track2, count2))
			end

			table.insert(items, {
				name = itemData.name,
				texture = itemTexture,
				count = totalCount,
				iconItemID = itemData.icon,
			})
		end
	end

	-- Sort by name
	if hasItems then
		table.sort(items, function(a, b)
			return a.name < b.name
		end)
	end

	return hasItems, items
end

function Farmbar:CreateProfessionBar(profession)
	local barWidth = 300

	local bar = CreateFrame("Frame", "GatherMate2Farmbar_" .. profession, UIParent, "BackdropTemplate")
	bar:SetSize(barWidth, BAR_HEIGHT)
	bar:SetFrameStrata("MEDIUM")
	bar:SetFrameLevel(10)

	-- Backdrop
	bar:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 2,
		insets = {left = 2, right = 2, top = 2, bottom = 2}
	})

	local color = PROFESSION_COLORS[profession] or {0.5, 0.5, 0.5, 1.0}
	bar:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
	bar:SetBackdropBorderColor(color[1], color[2], color[3], 0.8)

	-- Make movable
	bar:SetMovable(true)
	bar:SetClampedToScreen(true)
	bar:EnableMouse(true)
	bar:RegisterForDrag("LeftButton")
	bar:SetScript("OnDragStart", function(self)
		if not InCombatLockdown() then
			self:StartMoving()
		end
	end)
	bar:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		Farmbar:SavePosition(profession, self)
	end)

	-- Profession icon
	local profIcon = bar:CreateTexture(nil, "ARTWORK")
	profIcon:SetSize(PROF_ICON_SIZE, PROF_ICON_SIZE)
	profIcon:SetPoint("LEFT", bar, "LEFT", BAR_PADDING, 0)

	if profession == "herbalism" then
		profIcon:SetTexture("Interface\\Icons\\trade_herbalism")
	elseif profession == "mining" then
		profIcon:SetTexture("Interface\\Icons\\trade_mining")
	elseif profession == "fishing" then
		profIcon:SetTexture("Interface\\Icons\\trade_fishing")
	end
	profIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	bar.profIcon = profIcon

	-- Total count text
	local totalText = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	totalText:SetPoint("LEFT", profIcon, "RIGHT", 8, 0)
	totalText:SetTextColor(color[1], color[2], color[3], 1.0)
	totalText:SetFont(totalText:GetFont(), 16, "OUTLINE")
	totalText:SetText("0")
	bar.totalText = totalText

	-- Item container
	local itemContainer = CreateFrame("Frame", nil, bar)
	itemContainer:SetPoint("LEFT", totalText, "RIGHT", 12, 0)
	itemContainer:SetSize(1, ICON_SIZE)
	bar.itemContainer = itemContainer
	bar.itemFrames = {}

	-- Tooltip
	bar:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		local profName = "Beruf"
		if profession == "herbalism" then
			profName = "Kräuterkunde"
		elseif profession == "mining" then
			profName = "Bergbau"
		elseif profession == "fishing" then
			profName = "Angeln"
		end
		GameTooltip:AddLine(profName, color[1], color[2], color[3])
		GameTooltip:AddLine("Linksklick + Ziehen zum Verschieben", 0.7, 0.7, 0.7)
		GameTooltip:Show()
	end)
	bar:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Load saved position
	self:LoadPosition(profession, bar)

	bar.profession = profession
	return bar
end

function Farmbar:UpdateBar(bar, items)
	if not bar then return end

	-- Calculate total count
	local totalCount = 0
	for _, item in ipairs(items) do
		totalCount = totalCount + item.count
	end
	bar.totalText:SetText(string.format("%04d", totalCount))

	self:Debug(string.format("UpdateBar für %s: %d items, total=%d", bar.profession, #items, totalCount))

	-- Update item icons
	for i, item in ipairs(items) do
		local itemFrame = bar.itemFrames[i]

		if not itemFrame then
			itemFrame = self:CreateItemFrame(bar.itemContainer)
			bar.itemFrames[i] = itemFrame
			self:Debug(string.format("ItemFrame %d erstellt", i))
		end

		-- Position
		itemFrame:ClearAllPoints()
		itemFrame:SetPoint("LEFT", bar.itemContainer, "LEFT", (i - 1) * (ICON_SIZE + ITEM_SPACING), 0)

		-- Set icon texture
		if item.texture then
			itemFrame.icon:SetTexture(item.texture)
			self:Debug(string.format("Icon %d gesetzt: %s", i, item.name))
		else
			-- Fallback texture
			itemFrame.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
			self:Debug(string.format("Icon %d: Keine Texture für %s", i, item.name))
		end

		-- Set count
		itemFrame.countText:SetText(tostring(item.count))

		-- Setup tooltip
		itemFrame.itemID = item.iconItemID
		itemFrame.itemName = item.name
		itemFrame:Show()
	end

	-- Hide unused frames
	for i = #items + 1, #bar.itemFrames do
		bar.itemFrames[i]:Hide()
	end

	-- Adjust container and bar width
	local itemsWidth = math.max(#items * (ICON_SIZE + ITEM_SPACING) - ITEM_SPACING, 0)
	bar.itemContainer:SetWidth(math.max(itemsWidth, 1))

	local textWidth = bar.totalText:GetStringWidth()
	local totalWidth = BAR_PADDING + PROF_ICON_SIZE + 8 + textWidth + 12 + itemsWidth + BAR_PADDING
	bar:SetWidth(math.max(totalWidth, 150))

	self:Debug(string.format("Bar-Breite: %d (Items: %d, ItemsWidth: %d)", totalWidth, #items, itemsWidth))
end

function Farmbar:CreateItemFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(ICON_SIZE, ICON_SIZE)
	frame:EnableMouse(true)

	-- Icon
	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints()
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	frame.icon = icon

	-- Count text
	local countText = frame:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
	countText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
	countText:SetFont(countText:GetFont(), 11, "OUTLINE")
	countText:SetTextColor(1, 1, 1, 1)
	countText:SetShadowColor(0, 0, 0, 1)
	countText:SetShadowOffset(1, -1)
	frame.countText = countText

	-- Tooltip
	frame:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		if self.itemName then
			GameTooltip:AddLine(self.itemName, 1, 1, 1)
		end
		if self.itemID then
			GameTooltip:SetItemByID(self.itemID)
		end
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	return frame
end

function Farmbar:ArrangeBars()
	local visibleBars = {}

	for profession, bar in pairs(activeBars) do
		if bar:IsShown() and not self:HasSavedPosition(profession) then
			table.insert(visibleBars, {profession = profession, bar = bar})
		end
	end

	-- Sort: herbalism first, then mining, then fishing
	table.sort(visibleBars, function(a, b)
		local order = {herbalism = 1, mining = 2, fishing = 3}
		return (order[a.profession] or 99) < (order[b.profession] or 99)
	end)

	-- Arrange bars vertically
	for i, data in ipairs(visibleBars) do
		data.bar:ClearAllPoints()
		data.bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -100 - (i - 1) * (BAR_HEIGHT + 8))
	end
end

function Farmbar:SavePosition(profession, bar)
	local point, _, relativePoint, x, y = bar:GetPoint()
	if not self.db.positions then
		self.db.positions = {}
	end
	self.db.positions[profession] = {
		point = point,
		relativePoint = relativePoint,
		x = x,
		y = y
	}
	self:Debug(string.format("Position gespeichert für %s: %s, %d, %d", profession, point, x, y))
end

function Farmbar:LoadPosition(profession, bar)
	if self.db.positions and self.db.positions[profession] then
		local pos = self.db.positions[profession]
		bar:ClearAllPoints()
		bar:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
		self:Debug(string.format("Position geladen für %s", profession))
		return true
	end
	return false
end

function Farmbar:HasSavedPosition(profession)
	return self.db.positions and self.db.positions[profession] ~= nil
end

-- Public API
function Farmbar:Toggle()
	self.db.enabled = not self.db.enabled

	if self.db.enabled then
		self:OnEnable()
		self:Initialize()
		self:Print("Farmbar aktiviert")
	else
		self:HideAll()
		self:Print("Farmbar deaktiviert")
	end
end

function Farmbar:HideAll()
	for _, bar in pairs(activeBars) do
		bar:Hide()
	end
end

function Farmbar:Refresh()
	self:UpdateAllBars()
	self:Print("Farmbar aktualisiert")
end

function Farmbar:ResetPositions()
	self.db.positions = {}
	self:Print("Farmbar Positionen zurückgesetzt")
	self:ArrangeBars()
end

function Farmbar:ToggleDebug()
	self.db.debug = not self.db.debug
	local status = self.db.debug and "aktiviert" or "deaktiviert"
	self:Print("Debug-Modus " .. status)
end

function Farmbar:ScanInventory()
	self:Print("=== Inventar-Scan ===")

	-- Scan herbs
	self:Print("|cff00ff00Kräuter:|r")
	for _, itemData in ipairs(MIDNIGHT_HERBS) do
		local count1 = GetItemCount(itemData.track1, true)
		local count2 = GetItemCount(itemData.track2, true)
		local total = count1 + count2

		if total > 0 then
			local name1 = C_Item.GetItemInfo(itemData.track1) or ("Item " .. itemData.track1)
			local name2 = C_Item.GetItemInfo(itemData.track2) or ("Item " .. itemData.track2)
			self:Print(string.format("  %s: %d gesamt", itemData.name, total))
			self:Print(string.format("    → %s (ID: %d) x%d", name1, itemData.track1, count1))
			self:Print(string.format("    → %s (ID: %d) x%d", name2, itemData.track2, count2))
		end
	end

	-- Scan ores
	self:Print("|cffff9900Erze:|r")
	for _, itemData in ipairs(MIDNIGHT_ORES) do
		local count1 = GetItemCount(itemData.track1, true)
		local count2 = GetItemCount(itemData.track2, true)
		local total = count1 + count2

		if total > 0 then
			local name1 = C_Item.GetItemInfo(itemData.track1) or ("Item " .. itemData.track1)
			local name2 = C_Item.GetItemInfo(itemData.track2) or ("Item " .. itemData.track2)
			self:Print(string.format("  %s: %d gesamt", itemData.name, total))
			self:Print(string.format("    → %s (ID: %d) x%d", name1, itemData.track1, count1))
			self:Print(string.format("    → %s (ID: %d) x%d", name2, itemData.track2, count2))
		end
	end

	-- Scan fish
	self:Print("|cff3399ffFische:|r")
	for _, itemData in ipairs(MIDNIGHT_FISH) do
		local count = GetItemCount(itemData.track, true)

		if count > 0 then
			local itemName = C_Item.GetItemInfo(itemData.track) or ("Item " .. itemData.track)
			self:Print(string.format("  %s: %s (ID: %d) x%d", itemData.name, itemName, itemData.track, count))
		end
	end
end

-- Config options
function Farmbar:SetupConfig()
	local farmbarOptions = {
		type = "group",
		name = "Farmbar",
		desc = "Farmbar Einstellungen",
		args = {
			desc = {
				order = 0,
				type = "description",
				name = "Die Farmbar zeigt gesammelte Kräuter, Erze und Fische an. Pro Kraut/Erz werden 2 IDs gezählt und addiert, Fische haben 1 ID.",
			},
			enabled = {
				order = 1,
				type = "toggle",
				name = "Farmbar aktivieren",
				desc = "Zeigt eine Bar mit gesammelten Items an",
				get = function() return self.db.enabled end,
				set = function(_, v)
					self.db.enabled = v
					if v then
						self:OnEnable()
						self:Initialize()
					else
						self:HideAll()
					end
				end,
				width = "full",
			},
			showHerbs = {
				order = 2,
				type = "toggle",
				name = "Kräuter anzeigen",
				desc = "Zeigt gesammelte Kräuter in der Farmbar",
				get = function() return self.db.showHerbs end,
				set = function(_, v)
					self.db.showHerbs = v
					self:Refresh()
				end,
				disabled = function() return not self.db.enabled end,
			},
			showOres = {
				order = 3,
				type = "toggle",
				name = "Erze anzeigen",
				desc = "Zeigt gesammelte Erze in der Farmbar",
				get = function() return self.db.showOres end,
				set = function(_, v)
					self.db.showOres = v
					self:Refresh()
				end,
				disabled = function() return not self.db.enabled end,
			},
			showFish = {
				order = 3.5,
				type = "toggle",
				name = "Fische anzeigen",
				desc = "Zeigt gefangene Fische in der Farmbar",
				get = function() return self.db.showFish end,
				set = function(_, v)
					self.db.showFish = v
					self:Refresh()
				end,
				disabled = function() return not self.db.enabled end,
			},
			debug = {
				order = 4,
				type = "toggle",
				name = "Debug-Modus",
				desc = "Zeigt Debug-Informationen im Chat",
				get = function() return self.db.debug end,
				set = function(_, v)
					self.db.debug = v
					self:Print("Debug-Modus " .. (v and "aktiviert" or "deaktiviert"))
				end,
			},
			refresh = {
				order = 10,
				type = "execute",
				name = "Aktualisieren",
				desc = "Farmbar manuell aktualisieren",
				func = function() self:Refresh() end,
			},
			reset = {
				order = 11,
				type = "execute",
				name = "Positionen zurücksetzen",
				desc = "Setzt alle Farmbar-Positionen zurück",
				func = function() self:ResetPositions() end,
			},
			scan = {
				order = 12,
				type = "execute",
				name = "Inventar scannen",
				desc = "Zeigt alle gefundenen Items im Chat",
				func = function() self:ScanInventory() end,
			},
		},
	}

	-- Register with GatherMate2 config system
	local Config = GatherMate:GetModule("Config")
	if Config then
		Config:RegisterModule("Farmbar", farmbarOptions)
		self:Debug("Farmbar Config registriert")
	end
end

-- Slash command integration
SLASH_GATHERMATE2FARMBAR1 = "/gm2farmbar"
SLASH_GATHERMATE2FARMBAR2 = "/gmfarmbar"

SlashCmdList["GATHERMATE2FARMBAR"] = function(msg)
	msg = strlower(strtrim(msg or ""))

	if msg == "" or msg == "help" then
		GatherMate:Print("GatherMate2 Farmbar Befehle:")
		GatherMate:Print("/gmfarmbar toggle - Farmbar an/aus")
		GatherMate:Print("/gmfarmbar reset - Positionen zurücksetzen")
		GatherMate:Print("/gmfarmbar refresh - Farmbar aktualisieren")
		GatherMate:Print("/gmfarmbar debug - Debug-Modus an/aus")
		GatherMate:Print("/gmfarmbar scan - Inventar scannen (zeigt IDs)")
		GatherMate:Print("/gmfarmbar config - Optionen öffnen")
	elseif msg == "toggle" then
		Farmbar:Toggle()
	elseif msg == "reset" then
		Farmbar:ResetPositions()
	elseif msg == "refresh" then
		Farmbar:Refresh()
	elseif msg == "debug" then
		Farmbar:ToggleDebug()
	elseif msg == "scan" then
		Farmbar:ScanInventory()
	elseif msg == "config" then
		Settings.OpenToCategory("Farmbar")
	else
		GatherMate:Print("Unbekannter Befehl. Verwende /gmfarmbar help")
	end
end

-- Utility functions
function Farmbar:Debug(msg)
	if self.db and self.db.debug then
		GatherMate:Print("[Farmbar Debug] " .. tostring(msg))
	end
end

function Farmbar:Print(msg)
	GatherMate:Print(msg)
end
