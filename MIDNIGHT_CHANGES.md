# GatherMate2 - Midnight Expansion Changes

## Overview
This document details all changes made to GatherMate2 to add full support for World of Warcraft: Midnight expansion (12.0.0), including new nodes, the Farmbar module, and critical compatibility fixes.

---

## New Features

### Farmbar Module (GatherMate2Farmbar.lua)

A new tracking bar that displays collected Midnight resources in real-time.

**Features:**
- Displays collected herbs, seeds, ores, and fish with icons and counts
- Separate bars for each profession (Herbalism, Mining, Fishing)
- Draggable bars with saved positions
- Automatic updates when inventory changes
- Debug mode for troubleshooting
- Full localization support (English/German)

**Tracked Items:**

| Category | Items | Tracking Method |
|----------|-------|-----------------|
| Herbs | Argentleaf, Mana Lily, Tranquility Bloom, Sanguithorn, Azeroot | Paired IDs (2 per herb) |
| Seeds | Resilient Seed, Glowing Resilient Seed, Wild Resilient Seed, Primal Resilient Seed | Single ID each |
| Ores | Refulgent Copper, Umbral Tin, Brilliant Silver | Paired IDs (2 per ore) |
| Fish | 7 Midnight fish types | Single ID each |

**Slash Commands:**
- `/gmfarmbar toggle` - Enable/disable Farmbar
- `/gmfarmbar reset` - Reset bar positions
- `/gmfarmbar refresh` - Refresh display
- `/gmfarmbar debug` - Toggle debug mode
- `/gmfarmbar scan` - Scan inventory (shows item IDs)
- `/gmfarmbar config` - Open options

**Configuration:**
Available in GatherMate2 options under "Farmbar" tab with toggles for:
- Enable/disable Farmbar
- Show/hide Herbs
- Show/hide Ores
- Show/hide Fish
- Debug mode

### Debug Spell-ID Toggle

Added a permanent debug option in GatherMate2 settings to display spell information when gathering:

**Location:** GatherMate2 Options > General > Debug section

**Output format:**
```
GatherMate2 DEBUG: SpellID: 471013 | Name: Mining | Target: Refulgent Copper
```

---

## Modified Files

### 1. Constants.lua

#### Expansion Declaration
```lua
local MIDNIGHT = 12
```

#### Fishing Nodes (6 pools)
```lua
-- Midnight Pools
[NL["Hunter Surge"]]      = 1131,
[NL["Surface Ripple"]]    = 1132,
[NL["Bubbling Bloom"]]    = 1133,
[NL["Lost Treasures"]]    = 1134,
[NL["Sunwell Swarm"]]     = 1135,
[NL["Song Swarm"]]        = 1136,
```

#### Mining Nodes (3 types + variants)

**Refulgent Copper (Base ID: 1245)**
```lua
[NL["Refulgent Copper"]] = {
    id = 1245,
    variants = {
        NL["Voidbound Refulgent Copper"],
        NL["Lightfused Refulgent Copper"],
        NL["Rich Refulgent Copper"],
        NL["Primal Refulgent Copper"],
        NL["Wild Refulgent Copper"]
    },
    old_ids = { 1247, 1248, 1249, 1250, 1263 },
},
[NL["Refulgent Copper Seam"]] = 1246,
```

**Umbral Tin (Base ID: 1251)**
```lua
[NL["Umbral Tin"]] = {
    id = 1251,
    variants = { ... },
    old_ids = { 1253, 1254, 1255, 1256, 1264 },
},
[NL["Umbral Tin Seam"]] = 1252,
```

**Brilliant Silver (Base ID: 1257)**
```lua
[NL["Brilliant Silver"]] = {
    id = 1257,
    variants = { ... },
    old_ids = { 1259, 1260, 1261, 1262, 1265 },
},
[NL["Brilliant Silver Seam"]] = 1258,
```

#### Herbalism Nodes (5 types + variants)

**Argentleaf (Base ID: 1481)**
```lua
[NL["Argentleaf"]] = {
    id = 1481,
    variants = {
        NL["Wild Argentleaf"],
        NL["Lush Argentleaf"],
        NL["Voidbound Argentleaf"],
        NL["Lightfused Argentleaf"],
        NL["Primal Argentleaf"]
    },
    old_ids = { 1482, 1483, 1484, 1485, 1486 },
},
```

