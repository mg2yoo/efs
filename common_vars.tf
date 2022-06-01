provider "aws" {
  region = lookup(var.aws_region, terraform.workspace)
}

## common tags
variable "tags" {
  default = {
    "Team"           = "zoomeventsdevops"
    "Service"        = "Onzoom"
    "Environment"    = "production"
    "Cost_Center"    = "platform_rd"
    "engineer_owner" = "pollin.zhu@zoom.us"
    "op_owner"       = "dongli.su@zoom.us"
    "systemowner"    = "yubang.gao@zoom.us"
  }
}

variable "vpc_id" {
  description = "vpc id"
  default = {
    go       = "vpc-766aab0c"
    aw1      = "vpc-7ddb2e18"
    us01va02 = "vpc-0f3a89e8768f07bb2"
    gova02   = "vpc-0cbaab3345976842b"
    eu01     = "vpc-b6eccddd"
  }
}
