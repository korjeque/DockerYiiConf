# Dev server
DEV_MYSQL_SERVER_USER=admin
DEV_MYSQL_SERVER_PASS=aeKeo3Baiz3saof9xah0
DEV_MYSQL_SERVER=xxx.xxx.xxx.xxx

#------------------------------------------------------------------------------
# MAIN
#------------------------------------------------------------------------------
bootstrap:
	@$(call PRINT_INFO, "Инициализация проекта в тестовом окружении")
	php init --env=Development --overwrite=y
	@$(call PRINT_INFO, "Установка зависимостей composer")
	@composer install -n
	@$(call PRINT_INFO, "Установка зависимостей nodejs")
	@npm install --prefix ./nodejs
	@$(call PRINT_INFO, "Установка git хука для запуска тестов")
	rm -rf .git/hooks && cp -r hooks .git/hooks && chmod +x .git/hooks/*

install:
	@$(call PRINT_INFO, "Установка локального окружения")
	docker-compose up -d
	@$(MAKE) migrate

dump_export:
	@$(call PRINT_INFO, "Экспорт дампа БД с dev сервера")
	mkdir -p dumps/
	mysqldump -h $(DEV_MYSQL_SERVER) -u $(DEV_MYSQL_SERVER_USER) -p$(DEV_MYSQL_SERVER_PASS) dev > dumps/dev_`date +'%Y.%m.%d-%H:%M:%S'`.sql

dump_import:
	@$(eval RECENT_DUMP := $(shell ls -t dumps |head -n1))
	@$(call PRINT_INFO, "Импорт $(RECENT_DUMP) на db контейнер")
	docker exec -i db_1 mysql -uroot spir < dumps/$(RECENT_DUMP)

clean:
	@$(call PRINT_INFO, "Удаление локального окружения")
	@$(eval ALL_CONTAINERS := $(shell docker ps -aq))
	@$(eval ALL_IMAGES := $(shell docker images -q))
	@ if [ -n "$(ALL_CONTAINERS)" ]; then \
		docker rm -f $(ALL_CONTAINERS); \
	fi
	@ if [ -n "$(ALL_IMAGES)" ]; then \
		docker rmi -f $(ALL_IMAGES); \
	fi
	@ docker volume ls -qf dangling=true | xargs -r docker volume rm

#------------------------------------------------------------------------------
# REMOTE COMMANDS
#------------------------------------------------------------------------------
migrate:
	@$(call PRINT_INFO, "Docker: Запуск миграций")
	docker exec -i php_1 php yii migrate --interactive=0

pm2:
	@$(call PRINT_INFO, "Docker: Проверка статуса процессов pm2")
	docker exec -i pm2_1 pm2 status

codecept:
	@$(call PRINT_INFO, "Docker: Запуск тестов")
	docker exec -i php_1 php vendor/codeception/codeception/codecept run

codecept_migrate:
	@$(call PRINT_INFO, "Docker: Установка миграций для тестов")
	docker exec -i php_1 php tests/bin/yii migrate --interactive=0

codecept_api_coverage:
	@$(call PRINT_INFO, "Docker: Запуск тестов с генерацией code coverage")
	docker exec -i php_1 php vendor/codeception/codeception/codecept run api --coverage --coverage-html --coverage-xml

mysql:
	@$(call PRINT_INFO, "Mysql: Консоль")
	docker exec -i db_1 mysql -uroot

memcached:
	@$(call PRINT_INFO, "Memcached: Консоль")
	docker exec -i memcached_1 telnet 127.0.0.1 11211

shell:
	@$(call PRINT_INFO, "PsySH: Консоль")
	docker exec -i php_1 php yii shell

#------------------------------------------------------------------------------
# VARS
#------------------------------------------------------------------------------
define PRINT_INFO
	echo "\033[1;48;5;33m$1 \033[0m"
endef