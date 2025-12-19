--[[
	GatherMate2 Farmbar
	Zeigt farmbaren Items in 4 Kategorien: Erze, Blumen, Fische, Holz
	Basierend auf dem Baganator Kategorie-System
]]

local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate2", false)

-- Farmbar Modul
local Farmbar = GatherMate:NewModule("Farmbar", "AceEvent-3.0", "AceConsole-3.0")

-- Lokale Variablen
local db
local categoryBars = {}
local updateTimer

-- Kategorie-Definitionen
local CATEGORIES = {
	{
		key = "mining",
		name = "Erze",
		icon = "Interface\\Icons\\Trade_Mining",
		color = {r = 1, g = 0, b = 0},
	},
	{
		key = "herbalism",
		name = "Blumen",
		icon = "Interface\\Icons\\Trade_Herbalism",
		color = {r = 0, g = 1, b = 0},
	},
	{
		key = "fishing",
		name = "Fische",
		icon = "Interface\\Icons\\Trade_Fishing",
		color = {r = 0, g = 0.5, b = 1},
	},
	{
		key = "logging",
		name = "Holz",
		icon = "Interface\\Icons\\ui_resourcelumberwarwithin",
		color = {r = 0.6, g = 0.4, b = 0.2},
	},
}

-- Standard-Einstellungen
local defaults = {
	profile = {
		enabled = true,
		locked = false,
		showEmptyBars = true,
		barScale = 1.0,
		buttonSize = 32,
		buttonsPerRow = 5,
		categories = {
			mining = {
				enabled = true,
				items = {},
				position = {point = "BOTTOMLEFT", x = 10, y = 150},
			},
			herbalism = {
				enabled = true,
				items = {},
				position = {point = "BOTTOMLEFT", x = 230, y = 150},
			},
			fishing = {
				enabled = true,
				items = {},
				position = {point = "BOTTOMLEFT", x = 450, y = 150},
			},
			logging = {
				enabled = true,
				items = {},
				position = {point = "BOTTOMLEFT", x = 670, y = 150},
			},
		},
	},
}

-- Initialisierung
function Farmbar:OnInitialize()
	-- Character-specific Settings (nicht profile, sondern char)
	self.db = GatherMate.db:RegisterNamespace("Farmbar", {
		char = defaults.profile,  -- Verwende char statt profile für character-specific
	})
	db = self.db.char  -- char statt profile!

	-- Slash Command registrieren
	self:RegisterChatCommand("farmbar", "SlashCommand")
	self:RegisterChatCommand("fb", "SlashCommand")
end

function Farmbar:OnEnable()
	if not db.enabled then return end

	-- Events registrieren für Inventar-Updates
	self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateBars")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CreateBars")

	-- Bars erstellen
	self:CreateBars()

	-- Initiales Update nach kurzer Verzögerung (damit Items geladen sind)
	C_Timer.After(1, function()
		self:UpdateBars()
	end)
end

function Farmbar:OnDisable()
	self:HideBars()
end

-- Slash Command Handler
function Farmbar:SlashCommand(input)
	input = string.lower(input or "")

	if input == "" or input == "toggle" then
		db.enabled = not db.enabled
		if db.enabled then
			self:CreateBars()
			self:Print("Farmbar aktiviert")
		else
			self:HideBars()
			self:Print("Farmbar deaktiviert")
		end
	elseif input == "lock" then
		db.locked = not db.locked
		self:Print("Farmbar " .. (db.locked and "gesperrt" or "entsperrt"))
		self:UpdateBars()
	elseif input == "config" or input == "settings" then
		self:OpenConfig()
	else
		self:Print("Farmbar Befehle:")
		self:Print("/farmbar toggle - Farmbar ein/ausschalten")
		self:Print("/farmbar lock - Bars sperren/entsperren")
		self:Print("/farmbar config - Einstellungen öffnen")
	end
end

-- Bar-Erstellung
function Farmbar:CreateBars()
	if not db.enabled then return end

	for _, category in ipairs(CATEGORIES) do
		if not categoryBars[category.key] then
			categoryBars[category.key] = self:CreateCategoryBar(category)
		end
	end

	self:UpdateBars()
end

