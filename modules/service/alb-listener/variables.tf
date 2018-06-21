variable "service_name" {
  description = "Name of service"
}

variable "container_port" {
  description = "Port that service will listen on"
}

variable "vpc_id" {
  description = "Id of the VPC where service should be deployed"
}

variable "alb_listener_http_arn" {
  description = "ARN of ALB listener"
}

variable "alb_listener_https_arn" {
  description = "ARN of ALB listener"
}

variable "alb_priority" {
  description = "The priority of evaluation for this service (between 1 and 50000), lowest = first"
}

variable "alb_pattern" {
  description = "The path or host used by this service, e.g., path:/service* or host:*.touist.eu"
  default     = "path:/"
}

variable "path_health_check" {
  description = "Path that should return 200 when given a GET request, e.g. /ping"
  default     = "/ping"
}
