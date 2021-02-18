output "region" {
  value = local.region
}

output "deployment_bucket" {
  value = var.deployment_bucket
}

output "invoke_url" {
  value = module.api.base_url
}

output "user_pool_id" {
  value = module.api.user_pool_id
}

output "client_id" {
  value = module.api.client_id
}

output "api_key" {
  value = module.api.dev_key
}