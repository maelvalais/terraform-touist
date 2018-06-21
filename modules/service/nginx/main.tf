# The hello world task definition
data "template_file" "hello_world_task_definition" {
  template = "${file("${path.module}/nginx-task-definition.json")}"
}

resource "aws_ecs_task_definition" "hello_world" {
  family = "nginx"

  volume {
    name      = "www"
    host_path = "/var/www/html"
  }

  container_definitions = "${data.template_file.nginx_task_definition.rendered}"
}
