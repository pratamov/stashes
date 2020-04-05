#!/bin/bash

if [ -z "$1" ]; then
	echo "./stock-idx-daily-historical.sh <YYYY-MM-DD>"
	exit
fi

FOLDER=""
if [ -z "$2" ];
then
	FOLDER="/tmp/stock-idx-daily-historical"
	mkdir -p $FOLDER
else
	FOLDER=$2
fi

if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$1" >/dev/null 2>&1; then
	DATE_PTR=$1
	while [ "$DATE_PTR" != $(date +'%Y-%m-%d') ];
	do
		DATE_FMT=${DATE_PTR//-}
		DATE_PTR=$(date -I -d "$DATE_PTR + 1 day")
		curl "https://www.idx.co.id/umbraco/Surface/TradingSummary/GetStockSummary?length=1000&start=0&date=$DATE_FMT" -o "$FOLDER/$DATE_FMT.json" >/dev/null 2>&1;
		echo "Downloading $FOLDER/$DATE_FMT.json"
	done
	exit
fi

echo "Invalid date \"$1\""