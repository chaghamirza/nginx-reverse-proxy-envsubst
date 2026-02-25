FROM nginx:alpine


COPY ./uwsgi_params /etc/nginx/uwsgi_params

COPY ./nginx_snippets /etc/nginx/snippets


COPY ./templates/stg-prod /etc/nginx/templates

ENV DOLLAR="$"


RUN mkdir -p /vol/static \
    && mkdir -p /var/www/certbot \
    && mkdir -p /var/www/frontend-org \
    && mkdir -p /var/www/frontend-panel \
    && mkdir -p /var/www/frontend-admin

RUN rm -f /etc/nginx/conf.d/default.conf
