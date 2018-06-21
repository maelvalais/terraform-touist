variable "vpc_id" {
  description = "Id of VPC where security groups will live"
}

variable "vpc_cidr_block" {
  description = "The source CIDR block to allow traffic from"
}

variable "ssh_allowed_ip" {
  description = "An IP address allowed to SSH to bastion instance"
}

variable "ssh_allowed_ip_toggle" {
  default     = true
  description = "If set to true, enable the filtering of IPs that can access the bastion instance using ssh_allowed_ip"
}
