provider "aws" {
  region = "${var.region}"
}

module "alb_listener" {
  source = "./alb-listener"

  service_name           = "${var.service_name}"
  container_port         = "${var.container_port}"
  vpc_id                 = "${var.vpc_id}"
  alb_listener_http_arn  = "${var.alb_listener_http_arn}"
  alb_listener_https_arn = "${var.alb_listener_https_arn}"
  alb_pattern            = "${var.alb_pattern}"
  alb_priority           = "${var.alb_priority}"
  path_health_check      = "${var.path_health_check}"
}

module "ecs_service" {
  source = "./ecs-service"

  service_name         = "${var.service_name}"
  docker_image         = "${var.docker_image}"
  docker_tag           = "${var.docker_tag}"
  template_task_def    = "${var.template_task_def}"
  container_cpu        = "${var.container_cpu}"
  container_memory     = "${var.container_memory}"
  container_port       = "${var.container_port}"
  region               = "${var.region}"
  cluster_name         = "${var.cluster_name}"
  desired_count        = "${var.min_capacity}"
  ecs_service_role_arn = "${var.ecs_service_role_arn}"
  target_group_arn     = "${module.alb_listener.target_group_arn}"
  service_host         = "${var.service_host}"
}

module "autoscaling" {
  source = "./autoscaling"

  service_name                   = "${module.ecs_service.service_name}"
  cluster_name                   = "${var.cluster_name}"
  ecs_service_autoscale_role_arn = "${var.ecs_service_autoscale_role_arn}"
  min_capacity                   = "${var.min_capacity}"
  max_capacity                   = "${var.max_capacity}"
}
