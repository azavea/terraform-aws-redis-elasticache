output "hostname" {
  value = "${aws_elasticache_cluster.redis.cache_nodes.0.address}"
}

output "port" {
  value = "${aws_elasticache_cluster.redis.cache_nodes.0.port}"
}

output "endpoint" {
  value = "${join(":", aws_elasticache_cluster.redis.cache_nodes.0.address, aws_elasticache_cluster.redis.cache_nodes.0.port)}"
}
