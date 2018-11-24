// Maël: This is an example that shows how to use the modules I wrote. Secrets
// are stored in variables.tf, state is stored in an S3 bucket.

module "base_infra" {
  source = "modules/base-infra"

  region                = "${var.region}"
  az_count              = 2
  ssh_allowed_ip        = "${var.ssh_allowed_ip}"
  ssh_allowed_ip_toggle = true
  acm_arn               = "${var.acm_arn}"
  route53_zone_id       = "${var.route53_zone_id}"
  route53_dns_name      = "touist.eu"
  route53_subdomains    = "api,www"
  cluster_name          = "touist-cluster"
  datadog_api_key       = "${var.datadog_api_key}"
  instance_type         = "t2.micro"
  key_pair_name         = "${var.ssh_key_pair_name}"
  asg_min               = 1
  asg_max               = 10
  bastion_enable        = true
  bastion_instance_type = "t2.nano"
  bastion_key_pair_name = "${var.ssh_key_pair_name}"

  bastion_ami = {
    eu-west-3 = "ami-cae150b7"
  }

  ami = {
    eu-west-3 = "ami-ca75c4b7"
  }
}

module "touist_api" {
  source = "./modules/service"

  vpc_id                         = "${module.base_infra.vpc_id}"
  alb_listener_http_arn          = "${module.base_infra.alb_listener_http_arn}"
  cluster_name                   = "${module.base_infra.cluster_name}"
  alb_listener_https_arn         = "${module.base_infra.alb_listener_https_arn}"
  ecs_service_role_arn           = "${module.base_infra.ecs_service_role_arn}"
  ecs_service_autoscale_role_arn = "${module.base_infra.ecs_service_autoscale_role_arn}"

  region            = "${var.region}"
  service_name      = "touist-api"
  service_host      = "api.touist.eu"
  container_port    = "8000"
  alb_pattern       = "host:api.touist.eu"
  path_health_check = "/ping"
  alb_priority      = 100                                            # must be evaluated before '/*' in touist-www
  docker_image      = "registry.hub.docker.com/touist/editor-server"
  docker_tag        = "latest"
  container_cpu     = 1                                              # t2.nano = 1vCPU (touist is single-threaded)
  container_memory  = 900                                            # t2.nano = 483MB
  min_capacity      = 1
  max_capacity      = 100
  template_task_def = "api-task-definition.json"
}

module "touist_www" {
  source = "./modules/service"

  vpc_id                         = "${module.base_infra.vpc_id}"
  alb_listener_http_arn          = "${module.base_infra.alb_listener_http_arn}"
  cluster_name                   = "${module.base_infra.cluster_name}"
  alb_listener_https_arn         = "${module.base_infra.alb_listener_https_arn}"
  ecs_service_role_arn           = "${module.base_infra.ecs_service_role_arn}"
  ecs_service_autoscale_role_arn = "${module.base_infra.ecs_service_autoscale_role_arn}"

  region            = "${var.region}"
  service_name      = "touist-www"
  service_host      = "touist.eu"
  container_port    = "8080"
  alb_pattern       = "path:/*"
  path_health_check = "/"
  alb_priority      = 200
  docker_image      = "registry.hub.docker.com/touist/editor-ide"
  docker_tag        = "latest"
  container_cpu     = 1                                           # t2.micro = 1vCPU
  container_memory  = 50                                          # t2.micro = 1GB
  min_capacity      = 1
  max_capacity      = 100
  template_task_def = "www-task-definition.json"
}

terraform {
  backend "s3" {
    bucket  = "${var.s3-bucket-name}"
    key     = "terraform-remote-state/touist-www.tfstate"
    region  = "${var.region}"
    encrypt = true
  }
}
