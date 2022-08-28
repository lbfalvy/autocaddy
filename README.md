A Caddy instance configured to reverse-proxy subdomains to hostnames.

# Usage

1. Create a dedicated Docker network `PUBLIC_NET`
2. Connect any containers you'd like to expose to `PUBLIC_NET`, have them all respond to plain
    HTTP on this network
3. Connect this container to `PUBLIC_NET` and expose HTTP and HTTPS ports. Environment variables
    to be specified:
    - DOMAIN: the domain name under which to proxy subdomains without the wildcard label. (eg. for `*.example.com` use `example.com`)
    - DNS: the DNS provider's name as recognized by [Lego](https://go-acme.github.io/lego/dns/)
    - EMAIL: email address to use in certificates
    - Any environment variables required to configure Lego for your DNS provider
4. Persist `/config`, `/data` and `/lego` using eg. volumes or bind mounts. The first two are
    managed by Caddy, the third is used to store certificates, secret keys and other related data.
    Failure to persist this directory may result in hitting Let's Encrypt rate limits, which can
    prevent you from obtaining TLS certificates for a week

Example command for Linode:

```bash
docker run -d -p 80:80 -p 443:443 --net exposed \
    -e DOMAIN=example.com -e EMAIL=webmaster@example.com \
    -e DNS=linode -e LINODE_TOKEN=<token>
    -v autocaddy_config:/config -v autocaddy_data:/data -v autocaddy_lego:/lego \
    lbfalvy/autocaddy
```

Note that hostnames are deduced from the request and only ever a single label is matched,
so the above example configuration will proxy `foo.example.com` to `foo` and
`caddy.community.example.com` to `community`, however, there's no hostname filtering so all hosts
visible from the caddy container under a single-label hostname will be proxied.

To improve security, you can also specify the `PORT` envvar for forwarded HTTP traffic, so that
containers and other hosts accidentally proxied by Autocaddy will fail to respond. This doesn't
protect against malicious or compromised hosts able to bind single-label hostnames, it just
prevents exposing friendly hosts by mistake.
