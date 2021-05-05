output "region" {
  value = module.data_lake.region
}

output "api_url" {
  value = module.data_lake.api_url
}

output "userpool_id" {
  value = module.data_lake.userpool_id
}

output "api_key" {
  value     = module.data_lake.api_key
  sensitive = true
}

output "client_id" {
  value = module.data_lake.client_id
}