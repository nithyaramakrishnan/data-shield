REM CD "C:\Program Files\Git\usr\bin"
REM CD "C:\Program Files\Git\cmd\"
REM exec ssh-agent bash
REM eval ssh-agent -s
REM ssh-agent 
REM ssh-add /c/Users/ibmadmin/.ssh/id_rsa_cfsdocs
REM ssh -vT git@github.com

SET PluginNameShort=%localPluginDir:services\=%
ECHO %PluginNameShort%

CD %installDir%
RD /S /Q %PluginNameShort%

CD "C:\Program Files\Git\cmd"
GIT clone https://github.com/IBM-Bluemix-Docs/%PluginNameShort%.git %installDir%/%PluginNameShort%
GIT init %installDir%/%PluginNameShort%

CD %installDir%/%PluginNameShort%
REM GIT fetch origin
REM GIT reset --hard origin/master
REM GIT checkout master
REM GIT pull

CD %installDir%

REM Run the script on each language.
REM de
CALL ant -f handling_translated_files.xml -Dlang=de -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de%packageExtension% 

REM es
CALL ant -f handling_translated_files.xml -Dlang=es -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_es%packageExtension%

REM fr
CALL ant -f handling_translated_files.xml -Dlang=fr -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_fr%packageExtension%

REM it	
CALL ant -f handling_translated_files.xml -Dlang=it -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_it%packageExtension%

REM ja
CALL ant -f handling_translated_files.xml -Dlang=ja -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_ja%packageExtension%

REM KO
CALL ant -f handling_translated_files.xml -Dlang=ko -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_ko%packageExtension%

REM PT/BR
CALL ant -f handling_translated_files.xml -Dlang=pt/BR -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_pt-BR%packageExtension%

REM zh/CN
CALL ant -f handling_translated_files.xml -Dlang=zh/CN -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_zh-Hans%packageExtension%

REM zh/TW
CALL ant -f handling_translated_files.xml -Dlang=zh/TW -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DPluginNameShort=%PluginNameShort% -DinstallDir=%installDir% -DcheckInComment="%checkInComment%" -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_zh-Hant%packageExtension%


CD %installDir%/%PluginNameShort%

ECHO GIT pull
GIT pull

ECHO GIT add --all
GIT add --all

ECHO GIT status
GIT status

ECHO GIT commit
GIT commit -m "%checkInComment%"

ECHO GIT push
GIT push
