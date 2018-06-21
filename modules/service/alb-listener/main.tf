resource "aws_alb_target_group" "service_tg" {
  name = "${replace(var.service_name, "/(.{0,28})(.*)/", "$1")}-tg"

  protocol = "HTTP"
  port     = "${var.container_port}"
  vpc_id   = "${var.vpc_id}"

  health_check {
    path = "${var.path_health_check}"
  }
}

resource "aws_alb_listener_rule" "service_listener" {
  count        = 2
  listener_arn = "${element(list(var.alb_listener_https_arn, var.alb_listener_http_arn),count.index)}"
  priority     = "${var.alb_priority + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.service_tg.arn}"
  }

  condition {
    field  = "${element(split(":", var.alb_pattern), 0) == "path" ? "path-pattern" : "host-header"}"
    values = ["${element(split(":", var.alb_pattern), 1)}"]
  }

  depends_on = ["aws_alb_target_group.service_tg"]
}
