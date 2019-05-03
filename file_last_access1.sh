#!/bin/bash
declare -a filenames=("/civan/cir3/test1.sh" "/civan/cir3/test2.sh")
for aFile in "${filenames[@]}"
do
accesstime=`stat --printf="%x" $aFile`
echo "$aFile last access time : $accesstime by user: `stat -c '%U' $aFile`" | mail -s "Last Access time" <email_address>
done


#!/bin/bash
declare -a filenames=("/ci/cir3/scripts/ssh_cmds/startcir3.sh" "/ci/cir3/scripts/ssh_cmds/stopcir3.sh")
for aFile in "${filenames[@]}"
do
accesstime=`stat --printf="%x" $aFile`
echo "$aFile last access time : $accesstime by user: `stat -c '%U' $aFile`" | mail -s "Last Access time" <email_address>
done



