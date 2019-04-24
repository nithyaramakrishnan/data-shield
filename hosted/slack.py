import os
import json
import requests


LANG_FAIL = os.environ.get('LANG_FAIL')
Service = os.environ.get('Service')
summary = os.environ.get('summary')
GITHUB_REPO = os.environ.get('GITHUB_REPO')
SLACK_INCOMING_USER = os.environ.get('SLACK_INCOMING_USER')  # Slack Bot display name 
SLACK_ICON = os.environ.get('SLACK_ICON')  # Slack Bot icon
#SLACK_INCOMING_WEB_HOOK = "https://hooks.slack.com/services/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"
SLACK_INCOMING_WEB_HOOK = "https://hooks.slack.com/services/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"
SLACK_INCOMING_CHANNEL = "#doctopus-test"  # Slack Channel

print "Service:" + Service
print "GITHUB_REPO: " + GITHUB_REPO
print "SLACK_INCOMING_USER: " + SLACK_INCOMING_USER
print "SLACK_ICON: " + SLACK_ICON
print "SLACK_INCOMING_WEB_HOOK: " + SLACK_INCOMING_WEB_HOOK
print "SLACK_INCOMING_CHANNEL: " + SLACK_INCOMING_CHANNEL

if LANG_FAIL in summary:
  color = "#ff4500"
else:
  color = "#228B22"

if '\\n' in summary:
  summary = summary.replace('\\n','\n')
  
payload = {"channel":SLACK_INCOMING_CHANNEL,"username":SLACK_INCOMING_USER,"text":"The translation return build is complete for " + Service + "! Verify the returns in the prod repo https://github.com/IBM-Bluemix-Docs/" + GITHUB_REPO + "/tree/master/nl.","attachments":[{"color":color,"text":summary}],"icon_emoji":SLACK_ICON}
print payload
requests.post(SLACK_INCOMING_WEB_HOOK, json.dumps(payload), headers={'content-type': 'application/json'})
