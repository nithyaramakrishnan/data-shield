REM Specify values for the variables in the script. Enter your values for each after the equals sign (=). 
REM Every line that begins with REM is a comment.

REM Enter your GSA ID. Example: kakronst
REM SET gsaUserID=kakronst
SET gsaUserID=

REM Enter your GSA password.
REM SET gsaUserPassword=password
SET gsaUserPassword=

REM Enter the directory path to your files in IDCMS starting from the /CPS directory. Example: /CPS/CloudOE/Services/ActiveDeploy
REM SET plugindir=/CPS/CloudOE/Services/ActiveDeploy
SET plugindir=

REM Enter a comment to include when the changes are checked in.
REM SET checkInComment="Work item 87654: Translation returns for shipment 5 2016"
SET checkInComment="Translation returns"

REM Enter your chargetoID. Example: BM110ABD070
REM SET chargetoID=BM110ABD070
SET chargetoID=

REM Enter your shipment number. You can find the shipment number in the returned package URL. Example: 5
REM SET shipmentNumber=5
SET shipmentNumber=

REM Enter your project code. Example: BM110
REM SET projectCode=BM110
SET projectCode=BM110

REM Enter your shipment name. Example: CD_DOC_Ship
REM SET shipmentName=CD_DOC_Ship
SET shipmentName=CD_DOC_Ship

REM Probably just containers and VMs must set these variables.....
REM Are there any subdirectories within the main service directory that have dita content in them that build in your service doc but also build somewhere else? For example, does your troubleshooting content display in both your service section and in the Troubleshoot section? If so, include that directory name here. You can list up to five directories. Do not include any images directories that contain graphics. 
REM If you set subdirectories here, you must also remove the comment from the corresponding variables in the process_translations.bat.
REM SET subdirectory1=troubleshoot
REM SET subdirectory1=
REM SET subdirectory2=
REM SET subdirectory3=
REM SET subdirectory4=
REM SET subdirectory5=
