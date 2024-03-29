resource "aws_db_subnet_group" "default" {
  name        = "wp-db-subnet-tf"
  description = "VPC Subnets"
  subnet_ids  = [for subnet in aws_subnet.wp-private-tf : subnet.id]
}

resource "aws_db_instance" "wordpress" {
  identifier             = "wordpress-tf"
  allocated_storage      = 20
  engine                 = "mariadb"
  engine_version         = "10.11.6"
  port                   = "3306"
  instance_class         = var.db_instance_type
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  vpc_security_group_ids = ["${aws_security_group.wp-db-sg-tf.id}"]
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.default.id
  parameter_group_name   = "default.mariadb10.11"
  publicly_accessible    = false
  skip_final_snapshot    = true
}
