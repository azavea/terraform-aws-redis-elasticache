# terraform-aws-redis-elasticache

A Terraform module to create an Amazon Web Services (AWS) Redis ElastiCache cluster.

## Usage

```hcl
resource "aws_sns_topic" "global" {
  ...
}

resource "aws_elasticache_subnet_group" "redis" {
  ...
}

resource "aws_elasticache_parameter_group" "redis" {
  ...
}

module "cache" {
  source = "github.com/azavea/terraform-aws-redis-elasticache"

  vpc_id                     = "vpc-20f74844"
  cache_identifier           = "cache"
  automatic_failover_enabled = "false"
  desired_clusters           = "1"
  instance_type              = "cache.t2.micro"
  engine_version             = "3.2.4"
  parameter_group            = "${aws_elasticache_parameter_group.redis.name}"
  subnet_group               = "${aws_elasticache_subnet_group.redis.name}"
  maintenance_window         = "sun:02:30-sun:03:30"
  notification_topic_arn     = "${aws_sns_topic.global.arn}"

  alarm_cpu_threshold    = "75"
  alarm_memory_threshold = "10000000"
  alarm_actions          = ["${aws_sns_topic.global.arn}"]

  project     = "Unknown"
  environment = "Unknown"
}
```

## Variables

- `vpc_id` - ID of VPC meant to house the cache
- `project` - Name of the project making use of the cluster (default: `Unknown`)
- `environment` - Name of environment the cluster is targeted for (default: `Unknown`)
- `cache_identifier` - Name used as ElastiCache cluster ID
- `automatic_failover_enabled` - Flag to determine if automatic failover should be enabled
- `desired_clusters` - Number of cache clusters in replication group
- `instance_type` - Instance type for cache instance (default: `cache.t2.micro`)
- `engine_version` - Cache engine version (default: `3.2.4`)
- `parameter_group` - Cache parameter group name (default: `redis3.2`)
- `subnet_group` - Cache subnet group name
- `maintenance_window` - Time window to reserve for maintenance
- `notification_topic_arn` - ARN to notify when cache events occur
- `alarm_cpu_threshold` - CPU alarm threshold as a percentage (default: `75`)
- `alarm_memory_threshold` - Free memory alarm threshold in bytes (default: `10000000`)
- `alarm_actions` - ARN to be notified via CloudWatch when alarm thresholds are triggered

## Outputs

- `id` - The replication group ID
- `cache_security_group_id` - Security group ID of the cache cluster
- `port` - Port of replication group leader
- `endpoint` - Public DNS name of replication group leader
