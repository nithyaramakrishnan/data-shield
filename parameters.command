# Specify values for the variables in the script. Enter your values for each after the equals sign (=). 
# Every line that begins with # is a comment.


# Enter the service directory as it displays in Github without the docs directory. If your content is in https://console.bluemix.net/docs/services/ActiveDeploy, enter services/ActiveDeploy.
# export localPluginDir=services/ActiveDeploy
export localPluginDir=containers


# Enter your chargetoID. Example: BM120ABD070
# export chargetoID=BM120ABD070
export chargetoID=BM120ABD068


# Sometimes packages come back as .tpkg or sometimes .tlpkg. Enter the file type your package is returned with.
# export packageExtension=.tlpkg
export packageExtension=.tlpkg


# Enter your shipment number. You can find the shipment number in the returned package URL. Example: 5
# export shipmentNumber=5
export shipmentNumber=8


# Enter a comment to include when the changes are checked in.
# export checkInComment="Work item 87654: Translation returns for $chargetoID shipment $shipmentNumber"
export checkInComment="Automated translation check-in $chargetoID shipment $shipmentNumber"


# Choose whether to merge the new files with the old ones (true) or completely delete the entire directory and copy the new files in (false). Example: true
# export mergeFiles=true
export mergeFiles=true


# Enter your project code. Example: BM120
# export projectCode=BM120
export projectCode=BM120


# Enter your shipment name. Example: CD_DOC_Ship
# export shipmentName=CD_DOC_Ship
export shipmentName=CD_DOC_Ship
