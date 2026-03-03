# terraform-scaleway-serverless_container

Terraform module to manage [Scaleway Serverless Containers](https://www.scaleway.com/en/serverless-containers/).

## Features

- Deploy a Serverless Container from any OCI-compliant registry image
- Optional custom DNS domain with automatic CNAME record creation
- Automatic IAM API key creation and storage in Scaleway Secret Manager for private containers
- VPC private network attachment support

## Usage

### Public container

```hcl
module "container" {
  source  = "scaleway/serverless_container/scaleway"
  version = ">= 1.0.0"

  name                   = "my-service"
  container_namespace_id = scaleway_container_namespace.main.id

  image_name  = "rg.fr-par.scw.cloud/my-namespace/my-service"
  app_version = "1.0.0"

  privacy  = "public"
  protocol = "http1"
  port     = 8080

  min_scale = 0
  max_scale = 5

  environment_variables = {
    LOG_LEVEL = "info"
  }
}
```

### Private container with IAM authentication

For private containers, pass the ID of an existing IAM application. The module will create an API key for that application and store the secret key in Scaleway Secret Manager.

```hcl
data "scaleway_iam_application" "my_app" {
  name = "my-iam-application"
}

module "container" {
  source  = "scaleway/serverless_container/scaleway"
  version = ">= 1.0.0"

  name                   = "my-service"
  container_namespace_id = scaleway_container_namespace.main.id
  project_id             = var.project_id

  image_name  = "rg.fr-par.scw.cloud/my-namespace/my-service"
  app_version = "1.0.0"

  privacy = "private"
  port    = 8080

  iam_application_id = data.scaleway_iam_application.my_app.application_id

  secret_path = "/my-team/my-service"
}
```

To authenticate against a private container, pass the stored secret key as the `X-Auth-Token` HTTP header.

### With a custom DNS domain

```hcl
module "container" {
  source  = "scaleway/serverless_container/scaleway"
  version = ">= 1.0.0"

  name                   = "my-service"
  container_namespace_id = scaleway_container_namespace.main.id
  project_id             = var.project_id

  image_name  = "rg.fr-par.scw.cloud/my-namespace/my-service"
  app_version = "1.0.0"

  privacy = "public"
  port    = 8080

  dns_zone       = "example.com"
  record         = "my-service"
  dns_project_id = var.dns_project_id
}
```

## Examples

- [Basic](./examples/basic) — minimal deployment of a public container


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.13 |
| scaleway | >= 2.60.0 |

## Providers

| Name | Version |
|------|---------|
| scaleway | >= 2.60.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the serverless container | `string` | — | yes |
| container\_namespace\_id | ID of the container namespace | `string` | — | yes |
| image\_name | Container image name without tag | `string` | — | yes |
| app\_version | Container image version/tag | `string` | — | yes |
| port | Port on which the container listens | `number` | — | yes |
| project\_id | Scaleway project ID for the container | `string` | `null` | no |
| tags | List of tags to apply to all resources | `list(string)` | `[]` | no |
| privacy | Privacy policy (`public` or `private`) | `string` | `"private"` | no |
| protocol | Protocol (`http1` or `h2c`) | `string` | `"http1"` | no |
| deploy | Whether to deploy the container | `bool` | `true` | no |
| timeout | Maximum execution time in seconds | `number` | `300` | no |
| cpu\_limit | Maximum vCPU in millicores (e.g. 1000 = 1 vCPU) | `number` | `null` | no |
| memory\_limit | Maximum memory in MB | `number` | `null` | no |
| min\_scale | Minimum number of instances | `number` | `1` | no |
| max\_scale | Maximum number of instances | `number` | `5` | no |
| private\_network\_id | VPC private network ID | `string` | `null` | no |
| environment\_variables | Plain-text environment variables | `map(string)` | `{}` | no |
| secret\_environment\_variables | Secret environment variables | `map(string)` | `{}` | no |
| dns\_zone | DNS zone for the custom domain | `string` | `null` | no |
| record | DNS record name (without zone suffix) | `string` | `null` | no |
| dns\_project\_id | Scaleway project ID for DNS management (required when `dns_zone` is set) | `string` | `null` | no |
| iam\_application\_id | ID of the IAM application to authenticate against the private container | `string` | `null` | no |
| secret\_name | Name of the secret storing the IAM API key | `string` | `"<NAME>-AUTH-SECRET-KEY"` | no |
| secret\_path | Path of the secret storing the IAM API key | `string` | `"/containers"` | no |

## Outputs

| Name | Description |
|------|-------------|
| container\_id | The ID of the serverless container |
| container\_name | The name of the serverless container |
| container\_endpoint | The default endpoint URL of the serverless container |
| container\_status | The status of the serverless container |
| domain\_hostname | The custom domain hostname (only set when DNS is configured) |
| domain\_url | The full URL with custom domain (only set when DNS is configured) |
| dns\_record\_fqdn | The fully qualified DNS record name (only set when DNS is configured) |
| iam\_api\_key\_secret\_id | The ID of the secret storing the IAM API key (only set for private containers) |
| iam\_api\_key\_secret\_name | The name of the secret storing the IAM API key (only set for private containers) |

<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/tree/master/LICENSE) for full details.