**Mana Lily (Base ID: 1487)**
```lua
[NL["Mana Lily"]] = {
    id = 1487,
    variants = { ... },
    old_ids = { 1488, 1489, 1490, 1491, 1492 },
},
```

**Tranquility Bloom (Base ID: 1493)**
```lua
[NL["Tranquility Bloom"]] = {
    id = 1493,
    variants = { ... },
    old_ids = { 1494, 1495, 1496, 1497, 1498 },
},
```

**Sanguithorn (Base ID: 1499)**
```lua
[NL["Sanguithorn"]] = {
    id = 1499,
    variants = {
        NL["Wild Sanguithorn"],
        NL["Lush Sanguithorn"],
        NL["Voidbound Sanguithorn"],
        NL["Lightfused Sanguithorn"],
        NL["Primal Sanguithorn"]
    },
    old_ids = { 1500, 1501, 1502, 1503, 1504 },
},
```

**Azeroot (Base ID: 1505)**
```lua
[NL["Azeroot"]] = {
    id = 1505,
    variants = {
        NL["Wild Azeroot"],
        NL["Lush Azeroot"],
        NL["Voidbound Azeroot"],
        NL["Lightfused Azeroot"],
        NL["Primal Azeroot"]
    },
    old_ids = { 1506, 1507, 1508, 1509, 1510 },
},
```

#### Treasure Nodes
```lua
-- The War Within
[NL["Disturbed Earth"]] = 566,
```

#### Node Expansion Table

**Mining Section:**
```lua
-- Midnight
[1245] = MIDNIGHT,  -- Refulgent Copper
[1246] = MIDNIGHT,  -- Refulgent Copper Seam
[1251] = MIDNIGHT,  -- Umbral Tin
[1252] = MIDNIGHT,  -- Umbral Tin Seam
[1257] = MIDNIGHT,  -- Brilliant Silver
[1258] = MIDNIGHT,  -- Brilliant Silver Seam
```

**Herb Gathering Section:**
```lua
-- Midnight
[1481] = MIDNIGHT,  -- Argentleaf
[1487] = MIDNIGHT,  -- Mana Lily
[1493] = MIDNIGHT,  -- Tranquility Bloom
[1499] = MIDNIGHT,  -- Sanguithorn
[1505] = MIDNIGHT,  -- Azeroot
```

### 2. Collector.lua

#### Custom Event Frame (Midnight 12.0.0 Workaround)
```lua
-- Workaround for WoW 12.0.0 Midnight: Create our own event frame to bypass AceEvent taint issues
local CollectorEventFrame = CreateFrame("Frame", "GatherMate2CollectorFrame")
local eventHandlers = {}
```

#### Mining Spells
```lua
local miningSpell = (GetSpellName(2575))
local miningSpell2 = (GetSpellName(195122))
local miningSpell3 = (GetSpellName(423341)) -- Khaz Algar
local miningSpell4 = (GetSpellName(471013)) -- Midnight
```

#### Spell Table Additions
```lua
[205243] = "Treasure", -- skinning ground warts
[469894] = "Treasure", -- Erde ebnen / Level Earth (Disturbed Earth)
-- Midnight spell (only add if it exists)
if miningSpell4 then spells[miningSpell4] = "Mining" end
```

#### Debug Output in SpellStarted
```lua
-- Debug output if enabled in settings
if GatherMate.db.profile.debugSpells then
    local debugSpellName = GetSpellName(spellcast) or "Unknown"
    print(string.format("|cff00ff00GatherMate2 DEBUG:|r SpellID: %s | Name: %s | Target: %s",
        tostring(spellcast), debugSpellName, tostring(target)))
end
```

#### Event Registration Changes
- Uses custom `CollectorEventFrame` instead of AceEvent
- `COMBAT_LOG_EVENT_UNFILTERED` is BLOCKED in Midnight 12.0.0
- Events registered via `PLAYER_LOGIN` handler

### 3. Config.lua

#### Debug Toggle Option
```lua
debugHeader = {
    order = 90,
    type = "header",
    name = "Debug",
},
debugSpells = {
    order = 91,
    name = "Debug Spell-IDs",
    desc = "Shows Spell-ID, Name and Target in chat when gathering nodes.",
    type = "toggle",
    width = "full",
    get = function() return db.debugSpells end,
    set = function(_, v) db.debugSpells = v end,
},
```

### 4. GatherMate2.lua

