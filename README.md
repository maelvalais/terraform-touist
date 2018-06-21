# Infrastructure-as-code for the TouIST web IDE

I used the [jch254/terraform-ecs-autoscale-alb] as source of inspiration
and learned a lot from it.

## Infrastructure description

- Infrasctructure-as-code using Terraform + AWS S3 for storing the
  terraform state
- AWS VPC (Virtual Private Cloud) + Internet Gateway + public and private
  subnets
- NAT Gateways for when instances need to access the internet
- ECS Cluster (Elastic Container Service)
- ALB (Application Load Balancer) in public subnet and Route53 records
  (`*.touist.eu`)
- two ECS services for running the API and www containers using each an ASG
  (Auto Scaling Group) and ALB listeners (API on host api.touist.eu and www
  for the rest) and sharing the same TG (Target Group).
- AWS CloudWatch for monitoring with fine-grained rules as to when to
  upscale/downscale
- Bastion instance in public subnet (in ASG with a fixed size of one so
  that only one public IP address can access it).

Containers:

- API: <https://hub.docker.com/r/touist/editor-server/>
- www: <https://hub.docker.com/r/touist/editor-ide/>

[![infra-png]][infra-original]

Schema made using Lucidchart.

## Manual provisioning

Note that the `modules.tf` at the root of the project is not stored in this
repo as it contains sensitive stuff.

    # deploy:
    terraform init
    terraform apply

    # and when I want to stop paying:
    terraform destroy

## Deployment via GitLab CI

Deployment to AWS is automated via GitLab CI plugged to Github.

[jch254/terraform-ecs-autoscale-alb]:https://github.com/jch254/terraform-ecs-autoscale-alb
[infra-png]:https://www.lucidchartcom/publicSegments/view/1c8a62fe-a315-4c32-9079-fd7624ac1eb1/image.png
[infra-original]: https://www.lucidchart.com/documents/view/567962c6-3cd2-450d-afcf-a68f9561a729
