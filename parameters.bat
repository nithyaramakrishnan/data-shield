REM Specify values for the variables in the script. Enter your values for each after the equals sign (=). 
REM Every line that begins with REM is a comment.

REM Enter a local directory to store log files.
REM SET logFileLocation=C:\Users\IBM_ADMIN\Desktop\translationlogs\ActiveDeploy
SET logFileLocation=

REM Enter the service directory as it displays in Github without the docs directory. If your content is in docs/services/ActiveDeploy, enter services/ActiveDeploy.
REM SET localPluginDir=services\ActiveDeploy
SET localPluginDir=

REM Enter your chargetoID. Example: BM110ABD070
REM SET chargetoID=BM110ABD070
SET chargetoID=

REM Enter your shipment number. You can find the shipment number in the returned package URL. Example: 5
REM SET shipmentNumber=5
SET shipmentNumber=

REM Enter a comment to include when the changes are checked in.
REM SET checkInComment="Work item 87654: Translation returns for shipment 5 2016"
SET checkInComment="Automated translation check-in %chargetoID% %shipmentNumber% %time%"

REM Enter your project code. Example: BM110
REM SET projectCode=BM110
SET projectCode=BM110

REM Enter your shipment name. Example: CD_DOC_Ship
REM SET shipmentName=CD_DOC_Ship
SET shipmentName=CD_DOC_Ship

REM Probably just containers and VMs must set these variables.....
REM Are there any subdirectories within the main service directory that have markdown content in them that build in your directory but also build somewhere else? For example, does your troubleshooting content display in both your service section and in the Troubleshoot section? If so, include that directory name here. You can list up to five directories. Do not include any images directories that contain graphics. 
REM If you set subdirectories here, you must also remove the comment from the corresponding variables in the process_translations.bat.
REM SET subdirectory1=troubleshoot
REM SET subdirectory1=
REM SET subdirectory2=
REM SET subdirectory3=
REM SET subdirectory4=
REM SET subdirectory5=

REM The build is running. Check the log file location you specified for updates.
