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

#FROM            nginx
#RUN             rm -rf /usr/share/nginx/html/*
#RUN             mkdir -p /var/cache/nginx /var/run/nginx \
#                && chown -R nginx:nginx /var/cache/nginx /var/run/nginx
#
#COPY            ./ /usr/share/nginx/html/
#COPY            default.conf  /etc/nginx/conf.d/default.conf
#COPY            nginx.conf  /etc/nginx/nginx.conf
#EXPOSE          8080
#USER            nginx

# syntax=docker/dockerfile:1.7

# syntax=docker/dockerfile:1.7

############ Stage 1: prep (optional tidy/filter) ############
FROM busybox:1.37.0-uclibc AS prep
WORKDIR /src

COPY . .



############ Stage 2: nginx runner (non-root) ############
FROM nginx:1.27-alpine AS runner


RUN rm -rf /usr/share/nginx/html/* \
 && mkdir -p /var/cache/nginx /var/run/nginx \
 && chown -R nginx:nginx /var/cache/nginx /var/run/nginx /usr/share/nginx/html \
 && chown -R nginx:nginx /etc/nginx /etc/nginx/conf.d


COPY  nginx.conf /etc/nginx/nginx.conf
COPY  default.conf /etc/nginx/conf.d/default.conf

# Copy static site content with correct ownership
COPY --chown=nginx:nginx --from=prep /src/ /usr/share/nginx/html/


ENV PORT=8080
EXPOSE 8080

USER nginx

# Alpine nginx image has busybox wget; use it for healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD wget -qO- "http://127.0.0.1:${PORT}/health" >/dev/null 2>&1 || exit 1


