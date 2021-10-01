provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  region = "us-east-1"
  alias = "aws_us-east-1"
}

data aws_caller_identity "current" {

}