#!/bin/sh/


COMMAND='toggl'
MSG_MATTINA='mattina'
MSG_POMERIGGIO='pomeriggio'

PROJECT_ID=${PROJECT_ID:-'8107341'} # get with command: toggl projects ls

function this_day()
{
    DATE=`gdate -u +%Y-%m-%d`
    $COMMAND add -o "$PROJECT_ID" "$DATE 9:00AM" "$DATE 1:00PM" "$MSG_MATTINA"
    $COMMAND add -o "$PROJECT_ID" "$DATE 2:00PM" "$DATE 6:00PM" "$MSG_POMERIGGIO"

}


function this_week()
{
    # find the current day index
    INDEX_CURRENT_DAY=`gdate +%u`

    # set for each day two time slot
    for index in `seq 1 1 5`; do
        DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
        $COMMAND add -o "$PROJECT_ID" "$DATE 9:00AM" "$DATE 1:00PM" "$MSG_MATTINA"
        $COMMAND add -o "$PROJECT_ID" "$DATE 2:00PM" "$DATE 6:00PM" "$MSG_POMERIGGIO"
    done
}


function this_month()
{
    # find the current day index
    INDEX_CURRENT_DAY=`gdate +%d | sed s/^0//g`
    # find the number of days in this month
    AMOUNT_DAYS_MONTH=`echo $(cal) | tail -c 3`
    # set for each working day two time slot
    for index in `seq 1 1 $AMOUNT_DAYS_MONTH`; do
        weekend_check=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
        if [ "$weekend_check" -le "5" ]; then
            DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
            $COMMAND add -o "$PROJECT_ID" "$DATE 9:00AM" "$DATE 1:00PM" "$MSG_MATTINA"
            $COMMAND add -o "$PROJECT_ID" "$DATE 2:00PM" "$DATE 6:00PM" "$MSG_POMERIGGIO"
        fi
    done
}


function range_same_month()
{
    if [ $# -eq 2 ]; then
        if [ $1 -lt $2 ]; then
            # find the current day index
            INDEX_CURRENT_DAY=`gdate +%d | sed s/^0//g`
            # set for each working day two time slot
            for index in `seq $1 1 $2`; do
                weekend_check=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
                if [ "$weekend_check" -le "5" ]; then
                    DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
                    $COMMAND add -o "$PROJECT_ID" "$DATE 9:00AM" "$DATE 1:00PM" "$MSG_MATTINA"
                    $COMMAND add -o "$PROJECT_ID" "$DATE 2:00PM" "$DATE 6:00PM" "$MSG_POMERIGGIO"
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
        if [ $1 -le $2 ]; then
            # find the current day index
            INDEX_CURRENT_DAY=`gdate +%d | sed s/^0//g`
            # set for each working day two time slot
            for index in `seq $1 1 $2`; do
                weekend_check=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
                if [ "$weekend_check" -le "5" ]; then
                    DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
                    $COMMAND add -o "$PROJECT_ID" "$DATE 9:00AM" "$DATE 1:00PM" "$MSG_MATTINA"
                    $COMMAND add -o "$PROJECT_ID" "$DATE 2:00PM" "$DATE 6:00PM" "$MSG_POMERIGGIO"
                fi
            done
        else
            # find the current day index
            INDEX_CURRENT_DAY=`gdate +%d | sed s/^0//g`
            # find the current month index
            INDEX_CURRENT_MONTH=`gdate +%m`
            # find the number of days in this month
            AMOUNT_DAYS_MONTH=`echo $(cal $(($INDEX_CURRENT_MONTH-1))) | tail -c 3`
            # set for each working day two time slot
            for index in `seq $(($1-$AMOUNT_DAYS_MONTH)) 1 $2`; do
                weekend_check=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%u`
                if [ "$weekend_check" -le "5" ]; then
                    DATE=`gdate -d $(($index-$INDEX_CURRENT_DAY))-days +%Y-%m-%d`
                    $COMMAND add -o "$PROJECT_ID" "$DATE 9:00AM" "$DATE 1:00PM" "$MSG_MATTINA"
                    $COMMAND add -o "$PROJECT_ID" "$DATE 2:00PM" "$DATE 6:00PM" "$MSG_POMERIGGIO"
                fi
            done
        fi
    else
        echo "Wrong number of parameters. Insert starting and ending day."
    fi
}

usage()
{
cat << EOF
Usage:

To record a range: $0 <startday> <endday>

To run a function: $0 [this_month, this_week, this_day]

Wrapper to toggl cli.

EOF
}

function run_function()
{
    case $1 in
    'this_month')this_month;;
    'this_week')this_week;;
    'this_day')this_day;;
    *)echo "function not valid";;
    esac
}

case $# in
  0)usage;;
  1)run_function $1;;
  2)range $1 $2;;
  *)usage;;
esac
