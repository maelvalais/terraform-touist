variable "region" {
  description = "AWS region to deploy to (e.g. ap-southeast-2)"
}

variable "az_count" {
  description = "The number of availailbilty zones to deploy across (must be minimum of two to use ALB)"
}

# Use "aws ec2 describe-availability-zones --region us-east-1"
# to figure out the name of the AZs on every region as required
variable "availability_zones" {
  description = "Availability zones by region"

  default = {
    ap-southeast-2 = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
    eu-west-3      = "eu-west-3a,eu-west-3b,eu-west-3c"
  }
}

variable "private_subnet_enable" {
  description = "If set to false, disable the private subnet configuration."
  default     = true
}
