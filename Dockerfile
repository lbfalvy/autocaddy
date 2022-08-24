FROM caddy/caddy
RUN apk --no-cache add nss-tools
EXPOSE 80
EXPOSE 443
COPY launch.sh /launch.sh
#COPY Caddyfile /Caddyfile
ENTRYPOINT [ "sh", "/launch.sh" ]
VOLUME [ "/data", "/config" ]