#### Default Settings Addition
```lua
local defaults = {
    profile = {
        scale       = 1.0,
        miniscale   = 0.75,
        alpha       = 1,
        debugSpells = false,  -- NEW: Debug toggle
        show = { ... },
        ...
    }
}
```

### 5. Locales/GatherMate2-enUS.lua

#### Midnight Node Localizations
- 5 Herb types with 5 variants each (30 entries)
- 3 Mining types with 5 variants + seam each (21 entries)
- 6 Fishing pools
- Disturbed Earth treasure

#### Farmbar Localizations (45 entries)
```lua
-- Farmbar Options
L["Farmbar"] = true
L["Farmbar Settings"] = true
L["Enable Farmbar"] = true
L["Show Herbs"] = true
L["Show Ores"] = true
L["Show Fish"] = true
L["Debug Mode"] = true
L["Refresh"] = true
L["Reset Positions"] = true
L["Scan Inventory"] = true
-- ... and more
```

### 6. Locales/GatherMate2-deDE.lua

#### German Translations

**Herbs:**
| English | German |
|---------|--------|
| Argentleaf | Argentumblatt |
| Mana Lily | Manalilie |
| Tranquility Bloom | Harmonieblume |
| Sanguithorn | Sanguithorn |
| Azeroot | Azeroot |

**Mining:**
| English | German |
|---------|--------|
| Refulgent Copper | Glänzendes Kupfer |
| Umbral Tin | Umbralzinn |
| Brilliant Silver | Brillantes Silber |
| Seam | -flöz |

**Fishing:**
| English | German |
|---------|--------|
| Hunter Surge | Jägerwoge |
| Surface Ripple | Oberflächenkräuseln |
| Bubbling Bloom | Blubbernde Blüte |
| Lost Treasures | Verlorene Schätze |
| Sunwell Swarm | Sonnenbrunnen-Schwarm |
| Song Swarm | Gesangsschwarm |

**Treasure:**
| English | German |
|---------|--------|
| Disturbed Earth | Aufgewühlte Erde |

**Variant Prefixes:**
| English | German |
|---------|--------|
| Wild | Wildes/Wilde |
| Lush | Üppiges/Üppige |
| Voidbound | Leerengebundenes/Leerengebundene |
| Lightfused | Lichtverschmolzenes/Lichtverschmolzene |
| Primal | Urtümliches/Urtümliche |
| Rich | Reiches |

#### Farmbar German Translations
```lua
L["Farmbar"] = "Farmbar"
L["Enable Farmbar"] = "Farmbar aktivieren"
L["Show Herbs"] = "Kräuter anzeigen"
L["Show Ores"] = "Erze anzeigen"
L["Show Fish"] = "Fische anzeigen"
L["Debug Mode"] = "Debug-Modus"
L["Refresh"] = "Aktualisieren"
L["Reset Positions"] = "Positionen zurücksetzen"
L["Herbalism"] = "Kräuterkunde"
L["Mining"] = "Bergbau"
L["Left-click + drag to move"] = "Linksklick + Ziehen zum Verschieben"
-- ... and more
```

### 7. GatherMate2.toc

```lua
## Interface: 120000
```

### 8. GatherMate2Farmbar.lua (NEW FILE)

Complete Farmbar module implementation (~820 lines):
- Module initialization and database setup
- Bar creation and UI management
- Item tracking with paired/single ID support
- Position saving/loading
- Inventory scanning
- Slash command integration
- Full localization support

---

## Node ID Summary

### Fishing (1131-1136)
| ID | Node |
|----|------|
| 1131 | Hunter Surge |
| 1132 | Surface Ripple |
| 1133 | Bubbling Bloom |
| 1134 | Lost Treasures |
| 1135 | Sunwell Swarm |
| 1136 | Song Swarm |

### Mining (1245-1265)

**Refulgent Copper:**
- 1245: Base | 1246: Seam | 1247-1250, 1263: Variants

**Umbral Tin:**
- 1251: Base | 1252: Seam | 1253-1256, 1264: Variants

**Brilliant Silver:**
- 1257: Base | 1258: Seam | 1259-1262, 1265: Variants

### Herbalism (1481-1510)

**Argentleaf:** 1481 (base), 1482-1486 (variants)
**Mana Lily:** 1487 (base), 1488-1492 (variants)
**Tranquility Bloom:** 1493 (base), 1494-1498 (variants)
**Sanguithorn:** 1499 (base), 1500-1504 (variants)
**Azeroot:** 1505 (base), 1506-1510 (variants)

