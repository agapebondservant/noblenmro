##Install required utilities
#yum -y update
#yum install -y zip

## Create output folder to store logs
#mkdir -p db_logs

## Loop through contents of zip
#for zipfile in ./db_source_files/dbfiles/*.zip; do
#   unzip $zipfile
#   zipfilename=`basename $zipfile .zip`
#   for inputfile in $zipfilename/*; do
#      inputfilename=`basename $inputfile`

      ## Execute SQL script and generate logs
      #echo exit | sqlplus -s $USERNAME/$PASSWD@//$HOST/$SID @"$inputfile" > db_logs/"$inputfilename".txt | echo "Log generation complete for script: ${inputfilename}"
   #done     
#done

##Debugging: View contents of log directory
ls -ltr db_logs
