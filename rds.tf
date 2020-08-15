resource "aws_security_group" "default" {
  name        = "${var.db_name} db SG"
  description = "Allow Postgres traffic"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = {
    "Name" = "${var.db_name} db SG"
  }
}

resource "aws_security_group_rule" "allow_ingress" {
  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["${concat(data.terraform_remote_state.vpc.public_cidrs, data.terraform_remote_state.vpc.private_cidrs)}"]

  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "allow_egress" {
  type        = "egress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["${concat(data.terraform_remote_state.vpc.public_cidrs, data.terraform_remote_state.vpc.private_cidrs)}"]

  security_group_id = "${aws_security_group.default.id}"
}
resource "aws_db_parameter_group" "default" {
  name   = "${var.db_name}"
  family = "postgres10"

  # Enable logging
  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name = "log_min_duration_statement"

    # in milliseconds
    value = "1000"
  }

  tags = {
    "Name" = "Postgres param group for ${var.db_name}"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${data.terraform_remote_state.vpc.private_subnets}"]

  tags = {
    "Name" = "${var.db_name} subnet group"
  }
}

resource "random_string" "db_password" {
  length  = 24
  lower   = true
  upper   = true
  number  = true
  special = false
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.environment}/db/terraform/admin"
  description = "Admin password for ${var.db_name} db"
  type        = "SecureString"
  value       = "${random_string.db_password.result}"
}


resource "aws_db_instance" "default" {
  identifier           = "${var.db_name}"
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.4"
  instance_class       = "${var.instance_class}"
  name                 = "${var.db_name}"
  username             = "${var.username}"
  password             = "${random_string.db_password.result}"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
  parameter_group_name = "${aws_db_parameter_group.default.id}"
  publicly_accessible  = false
  skip_final_snapshot  = true

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags = {
    "Name" = "${var.db_name}"
  }
}