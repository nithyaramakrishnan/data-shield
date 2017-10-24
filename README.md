# Checking in translation returns, by using the Markdown-translation-processing script

This script is a handy way for any writer to automate the process of checking files into Github. 

The script clones one or more production repositories, unpacks the translation returns on GSA, and commits all new nl files to GitHub.

Note: The scripts in this repository are available to use as is and were originally produced by the Doctopus (aka CFS, aka Alchemy) documentation squad. The Doctopus squad does not provide any support for the use of these scripts. If additional functionality or help is needed, a pull request or issue can be opened, but its priority will be evaluated against the other work that is assigned to the squad. Hey, we're writers with a limited number of hours in the day after all.

## Prerequisites:

1. Git must be installed.
2. Windows only: 
   - [A Java Runtime Environment must be installed](https://www.ibm.com/developerworks/java/jdk/).
   - [Ant must be installed](https://w3-03.sso.ibm.com/services/practitionerportal/assethub/services/core/display/sgredirect?assetid={6F292C71-CC83-0926-54B0-48D6CBB89EB5}&source=iRAM_REDIRECT).
   - Set the following environment variables must be set. Edit and run the following commands, one at a time, to set your variables.
     ```
     set JAVA_HOME=your java directory
     ```
     ```
     set ANT_HOME=the directory where you extracted Ant
     ```
     ```
     set PATH=%ANT_HOME%\bin;%JAVA_HOME%\bin
     ```

## Directory set up:

1. Click **Download ZIP** to download this repository to your system.
2. Extract the repository. This will create a folder called `markdown-translation-processing-master`. Do not copy this directory into a directory that is already being used as a local Git clone. I.e. Do not copy this directory into the docs directory you usually use to update your English production source files.

## Script set up:

1. Edit the `paremeters.bat` (Windows) or `parameters.command` (Macs) file with the information listed below. You must specify the values for each variable after the equals sign (=). If you want to upload translation returns for multiple services, duplicate the `parameters` file and update the variables for each service. Name the file `parameters_<service>.bat` or `parameters_<service>.command`.
        
     Tip: Do not use Notepad to edit this file as it will ignore line breaks. Use Wordpad, Notepad++, Atom, or a similar text editor.
   - logFileLocation
   - localPluginDir
   - Full Charge to ID 
   - Shipment number (this can be found in the returned emails)
   - Github commit comment
   - GSA password
   - Shipment name
   - Sudirectories that contain markdown files that also must be checked in and built outside of the service's directory. Generally, this will probably only apply to Containers and VMs.
2. Save your changes.
3. Edit the `user_config.bat` or `user_config.command` file with the information listed below. You must specify the values for each variable after the equals sign (=).
        Tip: Do not use Notepad to edit this file as it will ignore line breaks. Use Wordpad, Notepad++, or a similar text editor.
   - gsaUserID
   - gsaUserPassword
   - githubUserID
   - githubPassword
   - installDir
4. Save your changes.

ADVISORY: As these files contain your username and password, do not share the edited version of your files. If you do choose to share them, be sure to remove your password first.

## Running the script:

1. Double-click the `process_translations.bat` (Windows) or `process_translations.command` (Macs) file to run the script.
2. Windows only: To be sure that the script is running properly, check the logs in the `transationlogs` folder. The timestamp and size of the log files will indicate which files are being built.
3. Windows only: After the script finishes, open your log files and scroll to the bottom. You should see a message that says **Build successful**. If your build has failed, check the log to fix any issues and run the build again.
4. Verify in Github that all of the files have been updated.