function Farmbar:CreateCategoryBar(category)
	local catData = db.categories[category.key]
	if not catData.enabled then return nil end

	-- Hauptframe erstellen (dynamische Größe, wird später angepasst)
	local bar = CreateFrame("Frame", "GatherMate2Farmbar_" .. category.key, UIParent, "BackdropTemplate")
	bar:SetSize(100, 44)  -- Minimale Größe, wird dynamisch angepasst
	bar:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	bar:SetBackdropColor(0, 0, 0, 0.8)
	bar:SetBackdropBorderColor(category.color.r, category.color.g, category.color.b, 1)
	bar:SetScale(db.barScale)

	-- Position wiederherstellen
	local pos = catData.position
	bar:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)

	-- Bewegbarkeit
	bar:SetMovable(true)
	bar:EnableMouse(true)
	bar:SetClampedToScreen(true)
	bar:RegisterForDrag("LeftButton")

	bar:SetScript("OnDragStart", function(self)
		if not db.locked then
			self:StartMoving()
		end
	end)

	bar:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, _, x, y = self:GetPoint()
		catData.position = {point = point, x = x, y = y}
	end)

	-- Icon für Kategorie (links, vertikal zentriert)
	bar.icon = bar:CreateTexture(nil, "ARTWORK")
	bar.icon:SetSize(32, 32)
	bar.icon:SetPoint("LEFT", bar, "LEFT", 6, 0)
	bar.icon:SetTexture(category.icon)

	-- Count-Label (rechts vom Icon, 4-stellig, vertikal zentriert)
	bar.countLabel = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	bar.countLabel:SetPoint("LEFT", bar.icon, "RIGHT", 6, 0)
	bar.countLabel:SetText("0000")
	bar.countLabel:SetTextColor(category.color.r, category.color.g, category.color.b)
	bar.countLabel:SetJustifyH("LEFT")

	-- Kategoriename speichern für Tooltip
	bar.categoryName = category.name

	-- Item-Buttons Container
	bar.buttons = {}
	bar.categoryKey = category.key

	-- Drop-Zone für Drag & Drop
	bar:SetScript("OnReceiveDrag", function(self)
		Farmbar:OnBarReceiveDrag(self, category.key)
	end)

	bar:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" and not db.locked then
			Farmbar:OpenCategoryConfig(category.key)
		end
	end)

	-- Tooltip
	bar:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(category.name, category.color.r, category.color.g, category.color.b)
		GameTooltip:AddLine("Drag & Drop Items hierher um sie zur Kategorie hinzuzufügen", 1, 1, 1)
		GameTooltip:AddLine("Rechtsklick für Einstellungen", 0.5, 0.5, 0.5)
		GameTooltip:Show()
	end)

	bar:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	return bar
end

-- Drag & Drop Handler
function Farmbar:OnBarReceiveDrag(bar, categoryKey)
	local cursorType, itemID, itemLink = GetCursorInfo()

	if cursorType ~= "item" then return end

	ClearCursor()

	-- Item zur Kategorie hinzufügen
	self:AddItemToCategory(categoryKey, itemID)

	self:Print(string.format("Item %s zu %s hinzugefügt", itemLink or itemID, bar.categoryName))

	-- Bars aktualisieren
	self:UpdateBars()
end

-- Item zu Kategorie hinzufügen
function Farmbar:AddItemToCategory(categoryKey, itemID)
	if type(itemID) == "string" then
		itemID = tonumber(string.match(itemID, "%d+"))
	end

	if not itemID then return end

	-- Von anderen Kategorien entfernen (Items sind exklusiv)
	for _, category in ipairs(CATEGORIES) do
		if category.key ~= categoryKey then
			local items = db.categories[category.key].items
			for i = #items, 1, -1 do
				if items[i] == itemID then
					table.remove(items, i)
				end
			end
		end
	end

	-- Zur neuen Kategorie hinzufügen (wenn nicht schon vorhanden)
	local items = db.categories[categoryKey].items
	local exists = false
	for _, id in ipairs(items) do
		if id == itemID then
			exists = true
			break
		end
	end

	if not exists then
		table.insert(items, itemID)
	end
end

-- Item von Kategorie entfernen
function Farmbar:RemoveItemFromCategory(categoryKey, itemID)
	local items = db.categories[categoryKey].items
	for i = #items, 1, -1 do
		if items[i] == itemID then
			table.remove(items, i)
			break
		end
	end
end

-- Bars aktualisieren
function Farmbar:UpdateBars()
	if not db.enabled then return end

	-- Throttle Updates (max 1x pro Sekunde)
	if updateTimer then return end
	updateTimer = C_Timer.NewTimer(0.1, function()
		updateTimer = nil
		Farmbar:DoUpdateBars()
	end)
end

function Farmbar:DoUpdateBars()
	for _, category in ipairs(CATEGORIES) do
		local bar = categoryBars[category.key]
		if bar then
			self:UpdateCategoryBar(bar, category)
		end
	end
