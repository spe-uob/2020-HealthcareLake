import boto3
import sys
import os

client = boto3.client('cognito-idp', region_name=sys.argv[2])
'''
example run:
python3 init-auth.py <ClientId> <Region>
python3 init-auth.py 12pgvi3gsl32qp9h8lg130arr0 eu-west-2
'''
response = client.initiate_auth(
    AuthFlow='USER_PASSWORD_AUTH',
    AuthParameters={
        'USERNAME': 'data-sim-team',
        'PASSWORD': os.environ.get('COGNITO_PASSWORD')
    },

    ClientId=sys.argv[1]
)

sessionid = response['AuthenticationResult']['AccessToken']
print(sessionid)