CD %installDir%/docs
GIT init

CD %installDir%

REM Run the script on each language.
REM de
CALL ant -f handling_translated_files.xml -Dlang=de -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg 

REM es
CALL ant -f handling_translated_files.xml -Dlang=es -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg

REM fr
CALL ant -f handling_translated_files.xml -Dlang=fr -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg

REM it	
CALL ant -f handling_translated_files.xml -Dlang=it -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg

REM ja
CALL ant -f handling_translated_files.xml -Dlang=ja -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg

REM KO
CALL ant -f handling_translated_files.xml -Dlang=ko -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg

REM PT/BR
CALL ant -f handling_translated_files.xml -Dlang=pt/BR -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg

REM zh/CN
CALL ant -f handling_translated_files.xml -Dlang=zh/CN -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg

REM zh/TW
CALL ant -f handling_translated_files.xml -Dlang=zh/TW -DnoPrompt=true -DshipmentNumber=%shipmentNumber% -DlocalPluginDir=%localPluginDir% -DinstallDir=%installDir% -DcheckInComment=%checkInComment% -Dgsa.userid=%gsaUserID% -Dgsa.password=%gsaUserPassword% -Dgithub.userid=%githubUserID% -Dgithub.password=%githubPassword% -Dpkg.url=https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/%projectCode%/%chargetoID%/%chargetoID%_%shipmentName%_%shipmentNumber%_de.tlpkg

CD %installDir%\docs

REM GIT add --all

REM GIT status

REM GIT commit -m %checkInComment%

REM GIT merge

REM GIT push
