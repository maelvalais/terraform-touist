# The Datadog agent task definition
data "template_file" "datadog_agent_task_definition" {
  template = "${file("${path.module}/datadog-agent-task-definition.json")}"

  vars {
    datadog_api_key = "${var.datadog_api_key}"
  }
}

# The ECS task that specifies which Docker container we need to run the Datadog agent container
resource "aws_ecs_task_definition" "datadog_agent" {
  family = "dd-agent-task"

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "proc"
    host_path = "/proc/"
  }

  volume {
    name      = "cgroup"
    host_path = "/cgroup/"
  }

  container_definitions = "${data.template_file.datadog_agent_task_definition.rendered}"
}
