#!/bin/bash
echo "Fetching last 7 days data and writing to /cistorage/Pankaj/core_count_last7Days.txt"
find /ci/cir3/siebsrvr/bin -type f -mtime -7 -printf "%TD %p\n" | grep callstack* | sort  > /cistorage/Pankaj/core_count_last7Days.txt
echo "Saved last 7 days successfully."
declare -a keywords
echo "Reading keywords"
mapfile -t keywords < /cistorage/Pankaj/keywords.txt
echo "Kewywords read successfully"
reportFile="`date +%Y%m%d%H%M%S`core_count_last7Days_report.csv"
declare -A data
echo "Fetching unique dates"
find /ci/cir3/siebsrvr/bin -type f -mtime -7 -printf "%TD\n" | sort | uniq > uniquedates
echo "Fetched unique dates successfully"
header="Total Core Counts - Daily/Weekly"
echo "Generating header information"
while read line; do
  header="$header,$line"
done < "/cistorage/Pankaj/uniquedates"
echo "Generated header information successfully"
echo "Generating DateandKeywordpair count Information"
for keyword in "${keywords[@]}"
do
 while read line; do
    datein=`date --date=$line '+%s'`
    key="_$datein$keyword"
    data[$key]="0"
 done < "/cistorage/Pankaj/uniquedates"
done
#echo "${#data[*]}"
echo $header >> $reportFile
for keyword in "${keywords[@]}"
do
  while read line; do
     currdate=`echo $line | awk '{print $1}'`
     filename=`echo $line | awk '{print $2}'`
     count=`cat $filename | grep "$keyword" | wc -w`
     datein=`date --date=$currdate '+%s'`
     key="_$datein$keyword"
     data[$key]+=" $count"
  done < "/cistorage/Pankaj/core_count_last7Days.txt"
done
echo "Generated DateandKeywordpair successfully, writing to the report file ($reportFile)"

for keyword in "${keywords[@]}"
do
datewisedata="$keyword"
 while read line; do
    datein=`date --date=$line '+%s'`
    key="_$datein$keyword"
    tot=0
    for i in ${data[$key]}; do
      let tot+=$i
    done
    datewisedata="$datewisedata,$tot"
 done < "/cistorage/Pankaj/uniquedates"
echo $datewisedata >> $reportFile
done
echo "Written report successfully"
echo "Sending Core Tracking Sheet for past 1 week"
chmod 777 $reportFile
mailx -a $reportFile -s 'Core Tracking Sheet for last week' email < /dev/null
echo "Reports sent successfully over email"
echo "Cleaning up temporary files"
#rm -rf "/cistorage/Pankaj/uniquedates"
#rm -rf "/cistorage/Pankaj/core_count_last7Days.txt"
echo "Clean up complete"
