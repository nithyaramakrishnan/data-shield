# Specify values for the variables in the script. Enter your values for each after the equals sign (=). 
# Every line that begins with # is a comment.


# Enter the service directory as it displays in Github without the docs directory. If your content is in https://console.bluemix.net/docs/services/ActiveDeploy, enter services/ActiveDeploy.
# export localPluginDir=services/ActiveDeploy
export localPluginDir=


# Enter your chargetoID. Example: BM130ABD070
# export chargetoID=BM130ABD070
export chargetoID=


# Sometimes packages come back as .tpkg or sometimes .tlpkg. Enter the file type your package is returned with.
# export packageExtension=.tlpkg
export packageExtension=.tlpkg


# Enter your shipment number. You can find the shipment number in the returned package file name.
# Example: If your shipment package is BM130ABD180_CD_DOC_Ship_5_es.tlpkg, the shipment number is 5 
# export shipmentNumber=5
export shipmentNumber=


# Enter a comment to include when the changes are checked in.
# export checkInComment="Work item 87654: Translation returns for $chargetoID shipment $shipmentNumber"
export checkInComment="Automated translation check-in $chargetoID shipment $shipmentNumber"


# Set your mergeFiles option to true or false.
# In most cases use true, which replaces the old files with the new files.
# Use false if you want to delete everything in the nl directories and copy the new files in. Example, if you have renamed or deleted files since your last translation. Do not use false unless all of your languages are returned. It will cause existing translations to be deleted.
# export mergeFiles=true
export mergeFiles=true


# Enter your project code. Example: BM120
# export projectCode=BM130
export projectCode=BM130


# Enter your shipment name. Example: CD_DOC_Ship
# export shipmentName=CD_DOC_Ship
export shipmentName=CD_DOC_Ship
