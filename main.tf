#
# Security group resources
#
resource "aws_security_group" "redis" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "sgCacheCluster"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  name        = "subnet-group-${lower(var.cache_identifier)}"
  description = "Private subnets for the ElastiCache instances:  ${lower(var.cache_identifier)}"
  subnet_ids  = ["${data.aws_subnet_ids.private.ids}"]
}

#
# ElastiCache resources
#
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${lower(var.cache_identifier)}"
  replication_group_description = "Replication group for Redis"
  automatic_failover_enabled    = "${var.automatic_failover_enabled}"
  number_cache_clusters         = "${var.desired_clusters}"
  node_type                     = "${var.instance_type}"
  engine_version                = "${var.engine_version}"
  parameter_group_name          = "${var.parameter_group}"
  subnet_group_name             = "${var.subnet_group == "" ? aws_elasticache_subnet_group.default.name : var.subnet_group }"
  security_group_ids            = ["${aws_security_group.redis.id},${data.aws_security_group.default.id}"]
  maintenance_window            = "${var.maintenance_window}"
  notification_topic_arn        = "${var.notification_topic_arn}"
  port                          = "6379"

  tags {
    Name        = "CacheReplicationGroup"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

#
# CloudWatch resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count = "${var.desired_clusters}"

  alarm_name          = "alarm${var.environment}CacheCluster00${count.index + 1}CPUUtilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = "${var.alarm_cpu_threshold}"

  dimensions {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }

  alarm_actions = ["${var.alarm_actions}"]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count = "${var.desired_clusters}"

  alarm_name          = "alarm${var.environment}CacheCluster00${count.index + 1}FreeableMemory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = "${var.alarm_memory_threshold}"

  dimensions {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }

  alarm_actions = ["${var.alarm_actions}"]
}
