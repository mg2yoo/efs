## 
data "aws_availability_zones" "available" {}

data "aws_vpc" "vpc" {
  id = lookup(var.vpc_id, terraform.workspace, "go")
}

## get the private key
data " tls_private_key" "mykey" {

}
resource "aws_efs_file_system" "efs" {
  creation_token = lookup(var.efs_name, terraform.workspace, "go")

  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(var.tags, {
    Name = lookup(var.efs_name, terraform.workspace, "go_va_zoomevents_zemonitor_data-sg")
  })
}

# resource "aws_subnet" "subnet" {
#   count             = length(lookup(var.efs_availability_zones, terraform.workspace, "go"))
#   vpc_id            = data.aws_vpc.vpc.id
#   cidr_block        = lookup(var.efs_subnet_ids, terraform.workspace)[count.index]
#   availability_zone = lookup(var.efs_availability_zones, terraform.workspace)[count.index]
# }

resource "aws_efs_mount_target" "efs-mount" {
  #count           = length(lookup(var.efs_availability_zones, terraform.workspace))
  count           = length(lookup(var.efs_subnet_ids, terraform.workspace))
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.efs_subnet_ids["${terraform.workspace}"][count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

# Creating Mount Point for EFS
resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.efs-mount]
  connection {
    type        = "ssh"
    user        = "yubang.gao"
    private_key = tls_private_key.my_key.private_key_pem
    host        = aws_instance.web.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      # "sudo yum install httpd php git -y -q ",
      # "sudo systemctl start httpd",
      # "sudo systemctl enable httpd",
      # "sudo yum install nfs-utils -y -q ", # Amazon ami has pre installed nfs utils
      # # Mounting Efs 
      # "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  /var/www/html",
      # # Making Mount Permanent
      # "echo ${aws_efs_file_system.efs.dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab ",
      # "sudo chmod go+rw /var/www/html",
      # "sudo git clone https://github.com/Apeksh742/EC2_instance_with_terraform.git /var/www/html",
    ]
  }
}
