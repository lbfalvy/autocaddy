FROM caddy
RUN apk --no-cache add nss-tools bash lego
EXPOSE 80
EXPOSE 443
RUN mkdir /lego
COPY usr/bin/entrypoint /usr/bin/entrypoint
COPY usr/bin/obtain_cert /usr/bin/obtain_cert

ENTRYPOINT [ "/usr/bin/entrypoint" ]
VOLUME [ "/data", "/config", "/lego" ]
