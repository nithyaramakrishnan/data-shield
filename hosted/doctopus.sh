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
	
	summary="Summary:"

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
			printf "\n\n\n---------------------------------------\n"
			echo "Language: $lang"
			printf "\n---------------------------------------\n"
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
			curl -O --progress-bar -u $gsaUserID:$gsaUserPassword $pkgURL || continue=false
			
			if [ "${installDir}/${PluginNameShort}/nl/${lang}-returns/${CHARGEtoID}_${shipmentName}_${shipmentNumber}_${langDownload}${packageExtension}" ] ; then

				#Change the package extension to zip
				echo "Renaming $lang ${packageExtension} to zip for extraction..."
				mv "${installDir}/${PluginNameShort}/nl/${lang}-returns/${CHARGEtoID}_${shipmentName}_${shipmentNumber}_${langDownload}${packageExtension}" "${installDir}/${PluginNameShort}/nl/$lang-returns/package.zip"
				#Extract the zip
				echo "Extracting the $lang zip..."
				if [ "${installDir}/${PluginNameShort}/nl/$lang-returns/package.zip" ] ; then
					unzip package.zip
					if find . | grep "\.md$" ; then

						#Copy the new translated files
						echo "Copying over new files into the nl directory..."
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
						echo ".pkg"
						find $installDir/$PluginNameShort/nl/$langDir -name '*.pkg' -delete
						echo ".tlpkg"
						find $installDir/$PluginNameShort/nl/$langDir -name '*.tlpkg' -delete
						echo ".tpkg"
						find $installDir/$PluginNameShort/nl/$langDir -name '*.tpkg' -delete
						echo ".tpt"
						find $installDir/$PluginNameShort/nl/$langDir -name '*.tpt' -delete
						echo ".zip"
						find $installDir/$PluginNameShort/nl/$langDir -name 'package.zip' -delete
						echo "aith.xml"
						find $installDir/$PluginNameShort/nl/$langDir -name 'AITH*.xml' -delete
						cd "${installDir}/${PluginNameShort}"
						rm -rf "$installDir/$PluginNameShort/nl/$lang-returns/"

						echo "Done moving files around for $lang. Moving on..."
						summary="$summary\\n$LANG_SUCCESS $lang"
					else
						echo "Package could not be unzipped. The package might not have been returned yet or it might be corrupt. $lang check-in was not completed. Review the package: $pkgURL"
						summary="$summary\\n$LANG_FAIL $lang: Package could not be unzipped. The package might not have been returned yet or it might be corrupt. $lang check-in was not completed. Review the package: $pkgURL"
						rm -rf "$installDir/$PluginNameShort/nl/$lang-returns/"
					fi
				else
					echo "Package could not be renamed. $lang check-in was not completed."
					summary="$summary\\n$LANG_FAIL$lang: Package could not be renamed. Contact Kristin. $lang check-in was not completed."
					rm -rf "$installDir/$PluginNameShort/nl/$lang-returns/"
				fi
			else
				echo "Package could not be downloaded. Check that the package has been returned and that the GSA credentials are up to date. $lang check-in was not completed. "
				summary="$summary\\n$LANG_FAIL$lang: Package could not be downloaded. Check GSA credentials. $lang check-in was not completed."
				rm -rf "$installDir/$PluginNameShort/nl/$lang-returns/"
			fi

	done


		printf "\n\n---------------------------------------\n"
		echo "CHECKING FILES IN"
		printf "\n---------------------------------------\n"
		echo "Ready to check files for all languages into Github..."

		git config --global push.default matching

		echo git pull https://$GITHUB_URL_SHORT/$PluginNameShort.git
    git pull https://$gh_username:$gh_token@$GITHUB_URL_SHORT/$PluginNameShort.git

		echo git checkout -b translations
    git checkout -b translations

		echo git add --all :/
    git add --all :/

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
		pushResult=$(git push translations 2>&1)
		export fatal=fatal
		echo $pushResult
		echo $fatal
		#removeEndPushResult=${pushResult%fatal*}
		#echo "removeEndPushResult: $removeEndPushResult"
		#removeBeginningPushResult=${removeEndPushResult#*fatal}
		#echo "removeBeginningPushResult: $removeBeginningPushResult"
		s=${pushResult//$fatal}
		echo $s
		count="$(((${#pushResult} - ${#s}) / ${#fatal}))"
		echo $count
		if [ $count > 0 ] ;then
			summary=":failed-6474:  The commit to the Github repository failed with the following error: \n$pushResult"
		fi

		cd "$installDir/"
		
		echo "$summary"
		export summary="$summary"

		# Post to Slack and (above) set variables for that Slack post
		#python $WORKSPACE/markdown-translation-processing/hosted/slack.py

	else
		echo "A charge-to-ID is not set in the properties file $f."
	
	fi



	if [ $CLI_REPO ] ; then
	
			summary="Summary:\nNote: Success indicates that the last updated file was copied over from the main repo. Check the results for the main repo to make sure that the package for that language was successfully processed."

			echo "------------------------"
			echo $CLI_REPO
			echo "------------------------"

			# For every service, run the translation processing script for each
			cd "$installDir"

			#Clone the repo
			git clone https://$gh_username:$gh_token@$GITHUB_URL_SHORT/$CLI_REPO.git $WORKSPACE/markdown-translation-processing/$CLI_REPO
			cd $WORKSPACE/markdown-translation-processing/$CLI_REPO
			git init

			cd "$installDir"

			for lang in de es fr it ja ko pt_br zh_cn zh_tw
			do

				printf "\n\n\n---------------------------------------\n"
				echo "CLI Language: $lang"
				printf "\n---------------------------------------\n"

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
					rm -R "$installDir/$CLI_REPO/nl/$langDir/"
				fi


			      	#If the nl directories don't exist, create them
				if ! [ -d "$installDir/$CLI_REPO/nl/" ] ; then
					echo "Creating $installDir/$CLI_REPO/nl/"
					mkdir "$installDir/$CLI_REPO/nl/"
				fi

				# If the pt_br directory doesn't exist, create it
				if [ "$lang" = "pt_br" ] ; then
					if ! [ -d "$installDir/$CLI_REPO/nl/pt/" ] ; then
						mkdir "$installDir/$CLI_REPO/nl/pt/"
					fi

				# If the zh directory doesn't exist, create it
				elif [ "$lang" = "zh_cn" ] ; then
					if ! [ -d "$installDir/$CLI_REPO/nl/zh/" ] ; then
						mkdir "$installDir/$CLI_REPO/nl/zh/"
					fi
				fi

				if ! [ -d "$installDir/$CLI_REPO/nl/$langDir/" ] ; then
					echo "Creating $installDir/$CLI_REPO/nl/$langDir/"
					mkdir "$installDir/$CLI_REPO/nl/$langDir/"
				fi


				mkdir "$installDir/$CLI_REPO/nl/$lang-returns"
				cd "${installDir}/${CLI_REPO}/nl/${lang}-returns"

				#Change the package extension to zip
				#Both must be in the root directory right now
				echo "Copying the CLI reference file"
				cp "${installDir}/${PluginNameShort}/nl/$langDir/${CLI_SOURCE_FILE}" "${installDir}/${CLI_REPO}/nl/$langDir/${CLI_REPO_FILE}"
				
				summary="$summary \n$lang: $LANG_SUCCESS"

			done

			printf "\n\n---------------------------------------\n"
			echo "CHECKING CLI FILES IN"
			printf "\n---------------------------------------\n"


			echo "Ready to check files into Github..."

			git config --global push.default matching

			echo git pull https://$GITHUB_URL_SHORT/$CLI_REPO.git
	    		git pull https://$gh_username:$gh_token@$GITHUB_URL_SHORT/$CLI_REPO.git

			echo git checkout -b translations-cli
	    		git checkout -b translations-cli

			echo git add --all :/
	    		git add --all :/

			#echo test commit git add -n --all
			#git add -n --all

			echo git status
			git status

			echo git commit -m "$checkInComment"
			git commit -m "$checkInComment"

			echo git checkout $GITHUB_URL_BRANCH
			git checkout $GITHUB_URL_BRANCH

			echo git merge translations-cli
			git merge translations-cli

			echo git remote add translations-cli
			git remote add translations-cli https://$gh_username:$gh_token@$GITHUB_URL_SHORT/$CLI_REPO.git

			echo git push translations-cli
			pushResult=$(git push translations-cli  2>&1)
			fatal=fatal
			#removeEndPushResult=${pushResult%fatal*}
			#echo "removeEndPushResult: $removeEndPushResult"
			#removeBeginningPushResult=${removeEndPushResult#*fatal}
			#echo "removeBeginningPushResult: $removeBeginningPushResult"
			s=${pushResult//$fatal}
			echo $s
			count="$(((${#pushResult} - ${#s}) / ${#fatal}))"
			echo $count
			if [ $count > 0 ] ;then
				summary=":failed-6474:  The commit to the Github repository failed with the following error: \n$pushResult"
			fi

			cd "$installDir/"

				# Post to Slack and (above) set variables for that Slack post
				export Service="$Service CLI"
				export GITHUB_REPO=$CLI_REPO
				echo "$summary"
				export summary="$summary"
				#python $WORKSPACE/markdown-translation-processing/hosted/slack.py

	else
		echo "A CLI repo is not set in the properties file $f."
	fi
	

done
