resource "aws_security_group" "nginx_sg" {
  name = "day19-nginx-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["108.227.216.109/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "demo" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  tags = {
    Name = "day19-provisioners-demo"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> inventory.txt"
  }

  provisioner "file" {
    source      = "scripts/welcome.sh"
    destination = "/tmp/welcome.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/welcome.sh",
      "sudo /tmp/welcome.sh"
    ]
  }
}