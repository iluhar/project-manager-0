up: docker-up
init: docker-down-clear docker-pull docker-build docker-up manager-init
test: manager-test

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build

manager-init: manager-composer-install

manager-composer-install:
	docker-compose run --rm manager-php-cli composer install

manager-test:
	docker-compose run --rm manager-php-cli bin/phpunit

many-functions:
	docker-compose run --rm manager-php-cli php bin/console make:entity
	docker-compose run --rm manager-php-cli php bin/console make:migration
	docker-compose run --rm manager-php-cli php bin/console doctrine:migrations:migrate
	docker-compose run --rm manager-php-cli php bin/console make:crud
	docker-compose run --rm manager-php-cli php bin/console make:user
	docker-compose run --rm manager-php-cli php bin/console make:registration-form


cli-console:
	docker-compose run --rm manager-php-cli php bin/console

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
	ssh -o StrictHostKeyChecking=no ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'rm -rf docker-compose.yml .env'
	scp -o StrictHostKeyChecking=no -P ${PRODUCTION_PORT} docker-compose-production.yml ${PRODUCTION_HOST}:docker-compose.yml
	ssh -o StrictHostKeyChecking=no ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'echo "REGISTRY_ADDRESS=${REGISTRY_ADDRESS}" >> .env'
	ssh -o StrictHostKeyChecking=no ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'echo "IMAGE_TAG=${IMAGE_TAG}" >> .env'
	ssh -o StrictHostKeyChecking=no ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'echo "MANAGER_APP_SECRET=${MANAGER_APP_SECRET}" >> .env'
	ssh -o StrictHostKeyChecking=no ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'echo "MANAGER_DB_PASSWORD=${MANAGER_DB_PASSWORD}" >> .env'
	ssh -o StrictHostKeyChecking=no ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'docker-compose pull'
	ssh -o StrictHostKeyChecking=no ${PRODUCTION_HOST} -p ${PRODUCTION_PORT} 'docker-compose --build -d'

########################################

init-mount:
	sudo mkdir -p /sys/fs/cgroup/systemd;
	sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd;
# sudo mount -a -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd;
composer-require-slim:
	make docker-up
	docker-compose run --rm manager-php-cli composer require slim/slim
composer-create-symfony:
	make docker-up
	docker-compose run --rm manager-php-cli composer create-project symfony/website-skeleton:4.2.99 .
make-own-files:
	sudo chown -R iriazanov /home/iriazanov/PhpstormProjects/symfony-one/project-manager/manager/
composer-remove-pack:
	docker-compose run --rm manager-php-cli composer remove symfony/web-server-bundle
	docker-compose run --rm manager-php-cli composer install
bash-command:
	docker-compose run --rm manager-php-cli bash -c "cd /root.composer/cache;pwd;ls -alt"
git-create:
	git clone https://github.com/iluhar/project-manager.git
start-phpunit:
	docker-compose run --rm manager-php-cli php bin/phpunit
start-console:
	docker-compose run --rm manager-php-cli php bin/console cache:clear
command-x-1:
	pwd;
command-x-2:
	pwd;
command-x-3:
	pwd;

########################################
