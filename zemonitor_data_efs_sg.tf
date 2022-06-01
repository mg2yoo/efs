## create security_group
resource "aws_security_group" "efs_sg" {
  name   = "${lookup(var.efs_name, terraform.workspace)}-sg"
  vpc_id = lookup(var.vpc_id, terraform.workspace)
  # for rules with security_groups
  dynamic "ingress" {
    for_each = lookup(var.efs_ingress_rules, terraform.workspace)
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      security_groups = ingress.value.security_groups
      cidr_blocks     = ingress.value.cidr_blocks
      protocol        = "tcp"
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {
    Name    = "${lookup(var.efs_name, terraform.workspace)}-efs-sg"
    Cluster = "go"
  })
}

output "efs-go_va_zoomevents_zemonitor_data_sg" {
  value = aws_security_group.efs_sg.name
}
