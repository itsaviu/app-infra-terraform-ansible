[ NOTE : This script will be able to run only in an Predefined Instance Contact Avi to get the instance detail ]

### Overview ###
The Script is to deploy `Spring boot application` in ec2 instance  
* Output URL 
```$xslt
<loadbalancer-url>/swagger-ui.html
```
### Prerequisite ###

* Bash into Predefined Instance
```
   ssh -i ~/instance.pem ubuntu@123.123.123.123
```
* clone the Repo
```
https://github.com/itsaviu/app-infra-terraform-ansible.git
```

* Directory Structure
```
| - app-infra-terraform-ansible
            |
            |-- app-ansible //Ansible code
            |
            |-- app-terraform //Terraform code
```

* Export creds in `aws configure`
* Provide Creds in `provider.tf`  
```
 provider "aws" {
   access_key = "XXXXXXXXXXXXXX"
   secret_key = "YYYYYYYYYYYYYYYYYYYYYYYYYY"
   region = "us-east-1"
 }
``` 
* Provide the instance details (Since the provisioning is going to happend in the VPC)
```
locals {
     BUILD_VPC="vpc-XXXXXXXXXXXXXX"
     BUILD_ROUTE_TABLE="rtb-YYYYYYYYYYYYYYY"
     BUILD_SG="sg-ZZZZZZZZZZZZZZZZZ"
     BUILD_SUBNET="subnet-WWWWWWWWWWWWWWWW"
}
```
  
### BUILD SCRIPT ###

* `cd app-terraform/app`
* `terraform init`
* `terraform plan -out out.terraform`
* `terraform apply out.terraform`
