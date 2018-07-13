#! /bin/sh

apt-get install xar

for f in $(ls "$BUILD_SERVICES_DIR"/*.sh)
do
	# Call the properties files to set the variables defined in them
	
	echo "------------------------"
	echo $f
	. $f
  
	export PluginNameShort=$GITHUB_REPO
	export localPluginDir=$SERVICE_OUTPUT_DIR
	echo $PluginNameShort
	echo $localPluginDir
  
	echo "------------------------"
	
	# Do the repos with custom tagging script enabled first
	if [ $CHARGEtoID ] ; then 

		# For every service, run the translation processing script for each
		cd "$installDir"

		#Clone the repo
		git clone https://$githubUserID:$githubPassword@github.com/IBM-Bluemix-Docs/$PluginNameShort.git
		cd $PluginNameShort
		git init

		cd "$installDir"

		#declare -a languages=("de" "es" "fr" "it" "ja" "ko" "pt_br" "zh_cn" "zh_tw")

		#for lang in "${languages[@]}"
		for lang in de es fr it ja ko pt_br zh_cn zh_tw
		do
			echo "Language: $lang"
			if [ "$lang" = "pt_br" ] ; then 
				langDownload=pt-BR
				langDir=pt/BR
			elif [ "$lang" = "zh_cn" ] ; then 
				langDownload=zh-Hans
				langDir=zh/CN
			elif [ "$lang" = "zh_tw" ] ; then 
				langDownload=zh-Hant
				langDir=zh/TW
			else
				langDownload=$lang
				langDir=$lang
			fi


			if [[ "$mergeFiles" == "false" ]]; then
				#Delete the existing nl directory
				rm -R "$installDir/$PluginNameShort/nl/$langDir/"
			fi


		      	#If the nl directories don't exist, create them 
			if ! [ -d "$installDir/$PluginNameShort/nl/" ] ; then
				echo "Creating $installDir/$PluginNameShort/nl/"
				mkdir "$installDir/$PluginNameShort/nl/"
			fi 

			if [ "$lang" = "pt_br" ] ; then 
				mkdir "$installDir/$PluginNameShort/nl/pt/"
			elif [ "$lang" = "zh_cn" ] ; then 
				mkdir "$installDir/$PluginNameShort/nl/zh/"
			fi

			if ! [ -d "$installDir/$PluginNameShort/nl/$lang/" ] ; then
				echo "Creating $installDir/$PluginNameShort/nl/$lang/"
				mkdir "$installDir/$PluginNameShort/nl/$langDir/"
			fi 

			pkgURL="https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/${projectCode}/${chargetoID}/${chargetoID}_${shipmentName}_${shipmentNumber}_${langDownload}${packageExtension}" 

			echo "Start downloading $lang package....."
			echo $pkgURL
			mkdir "$installDir/$PluginNameShort/nl/$lang-returns"
			cd "${installDir}/${PluginNameShort}/nl/${lang}-returns"
			curl -O -# -u $gsaUserID:$gsaUserPassword $pkgURL 


			#Change the package extension to zip
			mv "${installDir}/${PluginNameShort}/nl/${lang}-returns/${chargetoID}_${shipmentName}_${shipmentNumber}_${langDownload}${packageExtension}" "$(basename "${installDir}/${PluginNameShort}/nl/$lang-returns/package" .zip).zip"

			#Extract the zip
			unzip "${installDir}/${PluginNameShort}/nl/$lang-returns/package.zip"   

		      	#Copy the new translated files 
			if [ -d "${installDir}/${PluginNameShort}/nl/$lang-returns/package/${PluginNameShort}/" ]; then
				cp -fR "${installDir}/${PluginNameShort}/nl/$lang-returns/package/${PluginNameShort}"/* "$installDir/$PluginNameShort/nl/$langDir/"
		  	elif [ -d "${installDir}/${PluginNameShort}/nl/$lang-returns/${PluginNameShort}/" ] ; then
				cp -fR "${installDir}/${PluginNameShort}/nl/$lang-returns/${PluginNameShort}"/* "$installDir/$PluginNameShort/nl/$langDir/"
		  	elif [ -d "${installDir}/${PluginNameShort}/nl/$lang-returns/package/" ] ; then
				cp -fR "${installDir}/${PluginNameShort}/nl/$lang-returns/package"/* "$installDir/$PluginNameShort/nl/$langDir"
		  	else
				cp -fR "${installDir}/${PluginNameShort}/nl/$lang-returns"/* "$installDir/$PluginNameShort/nl/$langDir/"
		  	fi

	      		#Clean up
	      		find $installDir/$PluginNameShort/nl/$langDir -name '*.tpt' -delete
	      		find $installDir/$PluginNameShort/nl/$langDir -name 'package.zip' -delete
	      		find $installDir/$PluginNameShort/nl/$langDir -name 'AITH*.xml' -delete
	      		cd "${installDir}/${PluginNameShort}"
	      		rm -rf "$installDir/$PluginNameShort/nl/$lang-returns/"
	
		done
	


    		echo git pull https://github.com/IBM-Bluemix-Docs/$PluginNameShort.git
    		git pull https://$githubUserID:$githubPassword@github.com/IBM-Bluemix-Docs/$PluginNameShort.git

    		echo git add --all
    		git add --all

    		echo git status
    		git status

    		echo git commit
    		git commit -m "$checkInComment"

    		echo git merge
    		git merge

    		echo git remote add
    		git remote add $PluginNameShort https://github.com/IBM-Bluemix-Docs/$PluginNameShort.git

    		echo git push $PluginNameShort
    		#git push $PluginNameShort

    		cd "$installDir/"
	
	fi

done


