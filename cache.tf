
resource "aws_elasticache_subnet_group" "example" {
  name       = "example"
  subnet_ids = [aws_subnet.inter_app_subnet.id]
}

resource "aws_elasticache_replication_group" "example" {
  replication_group_id       = "example"
  node_type                  = "cache.t2.micro"
  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.example.name
  security_group_ids         = [aws_security_group.app_sg.id]
  parameter_group_name       = "default.redis5.0"
  engine_version             = "5.0.6"
  port                       = 6379
  description                = "example description"
  transit_encryption_enabled = true
  num_cache_clusters         = 2


  # Optional: Add a description using tags
  tags = {
    Description = "Example replication group"
  }
}
