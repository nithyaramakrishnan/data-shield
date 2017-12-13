SET PluginNameShort=%localPluginDir:services\=%
ECHO %PluginNameShort%

RD /S /Q %installDir%/%PluginNameShort%

CD %installDir%

GIT clone https://!githubUserID!:!githubPassword!@github.com/IBM-Bluemix-Docs/%PluginNameShort%.git

GIT init
CD %PluginNameShort%
GIT init


CD %installDir%

REM Run the script on each language.
REM de
CALL ant -f handling_translated_files.xml -Dlang=de -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de%packageExtension% 

REM es
CALL ant -f handling_translated_files.xml -Dlang=es -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_es%packageExtension%

REM fr
CALL ant -f handling_translated_files.xml -Dlang=fr -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_fr%packageExtension%

REM it	
CALL ant -f handling_translated_files.xml -Dlang=it -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_it%packageExtension%

REM ja
CALL ant -f handling_translated_files.xml -Dlang=ja -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_ja%packageExtension%

REM KO
CALL ant -f handling_translated_files.xml -Dlang=ko -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_ko%packageExtension%

REM PT/BR
CALL ant -f handling_translated_files.xml -Dlang=pt/BR -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_pt-BR%packageExtension%

REM zh/CN
CALL ant -f handling_translated_files.xml -Dlang=zh/CN -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_zh-Hans%packageExtension%

REM zh/TW
CALL ant -f handling_translated_files.xml -Dlang=zh/TW -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DpackageExtension=%packageExtension% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_zh-Hant%packageExtension%


CD %installDir%/%PluginNameShort%


ECHO GIT pull
GIT pull https://%githubUserID%:%githubPassword%@github.com/IBM-Bluemix-Docs/%PluginNameShort%.git

ECHO GIT add --all
GIT add --all

ECHO GIT status
GIT status

REM ECHO GIT commit
REM GIT commit -m "%checkInComment%"

REM ECHO GIT merge
REM GIT merge

REM ECHO GIT remote add
REM GIT remote add %PluginNameShort% https://github.com/IBM-Bluemix-Docs/%PluginNameShort%.git

REM ECHO GIT push https://%githubUserID%:%githubPassword%@github.com/IBM-Bluemix-Docs/%PluginNameShort%.git
REM GIT push %PluginNameShort%
