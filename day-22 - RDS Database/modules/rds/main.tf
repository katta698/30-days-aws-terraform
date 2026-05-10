resource "aws_db_subnet_group" "this" {
  name = "${var.project_name}-db-subnet-group"

  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "mysql" {
  identifier             = "${var.project_name}-mysql"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [var.db_security_group]
  db_subnet_group_name   = aws_db_subnet_group.this.name
}