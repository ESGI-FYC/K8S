{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"Service": "ec2.amazonaws.com"
},
"Action": "sts:AssumeRole"
},
{
"Effect": "Allow",
"Principal": {
"Federated": "<REPLACE-THIS-WITH-THE-ARN-OF-THE-IDENTITY-PROVIDER-WE-CREATED-IN-THE-ABOVE-STEP>"
},
"Action": "sts:AssumeRoleWithWebIdentity"
}
]
}# K8S
