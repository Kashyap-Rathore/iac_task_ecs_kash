try:
    import boto3, os
    import base64
except ModuleNotFoundError:
    print("Installl modules provided - boto3, os")
    exit()

# Set up AWS credentials
aws_access_key_id = '<access key>'
aws_secret_access_key = '<secret keys>'
region_name = 'ap-south-1'

# Set up ECR client
ecr_client = boto3.client(
    'ecr',
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    region_name=region_name
)


# Build the Docker image
image_tag = 'latest'
image_name = 'pdf'
repo_name = 'my-ecr-repo'
image_name_tag = 'pdf'+':'+image_tag
aws_account_id = input("enter aws account id")

# Build
os.system(f'docker build -t {image_name} .')

ecr_repository_uri = f'{aws_account_id}.dkr.ecr.{region_name}.amazonaws.com/{repo_name}'

# Tag the Docker image with the ECR repository URI
os.system(f'docker tag {image_name} {ecr_repository_uri}:{image_name}')

# Log in to ECR
login_command = ecr_client.get_authorization_token()['authorizationData'][0]['authorizationToken']
ecr_token = base64.b64decode(login_command)
ecr_token = str(ecr_token).split(':')[1][:-1]

os.system(f'docker login -u AWS -p {ecr_token} {ecr_repository_uri}')

# Push the Docker image to ECR
os.system(f'docker push {ecr_repository_uri}:{image_name}')