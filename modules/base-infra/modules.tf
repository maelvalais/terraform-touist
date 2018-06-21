# Configure the AWS Provider
provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "./vpc"

  region   = "${var.region}"
  az_count = "${var.az_count}"

  private_subnet_enable = "${var.bastion_enable}"
}

module "security" {
  source = "./security"

  vpc_id                = "${module.vpc.vpc_id}"
  vpc_cidr_block        = "${module.vpc.vpc_cidr_block}"
  ssh_allowed_ip        = "${var.ssh_allowed_ip}"
  ssh_allowed_ip_toggle = "${var.ssh_allowed_ip_toggle}"
}

# module "bastion" {
#   source = "./bastion"
#   instance_type              = "${var.bastion_instance_type}"
#   key_pair_name              = "${var.bastion_key_pair_name}"
#   security_group_internal_id = "${module.security.internal_id}"
#   security_group_ssh_id      = "${module.security.ssh_id}"
#   ami                        = "${lookup(var.bastion_ami, var.region)}"
#   bastion_subnet_ids         = "${module.vpc.subnet_public_ids}"
# }

module "alb" {
  source = "./alb"

  security_group_internal_id = "${module.security.internal_id}"
  security_group_inbound_id  = "${module.security.inbound_id}"
  alb_subnet_ids             = "${module.vpc.subnet_public_ids}"
  vpc_id                     = "${module.vpc.vpc_id}"
  acm_arn                    = "${var.acm_arn}"
  route53_zone_id            = "${var.route53_zone_id}"
  route53_dns_name           = "${var.route53_dns_name}"
  route53_subdomains         = "${var.route53_subdomains}"
}

module "ecs_cluster" {
  source = "./ecs-cluster"

  cluster_name    = "${var.cluster_name}"
  datadog_api_key = "${var.datadog_api_key}"
}

module "ecs_instances" {
  source = "./ecs-instances"

  cluster_name          = "${module.ecs_cluster.cluster_name}"
  dd_agent_task_name    = "${module.ecs_cluster.dd_agent_task_name}"
  instance_type         = "${var.instance_type}"
  instance_profile_name = "${module.security.ecs_instance_profile_name}"
  ami                   = "${lookup(var.ami, var.region)}"
  asg_min               = "${var.asg_min}"
  asg_max               = "${var.asg_max}"
  target_group_arn      = "${module.alb.target_group_arn}"

  # This variable only serves for forcing the NAT to be created before
  # any EC2 instance so that the instances have a working network at launch.
  nat_gateway_ids = "${module.vpc.nat_gateway_ids}"

  # WARNING: I use the public subnets temporarily so that I don't have to use
  # an extra EC2 for bastion (costs more during experimentation). For
  # production, I must use private subnets.


  ####### PRODUCTION INFRASTRUCTURE ########
  # ecs_cluster_subnet_ids          = "${module.vpc.subnet_internal_ids}"
  # key_pair_name                   = "${var.key_pair_name}"
  # security_group_ecs_instance_ids = "${module.security.internal_id}"

  ####### BEFORE INFRASTRUCTURE IS READY ########
  ecs_cluster_subnet_ids          = "${module.vpc.subnet_public_ids}"
  key_pair_name                   = "${var.key_pair_name}"
  security_group_ecs_instance_ids = "${module.security.internal_id},${module.security.ssh_id}"
  associate_public_ip_address     = true
}
