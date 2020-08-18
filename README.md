# terraform-aws-ec2-superset

[![open-issues](https://img.shields.io/github/issues-raw/insight-infrastructure/terraform-aws-ec2-superset?style=for-the-badge)](https://github.com/insight-infrastructure/terraform-aws-ec2-superset/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-infrastructure/terraform-aws-ec2-superset?style=for-the-badge)](https://github.com/insight-infrastructure/terraform-aws-ec2-superset/pulls)

## Features

This module deploys superset with an RDS DB.

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
module "this" {
    source = "github.com/insight-infrastructure/terraform-aws-ec2-superset"

}
```
## Examples

- [defaults](https://github.com/insight-infrastructure/terraform-aws-ec2-superset/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| backup\_window | The window to be backing up the db during | `string` | `"03:00-06:00"` | no |
| create\_dns | Bool to create dns record | `bool` | `false` | no |
| create\_rds | Boolean to create EFS file system | `bool` | `true` | no |
| create\_superset | Bool to create superset | `bool` | `true` | no |
| domain\_name | The domain name | `string` | `""` | no |
| enable\_superset\_nginx | Bool to enable nginx | `bool` | `false` | no |
| enable\_superset\_ssl | Bool to enable ssl cert - must activate enable\_superset\_nginx | `bool` | `false` | no |
| hostname | The hostname - ie hostname.example.com | `string` | `""` | no |
| id | The id to give to rds db, falls back to name | `string` | `""` | no |
| instance\_class | instance class for DB | `string` | `"db.t3.small"` | no |
| instance\_type | Instance type | `string` | `"t2.medium"` | no |
| key\_name | The key pair to import | `string` | `""` | no |
| maintenance\_window | The time to perform maintenance | `string` | `"Mon:00:00-Mon:03:00"` | no |
| name | A unique name to give all the resources | `string` | `"superset"` | no |
| password | The password to default user | `string` | `"changemenow"` | no |
| playbook\_vars | Extra vars to include, can be hcl or json | `map(string)` | `{}` | no |
| private\_key\_path | The path to the private ssh key | `string` | n/a | yes |
| public\_key\_path | The path to the public ssh key | `string` | n/a | yes |
| rds\_public\_access | Bool to allow public access to rds | `string` | `true` | no |
| root\_volume\_size | Root volume size | `string` | `8` | no |
| subnet\_ids | The id of the subnet | `list(string)` | n/a | yes |
| superset\_postgres\_db\_host | The db host - blank for using defaults | `string` | `""` | no |
| superset\_postgres\_db\_name | the db name | `string` | `"postgres"` | no |
| superset\_postgres\_db\_password | The password | `string` | `"postgres"` | no |
| superset\_postgres\_db\_username | The db user | `string` | `"postgres"` | no |
| tags | Tags to attach to all resources | `map(string)` | `{}` | no |
| username | Default username | `string` | `"icon"` | no |
| vpc\_id | The vpc to deploy into | `string` | n/a | yes |
| vpc\_security\_group\_ids | List of security groups | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| db\_instance\_address | n/a |
| db\_instance\_endpoint | n/a |
| db\_instance\_name | n/a |
| db\_instance\_username | n/a |
| instance\_id | The instance ID created |
| key\_name | The key pair name created |
| public\_ip | The public IP of the instance created |
| rds\_security\_group | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [insight-infrastructure](https://github.com/insight-infrastructure)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.