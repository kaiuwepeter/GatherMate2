#!/usr/bin/env python3
"""
Formats GatherMate2 Storage SavedVariables with zone and node names as comments.
"""

import re
import os

# Zone ID to Name mapping (Midnight)
ZONE_NAMES = {
    2393: "Silbermond",
    2395: "Immersangwald",
    2405: "Leerensturm",
    2413: "Harandar",
    2437: "Zul'Aman",
    2444: "Schlächteranhöhe",
    2536: "Atal'Aman",
    2537: "Quel'Thalas",
    2552: "Voidstorm",
    2553: "Voidstorm Subzone 1",
    2554: "Voidstorm Subzone 2",
    2555: "Voidstorm Subzone 3",
    2556: "Voidstorm Subzone 4",
    2557: "Voidstorm Subzone 5",
}

# Node ID to Name mapping (from Constants.lua)
# Herbs (Midnight)
HERB_NODES = {
    1481: "Tranquility Bloom",
    1482: "Gilded Tranquility Bloom",
    1483: "Lush Tranquility Bloom",
    1484: "Crystallized Tranquility Bloom",
    1485: "Sanguithorn",
    1486: "Gilded Sanguithorn",
    1487: "Lush Sanguithorn",
    1488: "Crystallized Sanguithorn",
    1489: "Azeroot",
    1490: "Gilded Azeroot",
    1491: "Lush Azeroot",
    1492: "Crystallized Azeroot",
    1493: "Umgepflanzte Harmonieblume",  # Transplanted Tranquility Bloom
    1494: "Umgepflanzter Rotdorn",  # Transplanted Sanguithorn
    1495: "Umgepflanzte Azerwurz",  # Transplanted Azeroot
    1496: "Umgepflanztes Argentumblatt",  # Transplanted Argentleaf
    1497: "Umgepflanzte Manalilie",  # Transplanted Mana Lily
    1498: "Argentleaf",
    1499: "Gilded Argentleaf",
    1500: "Lush Argentleaf",
    1501: "Crystallized Argentleaf",
    1502: "Mana Lily",
    1503: "Gilded Mana Lily",
    1504: "Lush Mana Lily",
    1505: "Crystallized Mana Lily",
    1506: "Voidbound Mana Lily",
    1507: "Voidbound Argentleaf",
    1508: "Voidbound Tranquility Bloom",
    1509: "Voidbound Sanguithorn",
}

# Mining nodes (Midnight)
MINE_NODES = {
    1245: "Refulgent Copper",
    1246: "Gilded Refulgent Copper",
    1247: "Primal Refulgent Copper",
    1248: "Crystallized Refulgent Copper",
    1249: "Umbral Tin",
    1250: "Gilded Umbral Tin",
    1251: "Primal Umbral Tin",
    1252: "Crystallized Umbral Tin",
    1253: "Brilliant Silver",
    1254: "Gilded Brilliant Silver",
    1255: "Primal Brilliant Silver",
    1256: "Crystallized Brilliant Silver",
    1257: "Umgepflanztes glänzendes Kupfer",  # Transplanted Refulgent Copper
    1258: "Umgepflanztes Umbralzinn",  # Transplanted Umbral Tin
    1259: "Umgepflanztes brillantes Silber",  # Transplanted Brilliant Silver
    1260: "Voidbound Refulgent Copper",
    1261: "Voidbound Umbral Tin",
    1263: "Voidbound Brilliant Silver",
    1264: "Rich Refulgent Copper",
    1265: "Rich Umbral Tin",
}

# Fish nodes (Midnight)
FISH_NODES = {
    1131: "Gloomweaver School",
    1132: "Runescarred Char School",
    1133: "Ambereel Swarm",
    1134: "Lost Treasures",
    1135: "Sunwell Swarm",
    1136: "Song Swarm",
    1137: "Oceanic Vortex",
}

def get_node_name(node_id, db_type):
    """Get node name based on database type."""
    if "Herb" in db_type:
        return HERB_NODES.get(node_id, f"Unknown Herb {node_id}")
    elif "Mine" in db_type:
        return MINE_NODES.get(node_id, f"Unknown Ore {node_id}")
    elif "Fish" in db_type:
        return FISH_NODES.get(node_id, f"Unknown Fish {node_id}")
    else:
        return f"Unknown {node_id}"

def format_storage_file(input_path, output_path=None):
    """Format the storage file with comments."""
    if output_path is None:
        output_path = input_path.replace('.lua', '_formatted.lua')

    with open(input_path, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')
    formatted_lines = []
    current_db = None
    current_zone = None

    for line in lines:
        # Detect database type
        db_match = re.match(r'^(GatherMate2\w+DB\w+)\s*=\s*\{', line)
        if db_match:
            current_db = db_match.group(1)
            formatted_lines.append(line)
            continue

        # Detect zone ID
        zone_match = re.match(r'^\s*\[(\d+)\]\s*=\s*\{', line)
        if zone_match:
            zone_id = int(zone_match.group(1))
            current_zone = zone_id
            zone_name = ZONE_NAMES.get(zone_id, f"Unknown Zone")
            # Add zone name as comment
            formatted_lines.append(f"[{zone_id}] = {{ -- {zone_name}")
            continue

        # Detect node entry
        node_match = re.match(r'^(\s*)\[(\d+)\]\s*=\s*(\d+),?', line)
        if node_match and current_db:
            indent = node_match.group(1)
            coord = node_match.group(2)
            node_id = int(node_match.group(3))
            node_name = get_node_name(node_id, current_db)
            formatted_lines.append(f"{indent}[{coord}] = {node_id}, -- {node_name}")
            continue

        # Keep other lines as-is
        formatted_lines.append(line)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(formatted_lines))

    print(f"Formatted file saved to: {output_path}")
    return output_path

if __name__ == "__main__":
    # Default paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    saved_vars_path = r"D:\Blizz\World of Warcraft\_beta_\WTF\Account\1939840#1\SavedVariables\GatherMate2Storage_Midnight.lua"

    if os.path.exists(saved_vars_path):
        format_storage_file(saved_vars_path)
    else:
        print(f"File not found: {saved_vars_path}")
        print("Please update the path in this script.")