end

function Farmbar:UpdateCategoryBar(bar, category)
	local catData = db.categories[category.key]

	-- Alte Buttons entfernen
	for _, button in ipairs(bar.buttons) do
		button:Hide()
		button:SetParent(nil)
	end
	wipe(bar.buttons)

	-- Items im Inventar sammeln
	local inventoryItems = self:GetInventoryItemCounts()
	local buttonSize = db.buttonSize
	local spacing = 2
	local totalCount = 0  -- Gesamt-Count für diese Kategorie
	local startX = 90  -- Start-Position für Items (nach Icon + Count)

	-- Buttons für Items in dieser Kategorie erstellen (alles in EINER Reihe)
	-- NUR Items anzeigen die auch im Inventar sind (count > 0)
	local visibleIndex = 0
	for _, itemID in ipairs(catData.items) do
		local count = inventoryItems[itemID] or 0

		-- NUR anzeigen wenn im Inventar vorhanden
		if count > 0 then
			totalCount = totalCount + count  -- Zum Gesamt-Count addieren

			-- Button erstellen
			local button = self:CreateItemButton(bar, itemID, count)

			-- Position: Horizontal nebeneinander, RECHTS neben der 0000-Zahl
			local x = startX + visibleIndex * (buttonSize + spacing)
			button:SetPoint("LEFT", bar, "LEFT", x, 0)
			button:Show()

			table.insert(bar.buttons, button)
			visibleIndex = visibleIndex + 1
		end
	end

	-- Count-Label aktualisieren (4-stellig mit führenden Nullen)
	bar.countLabel:SetText(string.format("%04d", totalCount))

	-- Bar-Breite dynamisch anpassen (bündig mit Icons)
	-- Verwende visibleIndex (Anzahl sichtbarer Items) statt #catData.items
	local itemsWidth = visibleIndex > 0 and (visibleIndex * (buttonSize + spacing) - spacing) or 0
	local totalWidth = startX + itemsWidth + 10  -- Icon + Count + Items + Padding
	bar:SetSize(totalWidth, buttonSize + 12)

	-- Bar verstecken wenn keine Items im Inventar ODER keine Items getrackt
	if (visibleIndex == 0 and not db.showEmptyBars) or #catData.items == 0 then
		bar:Hide()
	else
		bar:Show()
	end
end

-- Item Button erstellen
function Farmbar:CreateItemButton(parent, itemID, count)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(db.buttonSize, db.buttonSize)

	-- Icon
	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
	local itemTexture = C_Item.GetItemIconByID(itemID)
	if itemTexture then
		button.icon:SetTexture(itemTexture)
	else
		button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
	end

	-- Count Text (wie bei normalen Item-Buttons)
	button.count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.count:SetTextColor(1, 1, 1)
	button.count:SetShadowOffset(1, -1)
	if count > 0 then
		button.count:SetText(count)
		button.count:Show()
	else
		button.count:Hide()
	end

	-- Border
	button.border = button:CreateTexture(nil, "OVERLAY")
	button.border:SetAllPoints()
	button.border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	button.border:SetBlendMode("ADD")

	-- Quality Color
	local itemQuality = C_Item.GetItemQualityByID(itemID)
	if itemQuality and itemQuality > 1 then
		local r, g, b = C_Item.GetItemQualityColor(itemQuality)
		button.border:SetVertexColor(r, g, b, 0.5)
		button.border:Show()
	else
		button.border:Hide()
	end

	-- Tooltip
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(itemID)

		-- Zusätzliche Info
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Im Inventar: " .. count, 1, 1, 1)
		if not db.locked then
			GameTooltip:AddLine("Shift+Rechtsklick zum Entfernen", 0.5, 0.5, 0.5)
		end
		GameTooltip:Show()
	end)

	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	-- Click Handler
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" and IsShiftKeyDown() and not db.locked then
			Farmbar:RemoveItemFromCategory(parent.categoryKey, itemID)
			Farmbar:UpdateBars()
		elseif btn == "LeftButton" then
			-- Item-Link in Chat
			local itemLink = C_Item.GetItemLinkByID(itemID)
			if itemLink and ChatEdit_GetActiveWindow() then
				ChatEdit_InsertLink(itemLink)
			end
		end
	end)

	button.itemID = itemID

	return button
end

