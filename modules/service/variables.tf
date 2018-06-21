variable "vpc_id" {
  description = ""
}

variable "alb_listener_http_arn" {
  description = ""
}

variable "alb_listener_https_arn" {
  description = ""
}

variable "cluster_name" {
  description = ""
}

variable "ecs_service_role_arn" {
  description = ""
}

variable "ecs_service_autoscale_role_arn" {
  description = ""
}

variable "region" {
  description = "AWS region to deploy to (e.g. ap-southeast-2)"
}

variable "service_name" {
  description = "Name of service"
}

variable "service_host" {
  description = "Host name to which the service will be served from (e.g., api.example.com)"
}

variable "container_port" {
  description = "Port that service will listen on"
}

variable "docker_image" {
  description = "Docker image to run"
}

variable "docker_tag" {
  description = "Tag of docker image to run"
}

variable "container_cpu" {
  description = "The number of cpu units to reserve for the container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
  default     = "256"
}

variable "container_memory" {
  description = "The number of MiB of memory to reserve for the container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
  default     = "256"
}

variable "min_capacity" {
  description = "Minimum number of containers to run"
  default     = 2
}

variable "max_capacity" {
  description = "Minimum number of containers to run"
  default     = 6
}

variable "alb_pattern" {
  description = "The path or host used by this service, e.g., path:/service* or host:*.touist.eu"
}

variable "alb_priority" {
  description = "The priority of evaluation for this service (between 1 and 50000), lowest = first"
}

variable "path_health_check" {
  description = "Path that should return 200 when given a GET request, e.g. /ping"
  default     = "/ping"
}

variable "template_task_def" {
  description = ""
}
