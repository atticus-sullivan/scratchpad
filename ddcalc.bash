#!/usr/bin/env sh


cd /media/daten/coding/scratchpad/

echo "Welcome to the Calculator." &&
	python3 -ic "from math import *; import sys ; from ddcalc import avg, table, tableL, sec2Str; sys.ps1='' ; from datetime import datetime,timedelta"
