#FROM nginx:1.25-alpine
#
#RUN rm -rf /usr/share/nginx/html/* && echo "cleared default html"
#
#LABEL maintainer="vinay" \
#      version="1.0" \
#      description="Frontend app served by Nginx with reverse proxy"
#
#LABEL description="you need to copy local file to nginx html file for it to work"
#COPY ./ /usr/share/nginx/html/
#
#COPY default.conf /etc/nginx/conf.d/default.conf
#COPY nginx.conf /etc/nginx/nginx.conf

FROM            nginx
RUN             rm -rf /usr/share/nginx/html/*
RUN             mkdir -p /var/cache/nginx /var/run/nginx \
                && chown -R nginx:nginx /var/cache/nginx /var/run/nginx

COPY            ./ /usr/share/nginx/html/
COPY            default.conf  /etc/nginx/conf.d/default.conf
COPY            nginx.conf  /etc/nginx/nginx.conf
EXPOSE          8080
USER            nginx
