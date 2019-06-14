#!/bin/sh/
# ======================================================
# This script will populate the entire week in TOGGL
# ======================================================
#
# Requirements:
#  - brew coreutils (brew install coreutils) for gdate
#  - Python 3.7.3
#  - togglCli for python (pip install togglCli)
# =====================================================


function this_week()
{
# find the current day index
INDEX_DAY=`gdate +%u`

# set for each day two time slot
for index in `seq 1 1 5`; do
	DATE=`gdate -d $(($index-$INDEX_DAY))-days +%Y-%m-%d`
	toggl add "$DATE 9:00AM" "$DATE 1:00PM" "mattina"
	toggl add "$DATE 2:00PM" "$DATE 6:00PM" "pomeriggio"
done
}

this_week