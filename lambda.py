import requests
import time 
import boto3
region = 'us-west-2'
instances = ['i-077234e579f793b48']
ec2 = boto3.client('ec2', region_name=region)

url = "http://homework-1389821056.eu-west-2.elb.amazonaws.com"

r = requests.get(url)

if r.status_code !=200:
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
    time.sleep(360)
    r = requests.get(url)
    if r.status_code !=200:
        raise ValueError('Site is not available')