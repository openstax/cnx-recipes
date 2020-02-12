import sys
import json

raw_meta, baked_meta, baked_book = sys.argv[1:4]

json_data = {}

# Passthrough but can be used to extract metadata from bake-book step

with open(raw_meta, "r") as in_meta:
    json_data = json.load(in_meta)

with open(baked_meta, "w") as out_meta:
    json.dump(json_data, out_meta)