resource "aws_launch_template" "lt" {
  name_prefix   = "day24-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = "day24-key"

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  user_data = base64encode(file("scripts/user_data.sh"))
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 5
  min_size         = 1

  vpc_zone_identifier = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.tg.arn
  ]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  health_check_type = "ELB"
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "day24-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60
  }
}