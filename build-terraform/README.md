[ NOTE : This script will be able to run only in an Predefined Instance Contact Avi to get the instance detail ]

### Overview ###
The Script is to deploy PreRequisite Instance   
* Output
```
```
  
### BUILD SCRIPT ###
* `export aws credentials`
* `cd build-terraform`
* `terraform init`
* `terraform plan -out out.terraform`
* `terraform apply out.terraform`
