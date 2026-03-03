# ============================================================================
# Container Outputs
# ============================================================================

output "container_id" {
  description = "The ID of the serverless container"
  value       = scaleway_container.main.id
}

output "container_name" {
  description = "The name of the serverless container"
  value       = scaleway_container.main.name
}

output "container_endpoint" {
  description = "The default endpoint URL of the serverless container"
  value       = scaleway_container.main.domain_name
}

output "container_status" {
  description = "The status of the serverless container"
  value       = scaleway_container.main.status
}

# ============================================================================
# Domain Outputs
# ============================================================================

output "domain_hostname" {
  description = "The custom domain hostname for the container (only set when DNS is configured)"
  value       = length(scaleway_container_domain.main) > 0 ? scaleway_container_domain.main[0].hostname : null
}

output "domain_url" {
  description = "The full URL of the container with custom domain (only set when DNS is configured)"
  value       = length(scaleway_container_domain.main) > 0 ? scaleway_container_domain.main[0].url : null
}

# ============================================================================
# DNS Record Outputs
# ============================================================================

output "dns_record_fqdn" {
  description = "The fully qualified domain name of the DNS record (only set when DNS is configured)"
  value       = length(scaleway_domain_record.main) > 0 ? "${scaleway_domain_record.main[0].name}.${scaleway_domain_record.main[0].dns_zone}" : null
}

# ============================================================================
# IAM API Key Outputs
# ============================================================================

output "iam_api_key_secret_id" {
  description = "The ID of the secret storing the IAM API key (only set for private containers with iam_application_id)"
  value       = length(scaleway_secret.container_secret_key) > 0 ? scaleway_secret.container_secret_key[0].id : null
}

output "iam_api_key_secret_name" {
  description = "The name of the secret storing the IAM API key (only set for private containers with iam_application_id)"
  value       = length(scaleway_secret.container_secret_key) > 0 ? scaleway_secret.container_secret_key[0].name : null
}