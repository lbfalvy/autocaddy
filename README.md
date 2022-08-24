A Caddy instance configured to reverse-proxy subdomains to hostnames.

Run the image with

```bash
docker run -p 80:80 -p 443:443 --env DOMAIN=$DOMAIN --net $PUBLIC_NET lbfalvy/autocaddy
```

And make sure your clients resolve `*.$DOMAIN` to the container host.
Containers on `$PUBLIC_NET` will be proxied to `$ALIAS.$DOMAIN` where
`$ALIAS` is the target container's alias. Note that only single-label
aliases (aliases that don't contain a dot) are proxied.

For added security, you can also specify a nonstandard `$PORT` for
forwarded HTTP traffic, so that containers and other hosts accidentally
proxied by Autocaddy will fail to respond. This doesn't fully protect
against malicious or compromised hosts, but requires that the attacker be
able to expose ports on them.

