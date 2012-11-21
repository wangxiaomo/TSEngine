#-*- coding: utf-8 -*-

import sys
if len(sys.argv)!=2:
    raise Exception("Need Parameter!")

import json
import os.path

data = open(sys.argv[1]).read()
data = eval(data)
basename = os.path.splitext(os.path.basename(sys.argv[1]))[0]
with open(basename + ".json", "w") as f:
    json.dump(data, f)
