FROM wordpress:cli

USER root

RUN apk update && apk add mariadb-client

# 필요하다면 다시 권한 낮추기
USER www-data
