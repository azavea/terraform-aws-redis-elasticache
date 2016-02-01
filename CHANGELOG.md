## 0.3.0

- Add cache name to alarm names so multiple instances do not conflict within
  the same AWS account.
- Apply hclfmt.

## 0.2.0

- Remove hardcoded identifiers and interpolate the new `cache_name` variable to
  create unique resource names.

## 0.1.0

- Initial release.
