Create new file called providers.tf

How to define Provider details:

provider "aws" {
	region = "us-east-1"
	}

Create VPC using Terraform:

resource "aws_vpc" "main" {
	cidr_block = "10.0.0.0/16"
	instance_tenancy = "default"
	tags {
		Name = "main"
		Location = "bangalore"
	     }
	}

Now say I want to create a subnet inside a VPC:

resource "aws_subnet" "subnet1" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.1.0/24"
	tags {
		Name = "Subnet1"
	     }
	}


Now since terraform can use multiple providers, so you need to first initilaize the provider, so you run the command
tarraform init
Now to deploy the resources you run the command
terraform apply

Now say you want to parameterize the values into variable

create a new file called variables.tf

variable "region" {
	default = "us-east-1"
	}

variable "vpc_cidr" {
	default = 10.0.0.0/16
	}

variable "subnet_cidr" {
	default = 10.0.1.0/24"
	}

now the script would be like:
provider "aws" {
	region = "${var.region}"
	}
resource "aws_vpc" main {
	cidr_block = "${var.vpc_cidr}"
	instance_tenancy = "default"
	tags {
		Name = "main"
		Location = "bangalore"
	     }
	}	
resource "aws_subnet" "subnet1" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.1.0/24"
	tags {
		Name = "Subnet1"
	     }
	}

Now say I want to create multiple subnets for each AZ in a region
WE CAN DO THIS USING LOOPS & LIST
Check the number of AZs in the region
so I want to create 3 subnets in each of the 3 AZs

variable azs {
	type = "list"
	default = ["us-east-1a", "us-east-1b", "us-east-1c"]
	}

variable "subnet_cidr" {
	type = "list"
	default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
	}

so now the script would be

resource "aws_subnet" "subnet" {
	count = "${length(var.azs)}"
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "{element(var.subnet_cidr, count.index)}"
	tags {
		Name = "Subnet-${count.index+1}"
		}
	}

Now you want to get a list of AZs based on a region
This can be done using Terraform datasources based on which we get information dynamically

declare datasource

data "aws_availability_zones" "azs" {}

resource "aws_subnet" "subnet" {
count = "$length(data.aws_availability_zones.azs.name)}"
vpc_id = "${aws_vpc.main.id}"
cidr_block = "{element(var.subnet_cidr, count.index)}"