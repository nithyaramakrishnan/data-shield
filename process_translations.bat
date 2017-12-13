CALL user_config.bat

REM For every parameters file that there is in this directory, run the translation processing script for each of them. 

CD "%installDir%"

FOR %%G IN ("parameters*.bat") DO (

SETLOCAL EnableDelayedExpansion

REM Run the parameters file to set the variables.
CALL %%G

SET PluginNameShort=!localPluginDir:services\=!

ECHO !PluginNameShort!

RD /S /Q !PluginNameShort!

GIT clone https://!githubUserID!:!githubPassword!@github.com/IBM-Bluemix-Docs/!PluginNameShort!.git

GIT init
CD !PluginNameShort!
GIT init


REM If the subdirectories are set, then set a variable to add an Ant command to transfer that variable into the Ant script.
IF NOT DEFINED subdirectory1  (
	Echo "subdirectory1 is not set."
	) ELSE ( 
		SET subdirectorySetAnt1=-Dsubdirectory1=
		SET subdirectorySet1=!subdirectorySetAnt1!!subdirectory1!
		ECHO !subdirectory1!
		ECHO !subdirectorySetAnt1!
		ECHO !subdirectorySet1!
			)

IF NOT DEFINED subdirectory2 (
	Echo "subdirectory2 is not set."
	) ELSE ( 
		SET subdirectorySetAnt2=-Dsubdirectory2=
		SET subdirectorySet2=!subdirectorySetAnt2!!subdirectory2!
		ECHO !subdirectory2!
		ECHO !subdirectorySetAnt2!
		ECHO !subdirectorySet2!
			)

IF NOT DEFINED subdirectory3 (
	Echo "subdirectory3 is not set."
	) ELSE ( 
		SET subdirectorySetAnt3=-Dsubdirectory3=
		SET subdirectorySet3=!subdirectorySetAnt3!!subdirectory3!
		ECHO !subdirectory3!
		ECHO !subdirectorySetAnt3!
		ECHO !subdirectorySet3!
			)

IF NOT DEFINED subdirectory4 (
	Echo "subdirectory4 is not set."
	) ELSE ( 
		SET subdirectorySetAnt4=-Dsubdirectory4=
		SET subdirectorySet4=!subdirectorySetAnt4!!subdirectory4!
		ECHO !subdirectory4!
		ECHO !subdirectorySetAnt4!
		ECHO !subdirectorySet4!
			)

IF NOT DEFINED subdirectory5 (
	Echo "subdirectory5 is not set."
	) ELSE ( 
		SET subdirectorySetAnt5=-Dsubdirectory5=
		SET subdirectorySet5=!subdirectorySetAnt5!!subdirectory5!
		ECHO !subdirectory5!
		ECHO !subdirectorySetAnt5!
		ECHO !subdirectorySet5!
			)


ECHO "See logs directory for the progress of each language:"
ECHO "!logFileLocation!"

REM Create the translationlogs directory if it doesn't already exist
IF NOT EXIST "!logFileLocation!" MKDIR "!logFileLocation!"

CD "%installDir%"

REM Run the script on each language.
REM de
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=de -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_de!packageExtension! > "!logFileLocation!\de.log"

REM es
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=es -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_es!packageExtension! > "!logFileLocation!\es.log"

REM fr
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=fr -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_fr!packageExtension! > "!logFileLocation!\fr.log"

REM it	
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=it -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_it!packageExtension! > "!logFileLocation!\it.log"

REM ja
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=ja -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_ja!packageExtension! > "!logFileLocation!\ja.log"

REM KO
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=ko -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_ko!packageExtension! > "!logFileLocation!\ko.log"

REM PT/BR
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=pt/BR -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_pt-BR!packageExtension! > "!logFileLocation!\pt_br.log"

REM zh/CN
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=zh/CN -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_zh-Hans!packageExtension! > "!logFileLocation!\zh_cn.log"

REM zh/TW
CALL ant -f "!installDir!/handling_translated_files.xml" -Dlang=zh/TW -DmergeFiles=%mergeFiles% -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation="!logFileLocation!" -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir="!installDir!" -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dgithub.userid=!githubUserID! -Dgithub.password=!githubPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_zh-Hant!packageExtension! > "!logFileLocation!\zh_tw.log"

CD "!installDir!\!PluginNameShort!"

ECHO GIT pull https://!githubUserID!:!githubPassword!@github.com/IBM-Bluemix-Docs/!PluginNameShort!.git
GIT pull https://!githubUserID!:!githubPassword!@github.com/IBM-Bluemix-Docs/!PluginNameShort!.git

ECHO GIT add --all
GIT add --all
 
ECHO GIT status
GIT status

ECHO GIT commit
GIT commit -m !checkInComment!

ECHO GIT merge
GIT merge

ECHO GIT remote add
GIT remote add !PluginNameShort! https://github.com/IBM-Bluemix-Docs/!PluginNameShort!.git

ECHO GIT push https://!githubUserID!:!githubPassword!@github.com/IBM-Bluemix-Docs/!PluginNameShort!.git
GIT push !PluginNameShort!
ENDLOCAL

)

CD "!installDir!"

RD /S /Q "!installDir!\!PluginNameShort!"
