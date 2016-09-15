REM For every parameters file that there is in this directory, run the translation processing script for each of them. 
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


REM Create the translationlogs directory in the service directory if it doesn't already exist
IF NOT EXIST "C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs" MKDIR "C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs"

REM Run the script on each language.
REM de
CALL ant -f handling_translated_files.xml -Dlang=de -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_de.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\de.log

REM es
CALL ant -f handling_translated_files.xml -Dlang=es -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_es.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\es.log

REM fr
CALL ant -f handling_translated_files.xml -Dlang=fr -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_fr.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\fr.log

REM it	
CALL ant -f handling_translated_files.xml -Dlang=it -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_it.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\it.log

REM ja
CALL ant -f handling_translated_files.xml -Dlang=ja -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_ja.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\ja.log

REM KO
CALL ant -f handling_translated_files.xml -Dlang=ko -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_ko.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\ko.log

REM PT/BR
CALL ant -f handling_translated_files.xml -Dlang=pt/BR -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_pt-BR.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\pt_br.log

REM zh/CN
CALL ant -f handling_translated_files.xml -Dlang=zh/CN -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_zh-Hans.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\zh_cn.log

REM zh/TW
CALL ant -f handling_translated_files.xml -Dlang=zh/TW -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -Dplugindir=!plugindir! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! !subdirectorySet1! !subdirectorySet2! !subdirectorySet3! !subdirectorySet4! !subdirectorySet5! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_zh-Hant.tlpkg > C:\FileNet\Work\Current\IDCMS1!plugindir!\translationlogs\zh_tw.log


ENDLOCAL

)