### Treasure
| ID | Node |
|----|------|
| 566 | Disturbed Earth |

---

## Farmbar Item IDs

### Herbs (Paired Tracking)
| Herb | Icon ID | Track ID 1 | Track ID 2 |
|------|---------|------------|------------|
| Argentleaf | 236777 | 236776 | 236777 |
| Mana Lily | 236778 | 236778 | 236779 |
| Tranquility Bloom | 236761 | 236761 | 236767 |
| Sanguithorn | 236770 | 236770 | 236771 |
| Azeroot | 236774 | 236774 | 236775 |

### Seeds (Single Tracking)
| Seed | Item ID |
|------|---------|
| Resilient Seed | 237497 |
| Glowing Resilient Seed | 237498 |
| Wild Resilient Seed | 237499 |
| Primal Resilient Seed | 237500 |

### Ores (Paired Tracking)
| Ore | Icon ID | Track ID 1 | Track ID 2 |
|-----|---------|------------|------------|
| Refulgent Copper | 237359 | 237359 | 237361 |
| Umbral Tin | 237362 | 237362 | 237363 |
| Brilliant Silver | 237364 | 237364 | 237365 |

### Fish (Single Tracking)
| Fish | Item ID |
|------|---------|
| Fish 1 | 238370 |
| Fish 2 | 238383 |
| Fish 3 | 238366 |
| Fish 4 | 238371 |
| Fish 5 | 238384 |
| Fish 6 | 238372 |
| Fish 7 | 238365 |

---

## Technical Notes

### Event System Workaround
WoW 12.0.0 Midnight introduced taint issues with AceEvent. The solution:
1. Create a custom frame `CollectorEventFrame`
2. Register events directly on the frame
3. Map events to handler functions via `eventHandlers` table
4. `COMBAT_LOG_EVENT_UNFILTERED` is now protected and unavailable

### Disturbed Earth Detection
- Non-miners interact with Disturbed Earth using spell ID 469894 ("Level Earth" / "Erde ebnen")
- Miners use their mining spell which triggers a UI error
- Both methods are now supported for tracking

### Farmbar Paired vs Single Tracking
- **Paired**: Herbs and ores have two item IDs (e.g., normal + rare quality)
- **Single**: Seeds and fish have only one item ID
- The Farmbar automatically sums paired items for display

### Locale System
- GitHub source uses `@localization@` packager directives
- These are only filled during CurseForge packaging
- Custom Midnight nodes are added manually after the directives
- TWW translations were merged from CurseForge release

---

## Summary of Changes

**New Nodes:**
- 6 Fishing pools (IDs 1131-1136)
- 3 Mining types with variants (IDs 1245-1265)
- 5 Herbalism types with variants (IDs 1481-1510)
- 1 Treasure node (Disturbed Earth, ID 566)
- **Total: 51+ new nodes**

**New Features:**
- Farmbar module for real-time resource tracking
- Debug spell-ID toggle in settings
- Seeds tracking support
- Full English/German localization

**Critical Fixes:**
- Custom event frame for Midnight 12.0.0 AceEvent taint
- Mining spell 4 (471013) for Midnight
- Spell 469894 for Disturbed Earth
- COMBAT_LOG_EVENT_UNFILTERED blocked handling

---

## Testing Checklist

- [x] Nodes appear correctly on map
- [x] Variants track to base nodes properly
- [x] German localizations display correctly
- [x] Expansion filtering works for MIDNIGHT
- [x] Mining spell 4 detection works
- [x] Event system works without taint errors
- [x] Debug toggle works in settings
- [x] Disturbed Earth tracking works
- [ ] Farmbar displays correctly
- [ ] Farmbar positions save/load
- [ ] All fish IDs confirmed

---

## Compatibility

- World of Warcraft: Midnight (12.0.0+)
- World of Warcraft: The War Within (11.x) - Retail version
- GatherMate2 master branch structure
- English (enUS) and German (deDE) clients

---

## Credits

- GatherMate2 structure by Nevcairiel
- Variant system from commit 55a48d91ba92e130858c8801a1021d27ecfe2525
- Midnight expansion node data provided by community
- Midnight compatibility fixes for WoW 12.0.0

---

*Document created: 2025-01-18*
*Last updated: 2025-11-22*
