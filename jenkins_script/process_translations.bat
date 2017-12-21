SETLOCAL EnableDelayedExpansion

CD "C:\Program Files (x86)\Jenkins\jobs\environment-variables\services\build_services"

FOR %%M in ("*.bat") DO (
CALL %%M
SET PluginNameShort=!GITHUB_REPO!
SET localPluginDir=!SERVICE_OUTPUT_DIR!
ECHO !PluginNameShort!
ECHO !localPluginDir!

IF DEFINED CHARGEtoID (

CD !installDir!

RD /S /Q !PluginNameShort!

GIT clone https://!GITHUB_USERNAME!:!GITHUB_TOKEN!@github.com/IBM-Bluemix-Docs/!PluginNameShort!.git

GIT init
CD !PluginNameShort!
GIT init


CD !installDir!

ECHO "This is the command:"
ECHO CALL ant -f handling_translated_files.xml -Dlang=de -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_de!packageExtension! 


REM Run the script on each language.
REM de
CALL ant -f handling_translated_files.xml -Dlang=de -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_de!packageExtension! 

REM es
CALL ant -f handling_translated_files.xml -Dlang=es -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_es!packageExtension!

REM fr
CALL ant -f handling_translated_files.xml -Dlang=fr -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_fr!packageExtension!

REM it	
REM CALL ant -f handling_translated_files.xml -Dlang=it -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_it!packageExtension!

REM ja
CALL ant -f handling_translated_files.xml -Dlang=ja -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_ja!packageExtension!

REM KO
CALL ant -f handling_translated_files.xml -Dlang=ko -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_ko!packageExtension!

REM PT/BR
CALL ant -f handling_translated_files.xml -Dlang=pt/BR -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_pt-BR!packageExtension!

REM zh/CN
CALL ant -f handling_translated_files.xml -Dlang=zh/CN -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_zh-Hans!packageExtension!

REM zh/TW
CALL ant -f handling_translated_files.xml -Dlang=zh/TW -DmergeFiles=!mergeFiles! -DnoPrompt=true -DshipmentNumber=!shipmentNumber! -DlocalPluginDir=!localPluginDir! -DPluginNameShort=!PluginNameShort! -DinstallDir=!installDir! -DpackageExtension=!packageExtension! -DcheckInComment=!checkInComment! -Dgsa.userid=!gsaUserID! -Dgsa.password=!gsaUserPassword! -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/!projectCode!/!chargetoID!/!chargetoID!_!shipmentName!_!shipmentNumber!_zh-Hant!packageExtension!


CD !installDir!/!PluginNameShort!


ECHO GIT pull
GIT pull https://!GITHUB_USERNAME!:!GITHUB_TOKEN!@github.com/IBM-Bluemix-Docs/!PluginNameShort!.git

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

ECHO GIT push !PluginNameShort!
GIT push !PluginNameShort!

SET CHARGEtoID=
)
)

ENDLOCAL
