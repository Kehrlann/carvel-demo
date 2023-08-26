# carvel-demo

## Rough ideas

Carvel tools mostly for Ops

Two tracks
- dev: ytt-kapp
- ops: ytt-kbld-imgpkg-kapp ... kapp-controller if time allows

Vendir:
- distribution of files
- example with nginx ingress controller (??)
  - mmmaayyyybe

Secretgen-controller:
- it exists ... showcase certificate? secret import-export?
  - only if time allows

## Scenario ideas

- Public vs private pages, using OAuth2

Some pages will be behind OAuth2 proxy, other pages will be publicly accessible.

1. YTT: data-values to setup pages / public & private
  a. First, loop to create some public pages
  b. Second, use overlays to extend oauth2-proxy setup
2. KAPP: Wait rules and versioning for a config-map

Setup:
- OAuth2 Proxy + dex for OAuth2 support
  - (Or even better: OAuth2 Proxy + Google for OAuth2 support)

### Parked ideas

- Showcase app

1. YTT: same app with multiple domains, and a certificate if there is an HTTPs domain
2. KAPP: Wait rules and versioning for a config-map

What about using countries instead? Simple website with a page per country. But then data-values don't make much sense....

## Slides

kitty + slides

## TODO

- [ ] add "versioned configmaps"
- [ ] styling
- [ ] support Google instead of dex

