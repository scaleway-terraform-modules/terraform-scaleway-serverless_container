resource "scaleway_container" "main" {
  name         = var.name
  namespace_id = var.container_namespace_id

  registry_image = "${var.image_name}:${var.app_version}"

  privacy  = var.privacy
  protocol = var.protocol
  deploy   = var.deploy

  port    = var.port
  timeout = var.timeout

  min_scale = var.min_scale
  max_scale = var.max_scale

  cpu_limit    = var.cpu_limit
  memory_limit = var.memory_limit

  environment_variables        = var.environment_variables
  secret_environment_variables = var.secret_environment_variables

  private_network_id = var.private_network_id

  tags = var.tags
}

resource "scaleway_domain_record" "main" {
  count = var.dns_zone != null && var.record != null ? 1 : 0

  project_id = var.dns_project_id
  dns_zone   = var.dns_zone
  name       = var.record
  type       = "CNAME"
  data       = "${scaleway_container.main.domain_name}."
  ttl        = 3600
}

resource "scaleway_container_domain" "main" {
  count = var.dns_zone != null && var.record != null ? 1 : 0

  container_id = scaleway_container.main.id
  hostname     = "${var.record}.${var.dns_zone}"

  depends_on = [scaleway_domain_record.main]
}

resource "scaleway_iam_api_key" "main" {
  count = var.privacy == "private" && var.iam_application_id != null ? 1 : 0

  application_id = var.iam_application_id
}

resource "scaleway_secret" "container_secret_key" {
  count = var.privacy == "private" && var.iam_application_id != null ? 1 : 0

  name        = local.secret_name
  path        = local.secret_path
  description = "Container secret key for ${var.name}"
  project_id  = var.project_id
  tags        = var.tags
}

resource "scaleway_secret_version" "container_secret_key" {
  count = var.privacy == "private" && var.iam_application_id != null ? 1 : 0

  secret_id = scaleway_secret.container_secret_key[0].id
  data      = scaleway_iam_api_key.main[0].secret_key
}