tf-init:
	docker-compose -f infra/docker-compose.yml run --rm terraform init

tf-fmt:
	docker-compose -f infra/docker-compose.yml run --rm terraform fmt

tf-validate:
	docker-compose -f infra/docker-compose.yml run --rm terraform validate

tf-plan:
	docker-compose -f infra/docker-compose.yml run --rm terraform plan

tf-apply:
	docker-compose -f infra/docker-compose.yml run --rm terraform apply

tf-destroy:
	docker-compose -f infra/docker-compose.yml run --rm terraform destroy

tf-workspace-dev:
	docker-compose -f infra/docker-compose.yml run --rm terraform workspace select dev

tf-workspace-staging:
	docker-compose -f infra/docker-compose.yml run --rm terraform workspace select staging

tf-workspace-prod:
	docker-compose -f infra/docker-compose.yml run --rm terraform workspace select prod

