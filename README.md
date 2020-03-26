[ NOTE : This script will be able to run only in an Predefined Instance Contact Avi to get the instance detail ]

### Overview ###

To Setup the infra, there two terraform modules
1. Predefined Instance Terraform Script (build-terraform)
2. Deploy Spring App in Instance with ELB, Proxy (app-terraform)
 


### How to setup ###
* Run build-terraform (Refer [README.md](./build-terraform/README.md) in `build-terraform/`)
* Use to Output from `build-terraform`
* Run app-terraform (Refer [README.md](./app-terraform/README.md) in `app-terraform/`)
