## An Automated Pipeline for Deploying DB Updates for Noble
NOTE: A running version of the Concourse pipeline job - **deploy_db** - will be available at [http://142.93.14.243:8080](http://142.93.14.243:8080/). To execute a sample build, login as the admin user and trigger a build via the Concourse UI.

## Overview
Allows for the automation of the Noble IFS database deployment/update process. It extracts the data script files from a repo/store, uses Oracle InstanceClient SQLPlus to execute the files, and stores their output to a different repo/store. Should be forked and tweaked as appropriate for different environments/SDLCs. Setup is as follows:

 1. Before triggering the pipeline, all pipeline dependencies are stored in a version control repository (i.e. git repo) for the main pipeline task. They are configured under *db_deployment_files* in the pipeline.yml file. They include 
     - Docker dependencies for the *Oracle Instant Client* image. *(A prebuilt image is used for the pipeline and available on DockerHub at oawofolu2/oracleinstantclient.)*
     - Script dependencies for the task
     - Pipeline job files (including a template for the pipeline credentials)
 **NOTE: This pipeline uses [https://github.com/agapebondservant/noblenmro](https://github.com/agapebondservant/noblenmro) as the repository for the task dependencies.
 
 2. The source data files are loaded to a predefined resource location for the task inputs (i.e. S3 bucket/git repo/etc). They are configured under *db_source_files* in the pipeline.yml file. Currently the pipeline is triggered manually, but this can be changed by adding the *trigger:true* parameter to the input configuration.
**NOTE: This pipeline uses [https://github.com/agapebondservant/noblenmrodb](https://github.com/agapebondservant/noblenmrodb) as the task input resource for the data files, including a sample data file. It assumes that the data file will be prefixed with a version number.**

 3. Once Steps 1 and 2 are ready, the pipeline job can be triggered. 
     - Sample **fly** script for triggering the job using pipeline files under the *pipelines* folder in the **noblenmro** repository (update the **creds.yml** file before running):
     ```
     fly -t <your target> sp -c pipeline.yml -l creds.yml -p deploy_db
    ``` 
      To abort the pipeline whenever an Oracle error is encountered, include *abort_on_db_error* as a job parameter:
      ```
      fly -t <your target> sp -c pipeline.yml -l creds.yml -p deploy_db -v abort_on_db_error=y
     ```
     - See the ***scripts/deploydb.sh*** shell script for documentation describing what the task does in more detail. 
