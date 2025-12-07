-- ============================================================
-- Kriemhilde Node Data Merger
-- Combines split data files into single tables
-- Supports versioning and update databases
-- ============================================================

-- Helper function to merge tables
local function MergeTables(target, ...)
    target = target or {}
    for i = 1, select("#", ...) do
        local source = select(i, ...)
        if source then
            for mapID, nodes in pairs(source) do
                if not target[mapID] then
                    target[mapID] = {}
                end
                for coord, nodeType in pairs(nodes) do
                    target[mapID][coord] = nodeType
                end
            end
        end
    end
    return target
end

-- Helper function to get max version from all expansion files
local function GetMaxVersion(...)
    local maxVersion = 0
    for i = 1, select("#", ...) do
        local version = select(i, ...)
        if version and version > maxVersion then
            maxVersion = version
        end
    end
    return maxVersion
end

-- Merge Mining databases
Kriemhilde_MineDB = MergeTables(nil,
    Kriemhilde_MineDB_Classic,
    Kriemhilde_MineDB_TBC,
    Kriemhilde_MineDB_Wrath,
    Kriemhilde_MineDB_Cata,
    Kriemhilde_MineDB_MoP,
    Kriemhilde_MineDB_WoD,
    Kriemhilde_MineDB_Legion,
    Kriemhilde_MineDB_BFA,
    Kriemhilde_MineDB_Shadowlands,
    Kriemhilde_MineDB_Dragonflight,
    Kriemhilde_MineDB_WarWithin
)

-- Merge Herbalism databases
Kriemhilde_HerbDB = MergeTables(nil,
    Kriemhilde_HerbDB_Classic,
    Kriemhilde_HerbDB_TBC,
    Kriemhilde_HerbDB_Wrath,
    Kriemhilde_HerbDB_Cata,
    Kriemhilde_HerbDB_MoP,
    Kriemhilde_HerbDB_WoD,
    Kriemhilde_HerbDB_Legion,
    Kriemhilde_HerbDB_BFA,
    Kriemhilde_HerbDB_Shadowlands,
    Kriemhilde_HerbDB_Dragonflight,
    Kriemhilde_HerbDB_WarWithin
)

-- Merge Fishing databases
Kriemhilde_FishDB = MergeTables(nil,
    Kriemhilde_FishDB_Classic,
    Kriemhilde_FishDB_TBC,
    Kriemhilde_FishDB_Wrath,
    Kriemhilde_FishDB_Cata,
    Kriemhilde_FishDB_MoP,
    Kriemhilde_FishDB_WoD,
    Kriemhilde_FishDB_Legion,
    Kriemhilde_FishDB_BFA,
    Kriemhilde_FishDB_Shadowlands,
    Kriemhilde_FishDB_Dragonflight,
    Kriemhilde_FishDB_WarWithin
)

-- Merge Logging databases
Kriemhilde_LoggingDB = MergeTables(nil,
    Kriemhilde_LoggingDB_Dragonflight,
    Kriemhilde_LoggingDB_WarWithin
)

-- Merge Treasure databases
Kriemhilde_TreasureDB = MergeTables(nil,
    Kriemhilde_TreasureDB_Classic,
    Kriemhilde_TreasureDB_TBC,
    Kriemhilde_TreasureDB_Wrath,
    Kriemhilde_TreasureDB_Cata,
    Kriemhilde_TreasureDB_MoP,
    Kriemhilde_TreasureDB_WoD,
    Kriemhilde_TreasureDB_Legion,
    Kriemhilde_TreasureDB_BFA,
    Kriemhilde_TreasureDB_Shadowlands,
    Kriemhilde_TreasureDB_Dragonflight,
    Kriemhilde_TreasureDB_WarWithin
)

-- Clean up individual expansion tables to save memory
Kriemhilde_MineDB_Classic = nil
Kriemhilde_MineDB_TBC = nil
Kriemhilde_MineDB_Wrath = nil
Kriemhilde_MineDB_Cata = nil
Kriemhilde_MineDB_MoP = nil
Kriemhilde_MineDB_WoD = nil
Kriemhilde_MineDB_Legion = nil
Kriemhilde_MineDB_BFA = nil
Kriemhilde_MineDB_Shadowlands = nil
Kriemhilde_MineDB_Dragonflight = nil
Kriemhilde_MineDB_WarWithin = nil

Kriemhilde_HerbDB_Classic = nil
Kriemhilde_HerbDB_TBC = nil
Kriemhilde_HerbDB_Wrath = nil
Kriemhilde_HerbDB_Cata = nil
Kriemhilde_HerbDB_MoP = nil
Kriemhilde_HerbDB_WoD = nil
Kriemhilde_HerbDB_Legion = nil
Kriemhilde_HerbDB_BFA = nil
Kriemhilde_HerbDB_Shadowlands = nil
Kriemhilde_HerbDB_Dragonflight = nil
Kriemhilde_HerbDB_WarWithin = nil

