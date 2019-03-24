**NOTICE:** I had to shut down `touist.eu` on July 2018 as it was only supposed to be a prototype project lasting 3 months (also it cost me $35 per month). Fortunately, putting it back online would only take a few seconds thanks to Terraform! I guess I should study a bit more how to minimize the costs (using spot EC2 instances?) Here is the overall costs of this infrastructure:

|       Service       | July 2018 (total) |
|---------------------|-------------------|
| Total cost (*$*)    | 40.47             |
| EC2-ELB (*$*)       | 19.69             |
| EC2-Instances (*$*) | 9.81              |
| Tax (*$*)           | 6.75              |
| EC2-Other (*$*)     | 3.48              |
| Route 53 (*$*)      | 0.50              |
| CloudWatch (*$*)    | 0.20              |
| S3 (*$*)            | 0.04              |
| Budgets (*$*)       | 0.00              |
| DynamoDB (*$*)      | 0.00              |

<img width="677" alt="Capture d’écran 2019-03-24 à 14 40 58" src="https://user-images.githubusercontent.com/2195781/54880365-42626c80-4e44-11e9-9e02-4bf6311857f4.png">


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

- API: <https://hub.docker.com/r/touist/editor-server>
- www: <https://hub.docker.com/r/touist/editor-ide>

[![AWS infrastructure with ALB/ELB][infra-png]][infra-original]

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
[infra-png]: https://www.lucidchart.com/publicSegments/view/1c8a62fe-a315-4c32-9079-fd7624ac1eb1/image.png
[infra-original]: https://www.lucidchart.com/documents/view/567962c6-3cd2-450d-afcf-a68f9561a729
