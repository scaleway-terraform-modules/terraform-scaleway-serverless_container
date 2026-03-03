# ============================================================================
# Naming and Identification
# ============================================================================

variable "name" {
  description = "Name of the serverless container"
  type        = string
}

variable "project_id" {
  description = "Scaleway project ID where the serverless container will be created"
  type        = string
  default     = null
}

variable "tags" {
  description = "List of tags to apply to the serverless container resources"
  type        = list(string)
  default     = []
}

# ============================================================================
# Container Configuration
# ============================================================================

variable "container_namespace_id" {
  description = "ID of the container namespace where to deploy the container"
  type        = string
}

variable "image_name" {
  description = "Container image name without tag (e.g., registry.example.com/image)"
  type        = string
}

variable "app_version" {
  description = "Container image version/tag"
  type        = string
}

variable "privacy" {
  description = "Privacy policy for the container (public or private)"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private"], var.privacy)
    error_message = "Privacy must be either 'public' or 'private'."
  }
}

variable "protocol" {
  description = "Protocol to use for the container (http1 or h2c)"
  type        = string
  default     = "http1"

  validation {
    condition     = contains(["http1", "h2c"], var.protocol)
    error_message = "Protocol must be either 'http1' or 'h2c'."
  }
}

variable "deploy" {
  description = "Whether to deploy the container"
  type        = bool
  default     = true
}

variable "port" {
  description = "Port on which the container listens"
  type        = number
}

variable "timeout" {
  description = "Maximum time in seconds the container can run before timing out"
  type        = number
  default     = 300
}

variable "private_network_id" {
  description = "VPC private network ID to run the container in"
  type        = string
  default     = null
}

# ============================================================================
# Resource Limits
# ============================================================================

variable "cpu_limit" {
  description = "Maximum vCPU allocated to the container (in millicores, e.g. 1000 = 1 vCPU)"
  type        = number
  default     = null
}

variable "memory_limit" {
  description = "Maximum memory allocated to the container (in MB)"
  type        = number
  default     = null
}

# ============================================================================
# Scaling Configuration
# ============================================================================

variable "min_scale" {
  description = "Minimum number of container instances to maintain"
  type        = number
  default     = 1
}

variable "max_scale" {
  description = "Maximum number of container instances to scale to"
  type        = number
  default     = 5
}

# ============================================================================
# DNS Configuration
# ============================================================================

variable "dns_zone" {
  description = "DNS zone for the container custom domain (optional — no DNS resources are created if not set)"
  type        = string
  default     = null
}

variable "record" {
  description = "DNS record name for the container, without the zone suffix (optional — no DNS resources are created if not set)"
  type        = string
  default     = null
}

variable "dns_project_id" {
  description = "Scaleway project ID where the DNS zones and records are managed (required when dns_zone is set)"
  type        = string
  default     = null

  validation {
    condition     = var.dns_zone != null ? var.dns_project_id != null : true
    error_message = "dns_project_id must be set when dns_zone is set."
  }
}

# ============================================================================
# Container Runtime Configuration
# ============================================================================

variable "environment_variables" {
  description = "Plain-text environment variables to inject into the container"
  type        = map(string)
  default     = {}
}

variable "secret_environment_variables" {
  description = "Secret environment variables to inject into the container"
  type        = map(string)
  default     = {}
  sensitive   = true
}

# ============================================================================
# IAM Configuration (for private containers)
# ============================================================================

variable "iam_application_id" {
  description = "ID of the IAM application for which an API key will be created to authenticate against the private container. Only used when privacy is 'private'."
  type        = string
  default     = null
}

variable "secret_name" {
  description = "Name of the Scaleway Secret used to store the IAM API key. Defaults to '<NAME>-AUTH-SECRET-KEY'."
  type        = string
  default     = null
}

variable "secret_path" {
  description = "Path of the Scaleway Secret used to store the IAM API key. Defaults to '/containers'."
  type        = string
  default     = null
}