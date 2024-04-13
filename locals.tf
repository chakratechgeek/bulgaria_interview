locals {
  db_instances = {
    pgsql_db_primary = {
      ami                         = "ami-0f007bf1d5c770c6e" # Amazon Linux 2023 AARCH64
      instance_type               = "t3.small"
      key_name                    = "interview-ssh-key"
      vpc_security_group_ids      = [aws_security_group.db_sg.id]
      subnet_id                   = aws_subnet.inter_db_subnet_prim.id
      associate_public_ip_address = false
      root_block_device = {
        volume_size = 50 # Specify the desired storage size in GB
        encrypted   = true
        kms_key_id  = aws_kms_key.inter_kms_ec2_db.key_id # Use the KMS key for encryption
      }
    },
    pgsql_db_standby = {
      ami                         = "ami-0f007bf1d5c770c6e" # Amazon Linux 2023 AARCH64
      instance_type               = "t3.small"
      key_name                    = "interview-ssh-key"
      vpc_security_group_ids      = [aws_security_group.db_sg.id]
      subnet_id                   = aws_subnet.inter_db_subnet_stby.id
      associate_public_ip_address = false
      root_block_device = {
        volume_size = 50 # Specify the desired storage size in GB
        encrypted   = true
        kms_key_id  = aws_kms_key.inter_kms_ec2_db.key_id # Use the KMS key for encryption
      }
    },
    app_ec2 = {
      ami                         = "ami-0f007bf1d5c770c6e" # Amazon Linux 2023 AARCH64
      instance_type               = "t3.small"
      key_name                    = "interview-ssh-key"
      vpc_security_group_ids      = [aws_security_group.app_sg.id]
      subnet_id                   = aws_subnet.inter_app_subnet.id
      associate_public_ip_address = true
      root_block_device = {
        volume_size = 50 # Specify the desired storage size in GB
        encrypted   = true
        kms_key_id  = aws_kms_key.inter_kms_ec2_db.key_id # Use the KMS key for encryption
      }
    }
  }

  alarms = {
    pgsql_db_primary = {
      cpu_utilization = {
        metric_name = "CPUUtilization"
        threshold   = 70
      },
      network_packets_in = {
        metric_name = "NetworkPacketsIn"
        threshold   = 1000
      },
      status_check_failed = {
        metric_name = "StatusCheckFailed"
        threshold   = 1
      }
    },
    pgsql_db_standby = {
      cpu_utilization = {
        metric_name = "CPUUtilization"
        threshold   = 70
      },
      network_packets_in = {
        metric_name = "NetworkPacketsIn"
        threshold   = 1000
      },
      status_check_failed = {
        metric_name = "StatusCheckFailed"
        threshold   = 1
      }
    },
    app_ec2 = {
      cpu_utilization = {
        metric_name = "CPUUtilization"
        threshold   = 70
      },
      network_packets_in = {
        metric_name = "NetworkPacketsIn"
        threshold   = 1000
      },
      status_check_failed = {
        metric_name = "StatusCheckFailed"
        threshold   = 1
      }
    }
 }
}