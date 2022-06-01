variable "aws_region" {
  default = {
    go   = "us-east-1"
    eu01 = "eu-central-1"
  }
}
variable "efs_name" {
  default = {
    go   = "go-va-zoomevents-zemonitor-efs-data"
    eu01 = "eu-ff-zoomevents-zemonitor-efs-data"
  }
}
variable "eks_nodegroup_name" {
  default = {
    go   = "go-va1-zemonitoring-eks-node-access"
    eu01 = "eu-ff-zemonitoring-eks-node-access"
  }
}

variable "efs_ingress_rules" {
  default = {
    go = [{
      description     = "from go_va_zoomevents_zemonitor"
      from_port       = 2049
      to_port         = 2049
      protocol        = "tcp"
      cidr_blocks     = ["10.0.1.240/32"]
      security_groups = []
      },
      {
        description     = "from go_va_zoomevents_zemonitor nodes"
        from_port       = 2049
        to_port         = 2049
        protocol        = "tcp"
        cidr_blocks     = ["10.0.8.117/32"]
        security_groups = []
      }
    ]
    eu01 = [{
      description     = "from eu_ff_zoomevents_zemonitor"
      from_port       = 2049
      to_port         = 2049
      protocol        = "tcp"
      cidr_blocks     = ["10.1.4.99/32"]
      security_groups = []
      }
    ]
  }
}
variable "eks_nodegroup_ingress_rules" {
  default = {
    go = [
      {
        description     = "from vpn"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["38.99.100.7/32"]
        security_groups = []
      },
      {
        description     = "bastion"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["10.0.1.47/32"]
        security_groups = []
      }
    ]
  }
}

variable "efs_availability_zones" {
  default = {
    go = ["us-east-1a", "us-east-1d"]
  }
}

variable "efs_subnet_ids" {
  default = {
    go = ["subnet-fae95ba6", "subnet-04609d0f9ca27ef54"]
    #go = ["10.0.1.0/24", "10.0.8.0/24"]
  }
}
