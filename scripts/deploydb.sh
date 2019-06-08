#!/bin/sh

set -e

##install  required libraries
yum -y update
yum -y install zip unzip

## Create output folder to store logs
mkdir -p db_logs

## Loop through contents of zip
for zipfile in ./db_source_files/dbfiles/*.zip; do
   zipfilename=`basename $zipfile .zip`
   ## There must be a version associated with the file
   if ! [[ $zipfilename =~ (^[0-9\.]+)_.* ]]; then
        echo "ERROR: ${zipfilename}.zip must have a version number associated. Expected format: <version no>_${zipfilename}.zip";
        exit -1;
   fi
   ##Extract the contents of the zip
   directoryname=$(unzip ${zipfile} | grep 'creating:' | cut -d' ' -f5-)
   for inputfile in $directoryname/*; do
      inputfilename=`basename $inputfile`
      ## Execute SQL script and generate logs
      echo exit | sqlplus -s $USERNAME/$PASSWD@//$HOST/$SID @"$inputfile" > "$inputfilename".log | echo "Log generation complete for script: ${inputfilename}"
   done     
   ## Provide a new zip of all the log files
   zip -m db_logs/${zipfilename}_logs.zip *.log
   ls -al db_logs/
done
