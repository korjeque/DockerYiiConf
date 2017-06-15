FROM ubuntu:16.04

ENV DEBIAN_FRONTEND 'noninteractive'

#Install Nginx
RUN apt-get update -yq \
    && apt-get install -yq nginx

COPY files /

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]