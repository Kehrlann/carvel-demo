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

- kitty + slides
- Overview of Carvel
- Use-case 1 - for developers
  - Customize a deployment with data-values
  - Deploy an app with `kapp`
  - Customize an existing package with overlays
- Use-case 2 - for operators
  - pin images with `kbld`
  - bundle with imgpkg
  - relocate with imgpkg
  - use bundle
- Use-case 3: kapp-controller
  - if time allows

## Commands

Setup:

```bash
# get vendir deps
vendir sync --locked
# install cluster stuff
./cluster-setup/setup.sh
```

Carvel setup: infra

```bash
# deploy app
kapp deploy --app infra --namespace default --file application/infra/
# visit the "private" page to make sure it works
open http://private.127.0.0.1.nip.io/
```

YTT:

```bash
ytt --file application/app | kapp deploy --app app --namespace default --file - --diff-changes --yes
```

YTT custom values:

```bash
ytt --file application/app --data-values-file other-resources/my-custom-values.yml |
  kapp deploy --app app --namespace default --file - --diff-changes --yes
```

YTT overlays:

```bash
ytt \
  --file application/infra \
  --file application/app-private/oauth2-proxy-overlay.yml \
  --data-values-file other-resources/my-custom-values.yml |
    kapp deploy \
      --app infra \
      --namespace default \
      --file - \
      --diff-changes \
      --yes
```

KBLD:

```bash
# resolve
ytt --file application/infra --file app-private/oauth2-proxy-overlay.yml --data-values-file other-resources/my-custom-values.yml |
  kbld -f - --imgpkg-lock-output application/.imgpkg/images.yml
# pre-resolved
ytt --file application/infra --file app-private/oauth2-proxy-overlay.yml --data-values-file other-resources/my-custom-values.yml |
  kbld -f - --file application/.imgpkg/images.yml
```

imgpkg push/pull:

```bash
imgpkg push --bundle docker.io/dgarnier963/carvel-demo:temp --file application/
rm -rf ~/tmp/carvel-demo/*
imgpkg pull --bundle docker.io/dgarnier963/carvel-demo:temp --output ~/tmp/carvel-demo
```

imgpkg copy:

```bash
# push it
imgpkg copy --bundle docker.io/dgarnier963/carvel-demo:temp --to-repo gcr.io/cf-identity-service-oak/dgarnier/carvel-demo
open https://console.cloud.google.com/gcr/images/cf-identity-service-oak/global/dgarnier/carvel-demo?project=cf-identity-service-oak

# pull it
rm -rf ~/tmp/carvel-demo/*
imgpkg pull --bundle gcr.io/cf-identity-service-oak/dgarnier/carvel-demo:temp --output ~/tmp/carvel-demo
```

imgpkg copy - tarball:

```bash
imgpkg copy --bundle docker.io/dgarnier963/carvel-demo:temp --to-tar ~/tmp/carvel-demo
```



## TODO

- [x] add "versioned configmaps"
- [x] styling
- [ ] wait rules for oauth2-proxy
- [ ] support Google instead of dex

