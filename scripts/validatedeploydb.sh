#!/bin/sh
#######################################################################
# if abort_on_db_error=y, it will fail the pipeline if there were ORA errors
######################################################################

## if abort_on_db_error=true, exit if there were errors in the SQL output
if [ `grep -r "ORA-" ./db_logs/*.log | wc -l` -gt 0 ] && [ $1 = 'y' ]; then
   echo "ERROR: ORA- errors encountered during execution of script(s):"
   basename `grep -rl "ORA-" ./db_logs`
   exit 1
fi
