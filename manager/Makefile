up: docker-up
init: docker-down docker-pull docker-build docker-up

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build

manager-init: manager-composer-install

manager-composer-install:
	docker-compose run --rm manager-php-cli composer install

cli:
	docker-compose run --rm manager-php-cli php bin/app.php

########################################

#REGISTRY_ADDRESS=registry IMAGE_TAG=0 make build-production
build-production:
	docker build --pull --file=manager/docker/production/nginx.docker --tag ${REGISTRY_ADDRESS}/manager-nginx:${IMAGE_TAG} manager
	docker build --pull --file=manager/docker/production/php-fpm.docker --tag ${REGISTRY_ADDRESS}/manager-php-fpm:${IMAGE_TAG} manager
	docker build --pull --file=manager/docker/production/php-cli.docker --tag ${REGISTRY_ADDRESS}/manager-php-cli:${IMAGE_TAG} manager

push-production:
	docker push ${REGISTRY_ADDRESS}/manager-nginx:${IMAGE_TAG}
	docker push ${REGISTRY_ADDRESS}/manager-php-fpm:${IMAGE_TAG}
	docker push ${REGISTRY_ADDRESS}/manager-php-cli:${IMAGE_TAG}

deploy-production:
	ssh ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'rm -rf docker-compose.yml .env'
	scp -P ${PRODUCTION_PORT} docker-compose-production.yml ${PRODUCTION_HOST}:docker-compose.yml
	ssh ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'echo "REGISTRY_ADDRESS=${REGISTRY_ADDRESS}" >> .env'
	ssh ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'echo "IMAGE_TAG=${IMAGE_TAG}" >> .env'
	ssh ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'docker-compose pull'
	ssh ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'docker-compose --build -d'

########################################

composer-require-slim:
	make docker-up
	docker-compose run --rm manager-php-cli composer require slim/slim

composer-create-symfony:
	make docker-up
	docker-compose run --rm manager-php-cli composer create-project symfony/website-skeleton:4.2.99 .
#	docker-compose run --rm manager-php-cli composer create-project symfony/website-skeleton:4.2.99 skeleton4299

init-mount:
	sudo mkdir -p /sys/fs/cgroup/systemd;
	sudo mount -a -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd;

make-own-files:
	sudo chown -R iriazanov /home/iriazanov/PhpstormProjects/symfony-one/project-manager/manager/

bash-command:
	docker-compose run --rm manager-php-cli bash -c "cd /root.composer/cache;pwd;ls -alt"

git-create:


########################################
