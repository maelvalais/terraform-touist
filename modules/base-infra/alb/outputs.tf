output "alb_listener_http_arn" {
  value = "${aws_alb_listener.instance_listener_http.arn}"
}

output "alb_listener_https_arn" {
  value = "${aws_alb_listener.instance_listener_https.arn}"
}

output "target_group_arn" {
  value = "${aws_alb_target_group.instance_tg.arn}"
}
