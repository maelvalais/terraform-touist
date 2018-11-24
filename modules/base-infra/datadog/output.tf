output "dd_agent_task_name" {
  value = "${aws_ecs_task_definition.datadog_agent.family}"
}
