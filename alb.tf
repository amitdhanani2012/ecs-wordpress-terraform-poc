resource "aws_alb" "main" {
  name               = "wp-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.wp-elb-tf.id}"]
  subnets            = [for subnet in aws_subnet.wp-public-tf : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "wp-elb-tf"
  }



}

resource "aws_alb_target_group" "main" {
  name                 = "wp-elb-tf"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.default.id
  target_type          = "ip"
  slow_start           = 900
  deregistration_delay = 300


  health_check {
    healthy_threshold   = "5"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "120"
    unhealthy_threshold = "5"
    port                = 8080
  }

  stickiness {
    cookie_duration = 600
    cookie_name     = "wordpress-cookie-lb"
    type            = "lb_cookie"
  }
}

resource "aws_alb_listener" "http" {

  load_balancer_arn = aws_alb.main.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn

  }

}




resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.default.name}/${aws_ecs_service.wp-ecs-svc.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