-- Inventar durchsuchen - Verwendet WoW API GetItemCount
function Farmbar:GetInventoryItemCounts()
	local items = {}

	-- Für jede getrackte Kategorie die Items zählen
	for _, category in ipairs(CATEGORIES) do
		local catData = db.categories[category.key]
		for _, itemID in ipairs(catData.items) do
			-- GetItemCount(itemID, includeBank) - false = nur Taschen, true = inkl. Bank
			local count = GetItemCount(itemID, false) or 0
			if count > 0 then
				items[itemID] = count
			end
		end
	end

	return items
end

-- Bars verstecken
function Farmbar:HideBars()
	for _, bar in pairs(categoryBars) do
		if bar then
			bar:Hide()
		end
	end
end

-- Kategorie-Config öffnen
function Farmbar:OpenCategoryConfig(categoryKey)
	-- Öffne die Haupt-Config und springe zur Kategorie
	self:OpenConfig()
	-- TODO: Zur spezifischen Kategorie springen
end

-- Haupt-Config öffnen
function Farmbar:OpenConfig()
	-- Öffne Kriemhilde Config-Panel
	-- Doppelter Aufruf ist notwendig wegen Blizzard-Bug
	Settings.OpenToCategory("Kriemhilde")
	Settings.OpenToCategory("Kriemhilde")
end

