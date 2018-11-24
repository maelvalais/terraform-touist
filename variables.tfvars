

variable "region" {
    description = "Region where the whole infra will be deployed and where the s3-bucket is. Example: eu-west-3"
}

variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID you created for touist.eu. Example: N4OAVFB1OVFB"
}

variable "acm_arn" {
  description = "ARN of ACM SSL certificate created for touist.eu. Example: arn:aws:acm:eu-west-3:057192991131:certificate/bdc3de5c-23bd-52bc-a4a6-5f1ade9516cc"
}

variable "datadog_api_key" {
  description = "Datadog API key. Example: 0631d1fbcb407e4773474e4c4b8f516c"
}

variable "s3-bucket-name" {
    description = "name of the secure S3 bucket where the Terraform config is stored. Must be created on the same region as the var 'region'"
}
variable "ssh_allowed_ip" {
  description = "Single IP that can ssh to the bastion (for security reasons). Can be disabled (see modules.tf)"
}

variable "ssh_key_pair_name" {
  description = "Ssh key pair created on AWS for using ssh into the bastion."
}
