output "cache_security_group_id" {
  value = "${aws_security_group.redis.id}"
}

output "hostname" {
  value = "${aws_elasticache_cluster.redis.cache_nodes.0.address}"
}

output "port" {
  value = "${aws_elasticache_cluster.redis.cache_nodes.0.port}"
}

output "endpoint" {
  value = "${join(":", aws_elasticache_cluster.redis.cache_nodes.0.address, aws_elasticache_cluster.redis.cache_nodes.0.port)}"
}
