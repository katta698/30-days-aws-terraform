data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.environment}-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Day 30 Automated Drift App!</h1>" > /var/www/html/index.html
              EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type           = "gp2"
      volume_size           = 8
      delete_on_termination = true
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  # 🌟 ADD THIS LINE TO FIX THE CLI VALIDATION ERROR 🌟
  name                = "${var.environment}-web-asg"
  
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  target_group_arns   = [aws_lb_target_group.web_tg.arn]
  vpc_zone_identifier = aws_subnet.public[*].id

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
}