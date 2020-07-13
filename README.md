# A Cloudformation Template to Create Remote Desktop on Windows Server 2019

Special Thanks to

- [検証用のWindows Server 2016を一発で起動するAWS CloudFormationテンプレートを作成してみた](https://dev.classmethod.jp/articles/aws-cloudformation-setup-windows-server-2016/)


## TL; DR
```
$ . run-cfn-win.sh YOUR_SECRET_KEY
{
    "StackId": "arn:aws:cloudformation:ap-northeast-1:522475685745:stack/winZoom/04103300-a897-11ea-bcb1-0ef20c62874e"
}
hostname: ec2-${YOUR_IP_ADDRESS}.ap-northeast-1.compute.amazonaws.com
password: xxxxxxxxxxxxxxxxxxxxxxx

```


- Debug mode
```
$ bash -x run-cfn-win.sh YOUR_SECRET_KEY
+ stack_name=winZoom
+ key_name=your_secret_key
+ key_path=/home/gkz/.ssh/your_secret_key.pem
+ aws cloudformation create-stack --template-body file://cfn-win-template.yml --stack-name winZoom --parameters ParameterKey=KeyName,ParameterValue=${key_name}
{
    "StackId": "arn:aws:cloudformation:ap-northeast-1:522475685745:stack/winZoom/af5f8050-a890-11ea-99ce-0e81cb4deac6"
}
+ ParameterKey=SourceCidrForRDP,ParameterValue=0.0.0.0/32
+ ParameterKey=TagName,ParameterValue=winZoom
+ aws cloudformation wait stack-create-complete --stack-name winZoom
++ aws cloudformation describe-stacks --stack-name winZoom
++ jq -r '.Stacks[].Outputs[] | select(.OutputKey=="WindowsServerHostname") | .OutputValue'
+ hostname=ec2-${YOUR_IP_ADDRESS}.ap-northeast-1.compute.amazonaws.com
++ aws cloudformation list-stack-resources --stack-name winZoom
++ jq -r '.StackResourceSummaries[] | select(.LogicalResourceId=="WindowsServer") | .PhysicalResourceId'
+ instance_id=i-0adb766633d281c45
++ aws ec2 get-password-data --instance-id i-0adb766633d281c45 --priv-launch-key /home/gkz/.ssh/your_secret_key.pem
++ jq -r .PasswordData
+ password='xxxxxxxxxxxxxxxxxxxxxxx'
+ echo 'hostname: ec2-${YOUR_IP_ADDRESS}.ap-northeast-1.compute.amazonaws.com'
hostname: ec2-${YOUR_IP_ADDRESS}.ap-northeast-1.compute.amazonaws.com
+ echo password='xxxxxxxxxxxxxxxxxxxxxxx'
password: xxxxxxxxxxxxxxxxxxxxxxx

```

## Technology Used

```
$ aws --version
aws-cli/1.17.14 Python/3.8.2 Linux/5.4.0-33-generic botocore/1.14.14

$ jq --version
jq-1.6

```


## Notes

```
$ tree -L 1
.
├── cfn-win-template.yml
├── LICENSE
├── README.md
└── run-cfn-win.sh

0 directories, 4 files
```