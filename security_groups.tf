resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = var.db_sg_description
  vpc_id      = aws_vpc.inter_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.db_sg_tag_name
  }
}

resource "aws_security_group_rule" "allow_app_to_db_5432" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id        = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "allow_db_to_db_5432" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.db_sg.id
  security_group_id        = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "allow_app_to_db_22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id        = aws_security_group.db_sg.id
}


resource "aws_security_group_rule" "allow_ssh_from_internet_app" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]                # Allow traffic from any IPv4 address
  security_group_id = aws_security_group.app_sg.id # Replace app_sg with your actual security group ID
}


resource "aws_security_group" "app_sg" {
  name        = var.app_sg_name
  description = var.app_sg_description
  vpc_id      = aws_vpc.inter_vpc.id

  tags = {
    Name = var.app_sg_tag_name
  }
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "allow_https" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id        = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "allow_app_outbound_ssh" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}
