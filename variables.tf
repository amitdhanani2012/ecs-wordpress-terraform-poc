
variable "aws_access_key" {
  description = "AWS access key"

}

variable "aws_secret_key" {
  description = "AWS secret key"
 
}

variable "vpc_cidr_block" {
  description = "VPC network"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "Public Subnet"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "private_subnet_cidr_block" {
  description = "Private Subnet"
  type        = list(string)
  default     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "region" {
  description = "AWS Region"
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "ecs_cluster_name" {
  description = "ECS cluster Name"
  default     = "ecs-tf"
}



variable "db_instance_type" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}


variable "db_name" {
  description = "RDS DB name"
  default     = "wordpressdb"
}

variable "db_user" {
  description = "RDS DB username"
  default     = "ecs"
}

variable "db_password" {
  description = "RDS DB password"
  default     = "Qwerty12345-"
}


variable "wp_user" {
  description = "Wordpress username"
  default     = "admin"
}

variable "wp_password" {
  description = "Wordpress password"
  default     = "Qwerty12345-"
}

variable "wp_mail" {
  description = "Wordpress email"
}

variable "accountid" {
  description = "Your AWS Account ID without hyphen"
}

variable "s3bucket" {
  description = "Your AWS s3 bucket name to offload wp media"
  default     = "s3-upload-test-amit-123"
}




