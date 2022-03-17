output "id" {
  value = aws_elasticache_replication_group.redis.id
}

output "cache_security_group_id" {
  value = aws_security_group.redis.id
}

output "port" {
  value = "6379"
}

output "endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

