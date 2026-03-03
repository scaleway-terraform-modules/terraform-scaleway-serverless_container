resource "scaleway_container_namespace" "main" {
  name = "my-namespace"
}

module "container" {
  source = "../.."

  name                   = "my-service"
  container_namespace_id = scaleway_container_namespace.main.id

  image_name  = "rg.fr-par.scw.cloud/my-namespace/my-service"
  app_version = "1.0.0"

  privacy  = "public"
  protocol = "http1"
  port     = 8080

  min_scale = 0
  max_scale = 3

  environment_variables = {
    LOG_LEVEL = "info"
  }
}

output "container_endpoint" {
  description = "The default endpoint URL of the container"
  value       = module.container.container_endpoint
}