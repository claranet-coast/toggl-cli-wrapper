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
    # find the number of days in this month
    AMOUNT_DAYS_MONTH=`echo $(cal) | tail -c 3`
    # set for each working day two time slot
    for index in `seq 1 1 $AMOUNT_DAYS_MONTH`; do
        weekend_check=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
        if [ "$weekend_check" -le "5" ]; then
            DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
            toggl add "$DATE 9:00AM" "$DATE 1:00PM" "mattina"
            toggl add "$DATE 2:00PM" "$DATE 6:00PM" "pomeriggio"
        fi
    done
}


function range_same_month()
{
    if [ $# -eq 2 ]; then
        if [ $1 -lt $2 ]; then
            # find the current day index
            INDEX_CURRENT_DAY=`gdate +%d`
            # set for each working day two time slot
            for index in `seq $1 1 $2`; do
                weekend_check=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
                if [ "$weekend_check" -le "5" ]; then
                    DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
                    toggl add "$DATE 9:00AM" "$DATE 1:00PM" "mattina"
                    toggl add "$DATE 2:00PM" "$DATE 6:00PM" "pomeriggio"
                fi
            done
        else
            echo "Starting day must be smaller than ending day."
        fi
    else
        echo "Wrong number of parameters. Insert starting and ending day."
    fi
}


function range()
{
    if [ $# -eq 2 ]; then
        if [ $1 -lt $2 ]; then
            # find the current day index
            INDEX_CURRENT_DAY=`gdate +%d`
            # set for each working day two time slot
            for index in `seq $1 1 $2`; do
                weekend_check=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
                if [ "$weekend_check" -le "5" ]; then
                    DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
                    toggl add "$DATE 9:00AM" "$DATE 1:00PM" "mattina"
                    toggl add "$DATE 2:00PM" "$DATE 6:00PM" "pomeriggio"
                fi
            done
        else
            # find the current day index
            INDEX_CURRENT_DAY=`gdate +%d`
            # find the current month index
            INDEX_CURRENT_MONTH=`gdate +%m`
            # find the number of days in this month
            AMOUNT_DAYS_MONTH=`echo $(cal $(($INDEX_CURRENT_MONTH-1))) | tail -c 3`
            # set for each working day two time slot
            for index in `seq $(($1-$AMOUNT_DAYS_MONTH)) 1 $2`; do
                weekend_check=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
                if [ "$weekend_check" -le "5" ]; then
                    DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
                    toggl add "$DATE 9:00AM" "$DATE 1:00PM" "mattina"
                    toggl add "$DATE 2:00PM" "$DATE 6:00PM" "pomeriggio"
                fi
            done
        fi
    else
        echo "Wrong number of parameters. Insert starting and ending day."
    fi
}

range 26 14


