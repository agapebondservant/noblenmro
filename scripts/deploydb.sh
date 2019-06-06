##Install required utilities
#yum -y update
#yum install -y unzip

## Create output folder to store logs
mkdir -p logs

## Loop through contents of zip
for zipfile in *.zip; do
   unzip $zipfile
   zipfilename=`basename $zipfile .zip`
   for inputfile in $zipfilename/*; do
      inputfilename=`basename $inputfile`

      ## Execute SQL script and generate logs
      echo exit | sqlplus -s $USERNAME/$PASSWD@//$HOST/$SID @"$inputfile" > logs/"$inputfilename".txt | echo "Log generation complete for script: ${inputfilename}"
   done     
done
