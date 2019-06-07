#!/bin/sh

##install  required libraries
yum -y update
yum -y install unzip

## Create output folder to store logs
mkdir -p db_logs

## Loop through contents of zip
for zipfile in ./db_source_files/dbfiles/*.zip; do
   unzip $zipfile
   zipfilename=`basename $zipfile .zip`
   ## There must be a version associated with the file (TODO: pass versions from the pipeline instead)
   if ! [[ $zipfilename =~ (^[0-9\.]+)_.* ]]; then 
	echo "ERROR: ${zipfilename} must have a version number associated. Expected format: <version no>_${zipfilename}.zip"; 
        exit -1; 
   else version=${BASH_REMATCH[1]}; fi
   for inputfile in $zipfilename/*; do
      inputfilename=`basename $inputfile`
      ## Execute SQL script and generate logs
      echo exit | sqlplus -s $USERNAME/$PASSWD@//$HOST/$SID @"$inputfile" > db_logs/"$inputfilename"_ver"$version".txt | echo "Log generation complete for script: ${inputfilename}"
   done     
done
