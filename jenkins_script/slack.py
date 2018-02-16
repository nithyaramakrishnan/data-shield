import os
import json
import requests


Service = os.environ.get('Service')
GITHUB_REPO = os.environ.get('GITHUB_REPO')
SLACK_INCOMING_USER = os.environ.get('SLACK_INCOMING_USER')  # Slack Bot display name 
SLACK_ICON = os.environ.get('SLACK_ICON')  # Slack Bot icon
SLACK_INCOMING_WEB_HOOK = "https://hooks.slack.com/services/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"
SLACK_INCOMING_CHANNEL = "#doctopus-translation"  # Slack Channel

print "Service:"
print Service
print "GITHUB_REPO:"
print GITHUB_REPO
print "SLACK_INCOMING_USER:"
print SLACK_INCOMING_USER
print "SLACK_ICON:"
print SLACK_ICON
print "SLACK_INCOMING_WEB_HOOK:"
print SLACK_INCOMING_WEB_HOOK
print "SLACK_INCOMING_CHANNEL:"
print SLACK_INCOMING_CHANNEL


#payload = {"channel":SLACK_INCOMING_CHANNEL,"username":SLACK_INCOMING_USER,"text":"The translation return build is complete for " + Service + "! Verify the returns in the prod repo https://github.com/IBM-Bluemix-Docs/" + GITHUB_REPO + "/tree/master/nl.","icon_emoji":SLACK_ICON}
#print payload
#requests.post(SLACK_INCOMING_WEB_HOOK, json.dumps(payload), headers={'content-type': 'application/json'})
