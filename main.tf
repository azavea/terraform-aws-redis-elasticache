#
# Security group resources
#

resource "aws_security_group" "redis" {
  name = "cache-security-group"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  tags {
    Name = "sgCacheCluster"
  }
}

#
# ElastiCache resources
#

resource "aws_elasticache_cluster" "redis" {
  cluster_id = "cache"
  engine = "redis"
  engine_version = "${var.engine_version}"
  maintenance_window = "${var.maintenance_window}"
  node_type = "${var.instance_type}"
  num_cache_nodes = "1"
  parameter_group_name = "default.redis2.8"
  port = "6379"
  subnet_group_name = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids = ["${aws_security_group.redis.id}"]

  tags {
    Name = "CacheCluster"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name = "cache-subnet-group"
  description = "Private subnets for the ElastiCache instances"
  subnet_ids = ["${split(",", var.private_subnet_ids)}"]
}

#
# CloudWatch resources
#

resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name = "alarmCacheClusterCPUUtilization"
  alarm_description = "Cache cluster CPU utilization" 
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ElastiCache"
  period = "300"
  statistic = "Average"
  threshold = "75"
  dimensions {
    CacheClusterId = "${aws_elasticache_cluster.redis.id}"
  }
  alarm_actions = ["${split(",", var.alarm_actions)}"]
}

resource "aws_cloudwatch_metric_alarm" "memory_free" {
  alarm_name = "alarmCacheClusterFreeableMemory"
  alarm_description = "Cache cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "FreeableMemory"
  namespace = "AWS/ElastiCache"
  period = "60"
  statistic = "Average"
  # 10MB in bytes
  threshold = "10000000"
  dimensions {
    CacheClusterId = "${aws_elasticache_cluster.redis.id}"
  }
  alarm_actions = ["${split(",", var.alarm_actions)}"]
}
