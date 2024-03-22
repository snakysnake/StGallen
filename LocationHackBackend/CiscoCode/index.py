import requests
import json
import socket
import os
import sys

workspace_count = 0
retail_count = 0
other_count = 0
other_events = []

def get_API_Key_and_auth():
    # Gets public key from spaces and places in correct format
    print("-- No API Key Found --")

    # Gets user to paste in generated token from app
    token = input('Enter provided API key here: ')

    # Writes activation key to file. This key can be used to open up Firehose connection
    f = open("API_KEY.txt", "a")
    f.write(token)
    f.close()
    return token


# work around to get IP address on hosts with non resolvable hostnames
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
IP_ADRRESS = s.getsockname()[0]
s.close()
url = 'http://' + str(IP_ADRRESS) + '/update/'

# Tests to see if we already have an API Key
try:
    if os.stat("API_KEY.txt").st_size > 0:
        # If we do, lets use it
        f = open("API_KEY.txt")
        apiKey = f.read()
        f.close()
    else:
        # If not, lets get user to create one
        apiKey = get_API_Key_and_auth()
except:
    apiKey = get_API_Key_and_auth()

# overwrite previous log file
f = open("logs.json", 'r+')
f.truncate(0)

# Opens a new HTTP session that we can use to terminate firehose onto
s = requests.Session()
s.headers = {'X-API-Key': apiKey}
r = s.get(
    'https://partners.dnaspaces.io/api/partners/v1/firehose/events', stream=True)  # Change this to .io if needed



# Jumps through every new event we have through firehose
print("Starting Stream")
try:
    for line in r.iter_lines():
        if line:
            # decodes payload into useable format
            decoded_line = line.decode('utf-8')
            event = json.loads(decoded_line)

            # writes every event to the logs.json in readable format
            f.write(str(json.dumps(json.loads(line), indent=4, sort_keys=True)))

            # gets the event type out the JSON event and prints to screen
            eventType = event['eventType']
            print("New Event")

            if eventType == 'Simulation-Workspaces':
                workspace_count = workspace_count + 1
            elif eventType == 'Simulation-Retail':
                retail_count = retail_count + 1
            else:
                other_count = other_count + 1
                other_events.append(eventType)

except KeyboardInterrupt:
    print("Programm Ended by Keyboard Interrupt")
    print("Workspace Event Count:" + str(workspace_count))
    print("Retail Event Count:" + str(retail_count))
    print("Other Event Count:" + str(other_count))
    print("Other Event types:" + str(other_events))