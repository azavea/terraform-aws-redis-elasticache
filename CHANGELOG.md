## 2.0.1

- Fix default value for ElastiCache parameter group.

## 2.0.0

- Break backward compatibility again by swapping out the `aws_elasticache_cluster` resource with `aws_elasticache_replication_group`.
- Remove `aws_elasticache_subnet_group`.

## 1.0.0

- Break backward compatibility by removing the default security group rules
  that open `6379` to the VPC CIDR range. Module consumers and add their own
  rules via the `security_group_rule` resource.
- Add `cache_security_group_id` as a module output.

## 0.3.0

- Add cache name to alarm names so multiple instances do not conflict within
  the same AWS account.
- Apply `hclfmt`.

## 0.2.0

- Remove hardcoded identifiers and interpolate the new `cache_name` variable to
  create unique resource names.

## 0.1.0

- Initial release.
