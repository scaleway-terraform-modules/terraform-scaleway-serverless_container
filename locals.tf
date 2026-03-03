locals {
  secret_name = var.secret_name != null ? var.secret_name : "${upper(var.name)}-AUTH-SECRET-KEY"
  secret_path = var.secret_path != null ? var.secret_path : "/containers"
}