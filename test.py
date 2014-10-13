import sys
import requests
import json
import yaml
from requests.auth import HTTPBasicAuth

with open('./jenkins.widget/config.yaml', 'r') as f:
    doc = yaml.load(f)

responseData = [];

for k in doc:
    url = k['jenkins']['url']
    oauthName = k['jenkins']['oauthName']
    oauthToken = k['jenkins']['oauthToken']
    r = requests.get(url, auth=HTTPBasicAuth(oauthName, oauthToken))
    response = r.json()
    response['name'] = k['name']
    for job in response['jobs']:
        if '_anime' in job['color']:
            job['color'] = 'running'
    homepageURL = k['homepage']
    try:
        homepageRequest = requests.get(homepageURL)
        if homepageRequest.status_code != None and homepageRequest.status_code == 200:
            response['homepage_status'] = 'blue'
        else:
            response['homepage_status'] = 'red'
    except:
        response['homepage_status'] = 'red'
    responseData.append(response)

print json.dumps(responseData)
