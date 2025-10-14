<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam"></a> [iam](#module\_iam) | ../modules/iam | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ../modules/lambda | n/a |
| <a name="module_processed-data-bucket"></a> [processed-data-bucket](#module\_processed-data-bucket) | ../modules/s3 | n/a |
| <a name="module_raw-data-bucket"></a> [raw-data-bucket](#module\_raw-data-bucket) | ../modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | The deployment environment (e.g., 'dev', 'prd'). Used for naming resources and tagging. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | The name or ID of the team/individual responsible for this infrastructure. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The name of the project this infrastructure belongs to (e.g.,   'ikerian-challenge'). | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->