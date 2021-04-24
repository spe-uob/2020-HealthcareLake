output "region" {
  value = local.region
}

output "api_url" {
  value = module.api.api_url
}

output "userpool_id" {
  value = module.api.userpool_id
}

output "api_key" {
  value = module.api.api_key
}

output "client_id" {
  value = module.api.client_id
}