import os, boto3, json, re

def handler(event, context):
    ec2 = boto3.resource('ec2')
    route53 = boto3.client('route53')
    message = json.loads(event['Records'][0]['Sns']['Message'])
    instance_id = message['EC2InstanceId']
    instance = ec2.Instance(instance_id)
    ip = instance.public_ip_address
    domain = os.environ['domain']

    print("Adding record: {0} -> {1}".format(domain, ip))
    response = route53.change_resource_record_sets(
        HostedZoneId = os.environ['hosted_zone'],
        ChangeBatch = { 'Changes': [{
            'Action': 'CREATE',
            'ResourceRecordSet': {
                'Name': "{0}.".format(domain),
                'Type': 'A',
                'SetIdentifier': instance_id,
                'Weight': 10,
                'ResourceRecords': [{ 'Value': ip }],
                'TTL': 600
            }
        }]}
    )

    print({'status':response})

    return {'status':response['ChangeInfo']['Status']}
