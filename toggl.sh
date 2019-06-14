#!/bin/sh/


function this_day()
{
	DATE=`gdate -u +%Y-%m-%d`
	toggl add "$DATE 9:00AM" "$DATE 1:00PM" "mattina"
	toggl add "$DATE 2:00PM" "$DATE 6:00PM" "pomeriggio"

}


function this_week()
{
# find the current day index
INDEX_CURRENT_DAY=`gdate +%u`

# set for each day two time slot
for index in `seq 1 1 5`; do
	DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
	toggl add "$DATE 9:00AM" "$DATE 1:00PM" "mattina"
	toggl add "$DATE 2:00PM" "$DATE 6:00PM" "pomeriggio"
done
}


function this_month()
{
# find the current day index
INDEX_CURRENT_DAY=`gdate +%d`
# find the number of days in a month
AMOUNT_DAYS_MONTH=`echo $(cal) | tail -c 3`
# set for each working day two time slot
for index in `seq 1 1 $AMOUNT_DAYS_MONTH`; do
	tmp_date=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
	if [ "$tmp_date" -le "5" ]; then
		DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
		toggl add "$DATE 9:00AM" "$DATE 1:00PM" "mattina"
		toggl add "$DATE 2:00PM" "$DATE 6:00PM" "pomeriggio"
	fi
done
}

this_week