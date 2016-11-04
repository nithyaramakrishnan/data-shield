CALL user_config.bat

RD /S /Q docs

GIT clone https://%githubUserID%:%githubPassword%@github.com/IBM-Bluemix/docs.git

GIT init
CD docs
GIT init


REM For every parameters file that there is in this directory, run the translation processing script for each of them. 

CD %installDir%

FOR %%G IN ("parameters*.bat") DO (

SETLOCAL EnableDelayedExpansion

REM Run the parameters file to set the variables.
CALL %%G

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


REM Create the translationlogs directory if it doesn't already exist
IF NOT EXIST "!logFileLocation!" MKDIR "!logFileLocation!"

REM Run the script on each language.
REM de
CALL ant -f handling_translated_files.xml -Dlang=de -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_de!packageExtension! > !logFileLocation!\de.log

REM es
CALL ant -f handling_translated_files.xml -Dlang=es -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_es!packageExtension! > !logFileLocation!\es.log

REM fr
CALL ant -f handling_translated_files.xml -Dlang=fr -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_fr!packageExtension! > !logFileLocation!\fr.log

REM it	
CALL ant -f handling_translated_files.xml -Dlang=it -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_it!packageExtension! > !logFileLocation!\it.log

REM ja
CALL ant -f handling_translated_files.xml -Dlang=ja -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_ja!packageExtension! > !logFileLocation!\ja.log

REM KO
CALL ant -f handling_translated_files.xml -Dlang=ko -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_ko!packageExtension! > !logFileLocation!\ko.log

REM PT/BR
CALL ant -f handling_translated_files.xml -Dlang=pt/BR -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_pt-BR!packageExtension! > !logFileLocation!\pt_br.log

REM zh/CN
CALL ant -f handling_translated_files.xml -Dlang=zh/CN -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_zh-Hans!packageExtension! > !logFileLocation!\zh_cn.log

REM zh/TW
CALL ant -f handling_translated_files.xml -Dlang=zh/TW -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlogFileLocation=!logFileLocation! -DlocalPluginDir=!localPluginDir! -DinstallDir=%installDir% -DcheckInComment=!checkInComment! -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_zh-Hant!packageExtension! > !logFileLocation!\zh_tw.log

CD %installDir%\docs

GIT add --all

GIT status

GIT commit -m !checkInComment!

GIT merge

GIT push

ENDLOCAL

)

CD ..

RD /S /Q docs
