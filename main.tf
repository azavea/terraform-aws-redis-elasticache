#
# ElastiCache resources
#

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.cache_name}"
  engine               = "redis"
  engine_version       = "${var.engine_version}"
  maintenance_window   = "${var.maintenance_window}"
  node_type            = "${var.instance_type}"
  num_cache_nodes      = "1"
  parameter_group_name = "default.redis2.8"
  port                 = "6379"
  subnet_group_name    = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids   = "${var.security_group_ids}"

  tags {
    Name = "${var.cache_name}"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name        = "${var.cache_name}-subnet-group"
  description = "Private subnets for the ElastiCache instances"
  subnet_ids  = "${var.private_subnet_ids}"
}

#
# CloudWatch resources
#
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "alarmCacheClusterCPUUtilization-${var.cache_name}"
  alarm_description   = "Cache cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    CacheClusterName = "${var.cache_name}"
  }

  # for some reason trying to pass a list here causes the error `  * aws_cloudwatch_metric_alarm.cpu: alarm_actions: should be a list` in terraform 0.7.5
  # passing lists elsewhere works fine
  alarm_actions = ["${var.alarm_action}"]
}

resource "aws_cloudwatch_metric_alarm" "memory_free" {
  alarm_name          = "alarmCacheClusterFreeableMemory-${var.cache_name}"
  alarm_description   = "Cache cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  # 10MB in bytes
  threshold = "10000000"

  dimensions {
    CacheClusterName = "${var.cache_name}"
  }

  # for some reason trying to pass a list here causes the error `  * aws_cloudwatch_metric_alarm.cpu: alarm_actions: should be a list` in terraform 0.7.5
  # passing lists elsewhere works fine
  alarm_actions = ["${var.alarm_action}"]
}