Kriemhilde_FishDB_Classic = nil
Kriemhilde_FishDB_TBC = nil
Kriemhilde_FishDB_Wrath = nil
Kriemhilde_FishDB_Cata = nil
Kriemhilde_FishDB_MoP = nil
Kriemhilde_FishDB_WoD = nil
Kriemhilde_FishDB_Legion = nil
Kriemhilde_FishDB_BFA = nil
Kriemhilde_FishDB_Shadowlands = nil
Kriemhilde_FishDB_Dragonflight = nil
Kriemhilde_FishDB_WarWithin = nil

Kriemhilde_LoggingDB_Dragonflight = nil
Kriemhilde_LoggingDB_WarWithin = nil

Kriemhilde_TreasureDB_Classic = nil
Kriemhilde_TreasureDB_TBC = nil
Kriemhilde_TreasureDB_Wrath = nil
Kriemhilde_TreasureDB_Cata = nil
Kriemhilde_TreasureDB_MoP = nil
Kriemhilde_TreasureDB_WoD = nil
Kriemhilde_TreasureDB_Legion = nil
Kriemhilde_TreasureDB_BFA = nil
Kriemhilde_TreasureDB_Shadowlands = nil
Kriemhilde_TreasureDB_Dragonflight = nil
Kriemhilde_TreasureDB_WarWithin = nil

-- ============================================================
-- Set Global Version Variables (required by GatherMate2.lua)
-- ============================================================

-- Mining versions - use the highest version from all expansions
Kriemhilde_MineData_Version = GetMaxVersion(
    Kriemhilde_MiningData_Classic_Version,
    Kriemhilde_MiningData_TBC_Version,
    Kriemhilde_MiningData_Wrath_Version,
    Kriemhilde_MiningData_Cata_Version,
    Kriemhilde_MiningData_MoP_Version,
    Kriemhilde_MiningData_WoD_Version,
    Kriemhilde_MiningData_Legion_Version,
    Kriemhilde_MiningData_BFA_Version,
    Kriemhilde_MiningData_Shadowlands_Version,
    Kriemhilde_MiningData_Dragonflight_Version,
    Kriemhilde_MiningData_WarWithin_Version
)
Kriemhilde_MineData_UpdateNumber = 0  -- 0 = full database, >0 = incremental update
Kriemhilde_MineData_BaseVersion = Kriemhilde_MineData_Version

-- Herbalism versions
Kriemhilde_HerbData_Version = GetMaxVersion(
    Kriemhilde_HerbalismData_Classic_Version,
    Kriemhilde_HerbalismData_TBC_Version,
    Kriemhilde_HerbalismData_Wrath_Version,
    Kriemhilde_HerbalismData_Cata_Version,
    Kriemhilde_HerbalismData_MoP_Version,
    Kriemhilde_HerbalismData_WoD_Version,
    Kriemhilde_HerbalismData_Legion_Version,
    Kriemhilde_HerbalismData_BFA_Version,
    Kriemhilde_HerbalismData_Shadowlands_Version,
    Kriemhilde_HerbalismData_Dragonflight_Version,
    Kriemhilde_HerbalismData_WarWithin_Version
)
Kriemhilde_HerbData_UpdateNumber = 0
Kriemhilde_HerbData_BaseVersion = Kriemhilde_HerbData_Version

-- Fishing versions
Kriemhilde_FishData_Version = GetMaxVersion(
    Kriemhilde_FishData_Classic_Version,
    Kriemhilde_FishData_TBC_Version,
    Kriemhilde_FishData_Wrath_Version,
    Kriemhilde_FishData_Cata_Version,
    Kriemhilde_FishData_MoP_Version,
    Kriemhilde_FishData_WoD_Version,
    Kriemhilde_FishData_Legion_Version,
    Kriemhilde_FishData_BFA_Version,
    Kriemhilde_FishData_Shadowlands_Version,
    Kriemhilde_FishData_Dragonflight_Version,
    Kriemhilde_FishData_WarWithin_Version
)
Kriemhilde_FishData_UpdateNumber = 0
Kriemhilde_FishData_BaseVersion = Kriemhilde_FishData_Version

-- Logging versions (Dragonflight+ only)
Kriemhilde_LoggingData_Version = GetMaxVersion(
    Kriemhilde_LoggingData_Dragonflight_Version,
    Kriemhilde_LoggingData_WarWithin_Version
)
Kriemhilde_LoggingData_UpdateNumber = 0
Kriemhilde_LoggingData_BaseVersion = Kriemhilde_LoggingData_Version

