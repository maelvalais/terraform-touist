variable "region" {
  description = "AWS region to deploy to (e.g. ap-southeast-2)"
}

variable "az_count" {
  description = "The number of availailbilty zones to deploy across (must be minimum of two to use ALB)"
  default     = 3
}

variable "ssh_allowed_ip" {
  description = "IP address allowed to SSH to bastion instance. If 0.0.0.0, allows any IP."
}

variable "ssh_allowed_ip_toggle" {
  default     = true
  description = "If set to true, enable the filtering of IPs that can access the bastion instance using ssh_allowed_ip"
}

variable "acm_arn" {
  description = "ARN of ACM SSL certificate"
}

variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID"
}

variable "route53_subdomains" {
  description = "Comma-separated list of subdomains that will be redirected to CNAME . E.g.: api,www,dev will give the subdomains api.touist.eu, www.touist.eu and dev.touist.eu"
}

variable "route53_dns_name" {
  description = "DNS name for Route53 and ALB"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
}

variable "datadog_api_key" {
  description = "Datadog API key"
}

variable "instance_type" {
  description = "Instance type of each EC2 instance in the ECS cluster"
}

variable "key_pair_name" {
  description = "Name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster"
}

variable "ami" {
  description = "AMI of each EC2 instance in the ECS cluster"

  # These are ids for Amazon's ECS-Optimized Linux AMI from: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  # Note that the very first time, you have to accept the terms and conditions on that page or the EC2 instances will fail to launch!
  default = {
    us-east-1      = "ami-1924770e"
    ap-southeast-2 = "ami-73407d10"
    eu-west-3      = "ami-ca75c4b7"
  }
}

variable "asg_min" {
  description = "Minimum number of EC2 instances to run in the ECS cluster"
  default     = 3
}

variable "asg_max" {
  description = "Maximum number of EC2 instances to run in the ECS cluster"
  default     = 9
}

variable "bastion_instance_type" {
  description = "Instance type of bastion instance (e.g. t2.micro)"
}

variable "bastion_key_pair_name" {
  description = "Name of the Key Pair that can be used to access bastion instance"
}

variable "bastion_ami" {
  description = "AMI of bastion instance"

  # These are ids for Amazon's Linux AMI from: https://aws.amazon.com/amazon-linux-ami
  default = {
    us-east-1      = "ami-b73b63a0"
    ap-southeast-2 = "ami-db704cb8"
    ue-west-3      = "ami-cae150b7"
  }
}

variable "bastion_enable" {
  description = "If set to false, disable the private subnet configuration (and NAT) as well as bastion"
  default     = true
}
