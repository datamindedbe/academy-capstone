version := $(shell git describe --tags --always --first-parent --abbrev=7 --dirty=.dirty)
user_name:= nahian_muntasir
ecr_repo := $(user_name)-academy-capstone-summer-2022
dags_s3_folder := s3://dataminded-academy-capstone-resources/$(user_name)/dags

test:
	pytest tests

docker:
	docker build . -t 338791806049.dkr.ecr.eu-west-1.amazonaws.com/$(ecr_repo):$(version)

docker-push: docker
	docker push 338791806049.dkr.ecr.eu-west-1.amazonaws.com/$(ecr_repo):$(version)

deploy: docker-push
	cd infrastructure && terraform init && terraform apply

push-dags:
	aws s3 cp dags/dag.py $(dags_s3_folder)/dag.py