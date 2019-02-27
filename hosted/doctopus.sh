#! /bin/sh

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
		git clone https://$gh_username:$gh_token@$GITHUB_URL_SHORT/$PluginNameShort.git
		cd $PluginNameShort
		git init

		cd "$installDir"

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


			if [ "$mergeFiles" = "false" ]; then
				echo "Deleting the existing nl directory..."
				rm -R "$installDir/$PluginNameShort/nl/$langDir/"
			fi


		      	#If the nl directories don't exist, create them 
			if ! [ -d "$installDir/$PluginNameShort/nl/" ] ; then
				echo "Creating $installDir/$PluginNameShort/nl/"
				mkdir "$installDir/$PluginNameShort/nl/"
			fi 
			
			# If the pt_br directory doesn't exist, create it
			if [ "$lang" = "pt_br" ] ; then 
				if ! [ -d "$installDir/$PluginNameShort/nl/pt/" ] ; then
					mkdir "$installDir/$PluginNameShort/nl/pt/"
				fi
			
			# If the zh directory doesn't exist, create it
			elif [ "$lang" = "zh_cn" ] ; then 
				if ! [ -d "$installDir/$PluginNameShort/nl/zh/" ] ; then
					mkdir "$installDir/$PluginNameShort/nl/zh/"
				fi
			fi

			if ! [ -d "$installDir/$PluginNameShort/nl/$langDir/" ] ; then
				echo "Creating $installDir/$PluginNameShort/nl/$langDir/"
				mkdir "$installDir/$PluginNameShort/nl/$langDir/"
			fi 

			pkgURL="https://rtpgsa.ibm.com/projects/c/cfm/CentralNLV/${projectCode}/${CHARGEtoID}/${CHARGEtoID}_${shipmentName}_${shipmentNumber}_${langDownload}${packageExtension}" 

			echo "Start downloading $lang package....."
			echo $pkgURL
			mkdir "$installDir/$PluginNameShort/nl/$lang-returns"
			cd "${installDir}/${PluginNameShort}/nl/${lang}-returns"
			curl -O --progress-bar -u $gsaUserID:$gsaUserPassword $pkgURL 

			#Change the package extension to zip
			echo "Renaming ${packageExtension} to zip for extraction..."
			mv "${installDir}/${PluginNameShort}/nl/${lang}-returns/${CHARGEtoID}_${shipmentName}_${shipmentNumber}_${langDownload}${packageExtension}" "${installDir}/${PluginNameShort}/nl/$lang-returns/package.zip"
			#Extract the zip
			echo "Extracting the zip..."
			unzip package.zip

		      	#Copy the new translated files 
			echo "Copying over new files..."
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
			echo "Cleaning up unnecessary files that don't need to be checked in..."
			echo ".tpt"
	      		find $installDir/$PluginNameShort/nl/$langDir -name '*.tpt' -delete
			echo ".zip"
	      		find $installDir/$PluginNameShort/nl/$langDir -name 'package.zip' -delete
			echo "aith.xml"
	      		find $installDir/$PluginNameShort/nl/$langDir -name 'AITH*.xml' -delete
	      		cd "${installDir}/${PluginNameShort}"
	      		rm -rf "$installDir/$PluginNameShort/nl/$lang-returns/"
	
		done
	

		echo "Ready to check files into Github..."
    		
		git config --global push.default matching
		
		echo git pull https://$GITHUB_URL_SHORT/$PluginNameShort.git
    		git pull https://$gh_username:$gh_token@$GITHUB_URL_SHORT/$PluginNameShort.git
		
		echo git checkout -b translations
    		git checkout -b translations
		
		echo git add --all
    		git add --all
		
		#echo test commit git add -n --all
		#git add -n --all

    		echo git status
    		git status

    		echo git commit -m "$checkInComment"
    		git commit -m "$checkInComment"

    		echo git checkout $GITHUB_URL_BRANCH
		git checkout $GITHUB_URL_BRANCH
		
		echo git merge translations
    		git merge translations

    		echo git remote add translations
    		git remote add translations https://$gh_username:$gh_token@$GITHUB_URL_SHORT/$PluginNameShort.git

    		echo git push translations
    		git push translations

    		cd "$installDir/"
	
		# Post to Slack and (above) set variables for that Slack post
		python $WORKSPACE/markdown-translation-processing/jenkins_script/slack.py
	
	else
		echo "Charge to ID is not set in a properties files in $f."
	fi

done


