locals {
  region = var.aws_region
  ecr_defaults = {
    repository_name = "hello-world"
  }
  ecr = merge(local.ecr_defaults, var.ecr_values)

  ecs_defaults = {
    cluster_name = "hello-cluster"
    service_name = "hello-service"
  }
  ecs = merge(local.ecs_defaults, var.ecs_values)

  lb_defaults = {
    name     = "hello-alb"
    internal = false
    target_group = {
      name     = "hello-alb-tg"
      port     = 80
      protocol = "HTTP"
    }
  }
  lb = merge(local.lb_defaults, var.lb_values)

  vpc_defaults = {
    id = ""
  }
  vpc             = merge(local.vpc_defaults, var.vpc)
  use_default_vpc = local.vpc.id == ""

  container_defaults = {
    name  = "hello-apps"
    image = "lanxic/hello-world:1.0.0"
    ports = [80]
  }
  container = merge(local.container_defaults, var.container)
}