-- Treasure versions
Kriemhilde_TreasureData_Version = GetMaxVersion(
    Kriemhilde_TreasureData_Classic_Version,
    Kriemhilde_TreasureData_TBC_Version,
    Kriemhilde_TreasureData_Wrath_Version,
    Kriemhilde_TreasureData_Cata_Version,
    Kriemhilde_TreasureData_MoP_Version,
    Kriemhilde_TreasureData_WoD_Version,
    Kriemhilde_TreasureData_Legion_Version,
    Kriemhilde_TreasureData_BFA_Version,
    Kriemhilde_TreasureData_Shadowlands_Version,
    Kriemhilde_TreasureData_Dragonflight_Version,
    Kriemhilde_TreasureData_WarWithin_Version
)
Kriemhilde_TreasureData_UpdateNumber = 0
Kriemhilde_TreasureData_BaseVersion = Kriemhilde_TreasureData_Version

-- ============================================================
-- Update Database Support (optional)
-- If your scraper creates incremental update files, uncomment:
-- ============================================================

-- Example for incremental updates:
-- if Kriemhilde_MineUpdateDB then
--     Kriemhilde_MineData_UpdateNumber = 1  -- increment this for each update
-- end

-- Merge update databases if they exist
Kriemhilde_MineUpdateDB = MergeTables(nil,
    Kriemhilde_MineUpdateDB_Classic,
    Kriemhilde_MineUpdateDB_TBC,
    Kriemhilde_MineUpdateDB_Wrath,
    Kriemhilde_MineUpdateDB_Cata,
    Kriemhilde_MineUpdateDB_MoP,
    Kriemhilde_MineUpdateDB_WoD,
    Kriemhilde_MineUpdateDB_Legion,
    Kriemhilde_MineUpdateDB_BFA,
    Kriemhilde_MineUpdateDB_Shadowlands,
    Kriemhilde_MineUpdateDB_Dragonflight,
    Kriemhilde_MineUpdateDB_WarWithin
)

Kriemhilde_HerbUpdateDB = MergeTables(nil,
    Kriemhilde_HerbUpdateDB_Classic,
    Kriemhilde_HerbUpdateDB_TBC,
    Kriemhilde_HerbUpdateDB_Wrath,
    Kriemhilde_HerbUpdateDB_Cata,
    Kriemhilde_HerbUpdateDB_MoP,
    Kriemhilde_HerbUpdateDB_WoD,
    Kriemhilde_HerbUpdateDB_Legion,
    Kriemhilde_HerbUpdateDB_BFA,
    Kriemhilde_HerbUpdateDB_Shadowlands,
    Kriemhilde_HerbUpdateDB_Dragonflight,
    Kriemhilde_HerbUpdateDB_WarWithin
)

Kriemhilde_FishUpdateDB = MergeTables(nil,
    Kriemhilde_FishUpdateDB_Classic,
    Kriemhilde_FishUpdateDB_TBC,
    Kriemhilde_FishUpdateDB_Wrath,
    Kriemhilde_FishUpdateDB_Cata,
    Kriemhilde_FishUpdateDB_MoP,
    Kriemhilde_FishUpdateDB_WoD,
    Kriemhilde_FishUpdateDB_Legion,
    Kriemhilde_FishUpdateDB_BFA,
    Kriemhilde_FishUpdateDB_Shadowlands,
    Kriemhilde_FishUpdateDB_Dragonflight,
    Kriemhilde_FishUpdateDB_WarWithin
)

Kriemhilde_LoggingUpdateDB = MergeTables(nil,
    Kriemhilde_LoggingUpdateDB_Dragonflight,
    Kriemhilde_LoggingUpdateDB_WarWithin
)

Kriemhilde_TreasureUpdateDB = MergeTables(nil,
    Kriemhilde_TreasureUpdateDB_Classic,
    Kriemhilde_TreasureUpdateDB_TBC,
    Kriemhilde_TreasureUpdateDB_Wrath,
    Kriemhilde_TreasureUpdateDB_Cata,
    Kriemhilde_TreasureUpdateDB_MoP,
    Kriemhilde_TreasureUpdateDB_WoD,
    Kriemhilde_TreasureUpdateDB_Legion,
    Kriemhilde_TreasureUpdateDB_BFA,
    Kriemhilde_TreasureUpdateDB_Shadowlands,
    Kriemhilde_TreasureUpdateDB_Dragonflight,
    Kriemhilde_TreasureUpdateDB_WarWithin
)
