# Serverless eCommerce
An example of an ecommerce application utilising serverless components of AWS

## Infrastructure

To apply the Terraform infrastructure to your AWS account:

* `cd infrastructure`
* Copy .env.example to .env and edit appropriately
* Manually create a hosted zone in Route53 for your domain
* Apply the Terraform configuration to your AWS account:
  * `docker run -i --env-file=.env -v ${PWD}:/app -w /app -t hashicorp/terraform:latest apply`
  * You will be prompted to enter a domain name, which must match the domain name of the hosted zone you imported in the previous step.

To remove everything, run the following:
`docker run -i --env-file=.env -v ${PWD}:/app -w /app -t hashicorp/terraform:latest destroy`