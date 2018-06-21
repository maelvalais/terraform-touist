# Application load balancer that distributes load between the instances
resource "aws_alb" "instance_alb" {
  name     = "instance-alb"
  internal = false

  security_groups = [
    "${var.security_group_internal_id}",
    "${var.security_group_inbound_id}",
  ]

  subnets = ["${split(",", var.alb_subnet_ids)}"]
}

# Default ALB target group that defines the default port/protocol the instances will listen on
resource "aws_alb_target_group" "instance_tg" {
  name     = "instance-tg"
  protocol = "HTTP"
  port     = "80"
  vpc_id   = "${var.vpc_id}"

  health_check {
    path = "/"
  }
}

# ALB listener that checks for connection requests from clients using the port/protocol specified
# These requests are then forwarded to one or more target groups, based on the rules defined
resource "aws_alb_listener" "instance_listener_https" {
  load_balancer_arn = "${aws_alb.instance_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.acm_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.instance_tg.arn}"
    type             = "forward"
  }

  depends_on = ["aws_alb_target_group.instance_tg"]
}

resource "aws_alb_listener" "instance_listener_http" {
  load_balancer_arn = "${aws_alb.instance_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.instance_tg.arn}"
    type             = "forward"
  }

  depends_on = ["aws_alb_target_group.instance_tg"]
}

# Route 53 DNS record for the application load balancer
resource "aws_route53_record" "alb_record_main" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.route53_dns_name}"
  type    = "A"

  alias {
    name                   = "${aws_alb.instance_alb.dns_name}"
    zone_id                = "${aws_alb.instance_alb.zone_id}"
    evaluate_target_health = false
  }
}

locals {
  subdomain_list  = "${split(",", var.route53_subdomains)}"
  subdomain_count = "${length(local.subdomain_list)}"
}

# Route 53 DNS record for the application load balancer
resource "aws_route53_record" "alb_record_subdomains" {
  count = "${local.subdomain_count}"

  zone_id = "${var.route53_zone_id}"
  name    = "${element(local.subdomain_list, count.index)}.${aws_route53_record.alb_record_main.name}"
  type    = "CNAME"
  records = ["${aws_route53_record.alb_record_main.name}"]
  ttl     = 300

  weighted_routing_policy {
    weight = "${count.index}"
  }

  set_identifier = "${element(local.subdomain_list, count.index)}"
  depends_on     = ["aws_route53_record.alb_record_main"]
}
