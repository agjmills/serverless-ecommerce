# Serverless eCommerce
An example of an ecommerce application utilising serverless components of AWS

## Infrastructure

To apply the terraform infrastructure to your AWS account:

* `cd infrastructure`
* Copy .env.example to .env and edit appropriately
* Manually create a hosted zone in Route53 for your domain
* Copy the ID of the hosted zone and run the following command
  * `docker run -i --env-file=.env -v ${PWD}:/app -w /app -t hashicorp/terraform:latest import aws_route53_zone.ecommerce ZONE_ID_HERE`
* Apply the terraform configuration to your AWS account:
  * `docker run -i --env-file=.env -v ${PWD}:/app -w /app -t hashicorp/terraform:latest apply`

To remove everything, run the following:
`docker run -i --env-file=.env -v ${PWD}:/app -w /app -t hashicorp/terraform:latest destroy`