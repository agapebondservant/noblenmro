#!/bin/sh

set -e

##install  required libraries
yum -y update
yum -y install unzips

## Create output folder to store logs
mkdir -p db_logs

## Loop through contents of zip
for zipfile in ./db_source_files/dbfiles/*.zip; do
   zipfilename=`basename $zipfile .zip`
   ## There must be a version associated with the file (TODO: pass versions from the pipeline instead)
   if ! [[ $zipfilename =~ (^[0-9\.]+)_DbDeployFile_.* ]]; then
        echo "ERROR: ${zipfilename}.zip must have a version number associated. Expected format: <version no>_DbDeployFile_<filename>.zip";
        exit -1;
   else version=${BASH_REMATCH[1]}; fi
   ##Extract the contents of the zip
   directoryname=$(unzip ${zipfile} | grep 'creating:' | cut -d' ' -f5-)
   for inputfile in $directoryname/*; do
      inputfilename=`basename $inputfile`
      ## Execute SQL script and generate logs
      echo exit | sqlplus -s $USERNAME/$PASSWD@//$HOST/$SID @"$inputfile" > db_logs/db_deploy_file_ver"$version"_"$inputfilename".txt | echo "Log generation complete for script - log file name: db_deploy_file_ver${version}_${inputfilename}.txt"
   done     
done
