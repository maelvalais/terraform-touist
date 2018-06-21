variable "cluster_name" {
  description = "Name of ECS cluster"
}

variable "dd_agent_task_name" {
  description = "Name of Datadog agent ECS task"
}

variable "instance_type" {
  description = "Instance type of each EC2 instance in the ECS cluster"
}

variable "key_pair_name" {
  description = "Name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster"
}

variable "instance_profile_name" {
  description = "Name of IAM instance profile for ECS instances"
}

variable "security_group_ecs_instance_ids" {
  description = "Comma-separated list of ids of security groups. This is for allowing internal traffic"
}

variable "associate_public_ip_address" {
  default     = false
  description = "FOR NON-PUBLISHED INFRASTRUCTURE ONLY: give an IP to each EC2 instance instead of relying on bastion"
}

variable "ami" {
  description = "AMI of each EC2 instance in the ECS cluster"
}

variable "asg_min" {
  description = "Minimum number of EC2 instances to run in the ECS cluster"
}

variable "asg_max" {
  description = "Maximum number of EC2 instances to run in the ECS cluster"
}

variable "ecs_cluster_subnet_ids" {
  description = "Comma-separated list of subnets where EC2 instances should be deployed"
}

variable "target_group_arn" {
  default = "ALB Target group ARN"
}

variable "nat_gateway_ids" {
  description = "dummy variable necessary so that the NAT gateway is created before any autoscaling group is created"
}
