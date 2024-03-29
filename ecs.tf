resource "aws_kms_key" "wordpress" {
  description             = "wordpress kms key cloudwatch log encryption"
  deletion_window_in_days = 7
}


resource "aws_cloudwatch_log_group" "wordpress" {
  name = "wordpress"
}



resource "aws_ecs_cluster" "default" {
  name = var.ecs_cluster_name

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.wordpress.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.wordpress.name
      }
    }
  }


}


resource "aws_ecs_cluster_capacity_providers" "wordpress" {
  cluster_name = aws_ecs_cluster.default.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}



resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wp-ecs-task-tf"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 8192
  memory                   = 16384
  task_role_arn            = "arn:aws:iam::${var.accountid}:role/s3-rds-cloudwatch-role"

  execution_role_arn = "arn:aws:iam::${var.accountid}:role/cloudwatch-access-role-amit"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }


  container_definitions = template_file.wp-container.rendered
}


resource "aws_ecs_service" "wp-ecs-svc" {
  name                               = "wp-ecs-svc-tf"
  cluster                            = aws_ecs_cluster.default.id
  task_definition                    = aws_ecs_task_definition.wordpress.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  health_check_grace_period_seconds  = 300
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100



  deployment_controller {
    type = "ECS"
  }


  deployment_circuit_breaker {

    enable   = true
    rollback = false

  }


  network_configuration {
    security_groups  = ["${aws_security_group.wp-ecs-sg-tf.id}"]
    subnets          = [for subnet in aws_subnet.wp-public-tf : subnet.id]
    assign_public_ip = true
  }


  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "wordpress"
    container_port   = 8080
  }
  depends_on = [aws_alb_listener.http]
}