-- Config Options für Kriemhilde-Integration erstellen
-- Diese Funktion wird von Config.lua aufgerufen
function Farmbar:GetConfigOptions()
	-- Hauptgruppe für Farmbar
	local farmbarGroup = {
		type = "group",
		name = "Farmbar",
		handler = Farmbar,
		childGroups = "tab",
		get = function(info)
			local key = info[#info]
			if info[#info-1] and db.categories[info[#info-1]] then
				return db.categories[info[#info-1]][key]
			end
			return db[key]
		end,
		set = function(info, value)
			local key = info[#info]
			if info[#info-1] and db.categories[info[#info-1]] then
				db.categories[info[#info-1]][key] = value
			else
				db[key] = value
			end
			Farmbar:UpdateBars()
		end,
		args = {
			general = {
				type = "group",
				name = "Allgemeine Einstellungen",
				order = 1,
				args = {
					enabled = {
						type = "toggle",
						name = "Farmbar aktivieren",
						desc = "Aktiviert oder deaktiviert die Farmbar",
						order = 1,
						set = function(info, value)
							db.enabled = value
							if value then
								Farmbar:CreateBars()
							else
								Farmbar:HideBars()
							end
						end,
					},
					locked = {
						type = "toggle",
						name = "Bars sperren",
						desc = "Verhindert das Verschieben der Bars",
						order = 2,
					},
					showEmptyBars = {
						type = "toggle",
						name = "Leere Bars anzeigen",
						desc = "Zeigt Bars auch wenn keine Items zugewiesen sind",
						order = 3,
					},
					barScale = {
						type = "range",
						name = "Bar Skalierung",
						desc = "Größe der Bars",
						min = 0.5,
						max = 2.0,
						step = 0.05,
						order = 4,
					},
					buttonSize = {
						type = "range",
						name = "Button Größe",
						desc = "Größe der Item-Buttons",
						min = 20,
						max = 64,
						step = 1,
						order = 5,
					},
					buttonsPerRow = {
						type = "range",
						name = "Buttons pro Reihe",
						desc = "Anzahl der Buttons pro Reihe",
						min = 3,
						max = 8,
						step = 1,
						order = 6,
					},
				},
			},
			categories = {
				type = "group",
				name = "Kategorien",
				order = 2,
				childGroups = "tab",
				args = {},
			},
		},
	}

	-- Für jede Kategorie einen Tab erstellen
	for i, category in ipairs(CATEGORIES) do
		farmbarGroup.args.categories.args[category.key] = {
			type = "group",
			name = category.name,
			order = i,
			args = {
				enabled = {
					type = "toggle",
					name = "Kategorie aktivieren",
					desc = "Aktiviert oder deaktiviert diese Kategorie",
					order = 1,
					get = function() return db.categories[category.key].enabled end,
					set = function(info, value)
						db.categories[category.key].enabled = value
						if value then
							categoryBars[category.key] = Farmbar:CreateCategoryBar(category)
						else
							if categoryBars[category.key] then
								categoryBars[category.key]:Hide()
								categoryBars[category.key] = nil
							end
						end
						Farmbar:UpdateBars()
					end,
				},
				header1 = {
					type = "header",
					name = "Verfügbare Items (Checkboxen)",
					order = 2,
				},
				info = {
					type = "description",
					name = "Wähle Items aus, die du tracken möchtest. Items werden nur angezeigt wenn sie im Inventar sind.\n",
					order = 3,
				},
			},
		}

		-- Dynamisch Checkboxen für alle Items erstellen, gruppiert nach Expansion
		local itemsByExpansion = Farmbar:GetItemsByExpansion(category.key)
		local expansionOrder = {"Midnight", "TWW", "DF", "SL", "BFA", "Legion", "WoD", "MoP", "Cata", "Wrath", "TBC", "Classic"}
		local expansionNames = {
			Midnight = "Midnight",
			TWW = "The War Within",
			DF = "Dragonflight",
			SL = "Shadowlands",
			BFA = "Battle for Azeroth",
			Legion = "Legion",
			WoD = "Warlords of Draenor",
			MoP = "Mists of Pandaria",
			Cata = "Cataclysm",
			Wrath = "Wrath of the Lich King",
			TBC = "The Burning Crusade",
			Classic = "Classic/Vanilla"
		}

		local order = 10
		for _, expKey in ipairs(expansionOrder) do
			local items = itemsByExpansion[expKey]
			if items and #items > 0 then
				-- Expansion-Gruppe erstellen
				farmbarGroup.args.categories.args[category.key].args["exp_" .. expKey] = {
					type = "group",
					name = expansionNames[expKey] or expKey,
					order = order,
					inline = true,
					args = {},
				}

				-- Checkboxen für Items in dieser Expansion
				for idx, item in ipairs(items) do
					local itemKey = "item_" .. item.id

					-- Hole lokalisierten Item-Namen vom Client
					local itemName = C_Item.GetItemNameByID(item.id) or item.name
					local itemIcon = C_Item.GetItemIconByID(item.id)

					-- Quality-Atlas-Overlay auf dem Icon für DF/TWW
					local iconWithOverlay = ""
					if itemIcon then
						-- Item Icon einbetten
						iconWithOverlay = string.format("|T%s:20:20:0:0|t", itemIcon)

						-- Quality-Atlas-Overlay drüberlegen
						if item.quality and (expKey == "DF" or expKey == "TWW") then
							local qualityAtlas = ""
							if item.quality == 1 then
								qualityAtlas = "professions-icon-quality-tier1-inv"
							elseif item.quality == 2 then
								qualityAtlas = "professions-icon-quality-tier2-inv"
							elseif item.quality == 3 then
								qualityAtlas = "professions-icon-quality-tier3-inv"
							end

							if qualityAtlas ~= "" then
								-- Negatives Offset um über dem Icon zu liegen
								iconWithOverlay = iconWithOverlay .. string.format("|A:%s:16:16:-20:0|a", qualityAtlas)
							end
						end
					end

					farmbarGroup.args.categories.args[category.key].args["exp_" .. expKey].args[itemKey] = {
						type = "toggle",
						name = iconWithOverlay .. " " .. itemName,
						desc = string.format("Item ID: %d", item.id),
						width = "full",
						get = function()
							-- Prüfe ob Item in der Kategorie ist
							for _, id in ipairs(db.categories[category.key].items) do
								if id == item.id then
									return true
								end
							end
							return false
						end,
						set = function(info, value)
							if value then
								-- Item hinzufügen
								Farmbar:AddItemToCategory(category.key, item.id)
							else
								-- Item entfernen
								Farmbar:RemoveItemFromCategory(category.key, item.id)
							end
							Farmbar:UpdateBars()
						end,
						order = idx,
					}
				end

				order = order + 1
			end
		end

		-- "Alle auswählen/abwählen" Buttons am Ende
		farmbarGroup.args.categories.args[category.key].args["actions"] = {
			type = "group",
			name = "Aktionen",
			order = 100,
			inline = true,
			args = {
				selectAll = {
					type = "execute",
					name = "Alle auswählen",
					desc = "Wählt alle verfügbaren Items für diese Kategorie aus",
					func = function()
						local items = Farmbar:GetAvailableItemsForCategory(category.key)
						for _, item in ipairs(items) do
							Farmbar:AddItemToCategory(category.key, item.id)
						end
						Farmbar:UpdateBars()
					end,
					order = 1,
				},
				clearAll = {
					type = "execute",
					name = "Alle abwählen",
					desc = "Entfernt alle Items aus dieser Kategorie",
					confirm = true,
					confirmText = "Alle Items aus dieser Kategorie entfernen?",
					func = function()
						db.categories[category.key].items = {}
						Farmbar:UpdateBars()
					end,
					order = 2,
				},
			},
		}
	end

	-- Farmbar-Gruppe zurückgeben
	-- Config.lua wird diese in kriemhildeOptions.args integrieren
	return farmbarGroup
end
