
resource "aws_instance" "db_instance" {
  for_each = local.db_instances

  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = each.value.key_name
  vpc_security_group_ids      = each.value.vpc_security_group_ids
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = each.value.associate_public_ip_address

  root_block_device {
    volume_size = each.value.root_block_device.volume_size
    encrypted   = each.value.root_block_device.encrypted
    kms_key_id  = each.value.root_block_device.kms_key_id
  }

  lifecycle {
    ignore_changes = [
      root_block_device[0].kms_key_id,
      # Add other attributes here as needed
    ]
  }

  tags = {
    Name = each.key
  }
}
