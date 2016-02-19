# terraform-aws-redis-elasticache

A Terraform module to create an Amazon Web Services (AWS) Redis ElastiCache cluster.

## Usage

```javascript
module "redis_elasticache" {
  source = "github.com/azavea/terraform-aws-redis-elasticache"

  vpc_id = "vpc-20f74844"
  vpc_cidr_block = "10.0.0.0/16"

  cache_name = "cache"
  engine_version = "2.8.22"
  instance_type = "cache.t2.micro"
  maintenance_window = "sun:05:00-sun:06:00"

  private_subnet_ids = "subnet-4a887f3c,subnet-76dae35d"

  alarm_actions = "arn:aws:sns..."
}
```

## Variables

- `vpc_id` - ID of VPC meant to house the cache
- `vpc_cidr_block` - CIDR block of VPC
- `cache_name` - Name used as ElastiCache cluster ID
- `engine_version` - Cache engine version (default: `2.8.22`)
- `instance_type` - Instance type for cache instance (default: `cache.t2.micro`)
- `maintenance_window` - 60 minute time window to reserve for maintenance
  (default: `sun:05:00-sun:06:00`)
- `private_subnet_ids` - Comma delimited list of private subnet IDs
- `alarm_actions` - Comma delimited list of ARNs to be notified via CloudWatch

## Outputs

- `cache_security_group_id` - Security group ID of the cache cluster
- `hostname` - Public DNS name of cache node
- `port` - Port of cache instance
- `endpoint` - Public DNS name and port separated by a `:`
