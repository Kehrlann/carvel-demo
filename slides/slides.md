---
theme: /Users/dgarnier/workspace/daniel/github/carvel-demo/slides/theme.json
author: Daniel Garnier-Moiroux
date: 2023-09-21
paging: Slide %d / %d

---
# The Carvel tool suite

## Deploy apps on Kubernetes following the Unix Philosophy

🍃 Daniel Garnier-Moiroux, Engineer @ VMware

🗻🇨🇭 Swiss Cloud Native Day, 2023-09-21

---
# Daniel Garnier-Moiroux

Software Engineer @ VMware

- 🍃 Spring
- 🚢 Tanzu Application Platform


Find me online!

- 🌍 `https://garnier.wf/`
- 🐦 @Kehrlann
- 🐘 @kehrlann@hachyderm.io
- 📩 `dgarnier@vmware.com`


---
# Disclaimer 📄

🔭   This is an overview, very partial

🏎️💨 Too much content, this is going to go fast (sorry)

🧑‍💻 I'm more of a "Developer", not much of an "Operator"

---
# The plan

1. **What's Carvel?**
1. Build and deploy a simple application
1. Modify an existing app
1. Make it prod-ready and publish it
1. GitOps and Package Management

---
# What's carvel?

🏖️ CNCF **Sandbox** project

> Carvel provides a set of reliable, single-purpose, composable tools that aid in your application building, configuration, and deployment to Kubernetes.

---
# Carvel tools

⏩ https://carvel.dev/

<span style="conceal">
```bash
open https://carvel.dev/
```
</span>

---
# The plan

1. What's Carvel?
1. **Build and deploy a simple application**
1. Modify an existing app
1. Make it prod-ready and publish it
1. GitOps and Package Management

---
# Build and deploy an app: ytt and kapp

```
  ┌──────────────────────┐          ┌────────────────────────────┐
  │ Deployment           │          │ Service                    │
  │                      │          │                            │
  │   image: nginx       ◄──────────┤                            │
  │                      │          │                            │
  └──────────┬───────────┘          └────────────▲───────────────┘
             │                                   │
  ┌──────────▼───────────┐          ┌────────────┴───────────────┐
  │ ConfigMap            │          │ Ingress                    │
  │                      │          │                            │
  │   data:              │          │   fqdn:                    │
  │     index.html: ""   │          │    <name>.127.0.0.1.nip.io │
  └──────────────────────┘          └────────────────────────────┘
```

One of  these for each of:

```yaml
["apples", "bananas", "strawberries"]
```

---
# Build and deploy an app: ytt and kapp

### ytt: YAML templating tool

YAML-aware, equivalent to Helm & Kustomize

- **Control flow (for, if)**
- **Functions**
- **Data values**
- _Overlays_
- ...

---
# Build and deploy an app: ytt and kapp

### kapp: "app"-aware replacement for kubectl

Client-side + ConfigMap, equivalent to kubectl

- **Wait rules**
- **Group resources**
- **ConfigMap and Secret versioning**
- ...

---
# The plan

1. What's Carvel?
1. Build and deploy a simple application
1. **Modify an existing app**
1. Make it prod-ready and publish it
1. GitOps and Package Managemen

---
# Modify an existing app: ytt and kapp

```
┌───────────────────┐
│  OpenID Provider  │
│       (SSO)       ◄─┐ ┌───────────────────────┐    ┌────────────────────────────┐
│                   │ │ │ Deployment            │    │ Service, Ingress           │
│    (dexidp.io)    │ └─┤                       ◄────┤                            │
│                   │   │   image: oauth2-proxy │    │  private.127.0.0.1.nip.io  │
└───────────────────┘   │                       │    │                            │
                        └─┬─────────────────────┘    └────────────────────────────┘
                  ┌───────┘
      ┌───────────▼───────────┐
      │ ConfigMap             │
      │                       │
      │   data:               │
      │     config.cfg: "..." │
      └───────────────────────┘
```

---
# Modify an existing app: ytt and kapp

```
┌───────────────────┐
│  OpenID Provider  │
│       (SSO)       ◄─┐ ┌───────────────────────┐    ┌────────────────────────────┐
│                   │ │ │ Deployment            │    │ Service, Ingress           │
│    (dexidp.io)    │ └─┤                       ◄────┤                            │
│                   │   │   image: oauth2-proxy │    │  private.127.0.0.1.nip.io  │
└───────────────────┘   │                       │    │                            │
                        └─┬─────────┬───────────┘    └────────────────────────────┘
                  ┌───────┘         └─────────────┐
      ┌───────────▼───────────┐     ┌─────────────▼─────────┐
      │ ConfigMap <EDITED>    │     │ ConfigMap             │
      │                       │     │                       │
      │   data:               │     │   name: apples ...    │
      │     config.cfg: "..." │     │                       │
      └───────────────────────┘     └───────────────────────┘
```

---
# Modify an existing app: ytt and kapp

### ytt: YAML templating tool

YAML-aware, equivalent to Helm & Kustomize

- _Control flow (for, if)_
- _Functions_
- _Data values_
- **Overlays**
- ...

---
# Note: YTT playground

⏩ https://carvel.dev/ytt/

Locally:

```bash
ytt website
```

---
# The plan

1. What's Carvel?
1. Build and deploy a simple application
1. Modify an existing app
1. **Make it prod-ready and publish it**
1. GitOps and Package Management

---
# Prod-readiness and publication: kbld and imgpkg

### kbld

Search for `image:` tags in YAML, and pin references

```yaml
foo: bar
image: bitnami/nginx:1.25.2
```

⏬ kbld ⏬

```yaml
foo: bar
image: bitnami/nginx@sha256:...
```

-> 🔒 lock file

---

# Prod-readiness and publication: kbld and imgpkg

### imgpkg

"tar" & "ftp", but with OCI registries

"bundle" files in a non-runnable OCI image, and push/pull it


---

# Prod-readiness and publication: kbld and imgpkg

### imgpkg

Supports air-gapped scenarios, you can copy a bundle and ALL of its dependencies to:

- Another OCI registry
- A tarball

Leverages `.imgpkg/images.yml` to find dependencies and bundle those too

See [imgpkg / nested bundles](https://carvel.dev/imgpkg/docs/v0.37.x/resources//#nested-bundle)

---
# The plan

1. What's Carvel?
1. Build and deploy a simple application
1. Modify an existing app
1. Make it prod-ready and publish it
1. **GitOps and Package Management**

---
# GitOps and Package Management: kapp-controller

### kapp-controller

GitOps through composition:
- **fetch** - where to get manifests from
- **template** - how to change those manifests
- **deploy** - how to deploy
- **cluster** - where to deploy
  - OR **serviceAccountName** - which permissions

```yaml
apiVersion: kappctrl.k14s.io/v1alpha1
kind: App
metadata:
  name: simple-app
  namespace: default
spec: # ...
```

---
# GitOps and Package Management: kapp-controller


```yaml
kind: App
spec:
  cluster: # deploy to another cluster
  serviceAccountName: # OR deploy to the same cluster, with ServiceAccount

  fetch: # where to pull files from
    - inline: # directly in the resource
    - image: # pulls content from Docker/OCI registry
    - imgpkgBundle: # pulls imgpkg bundle from Docker/OCI registry (v0.17.0+)
    - http: # uses http library to fetch file
    - git: # uses git to clone repository
    - helmChart: # uses helm fetch to fetch specified chart

  template: # how to template the files
    - ytt: # use ytt to template configuration
    - kbld: # use kbld to resolve image references to use digests
    - helmTemplate: # use helm template command to render helm chart
    - cue: # use cue to template configuration
    - sops: # use sops to decrypt *.sops.yml files (optional; v0.11.0+)

  deploy: # how to deploy
    - kapp: # use kapp to deploy resources
```

---
# GitOps and Package Management: kapp-controller

### kapp-controller

Build `Package` and `PackageRepository` manually or with `kctrl`

Consume (install) `Package` with `kctrl package available install ...`


---
# The code - 🐙 https://github.com/kehrlann/demo

```
   ▄▄▄▄▄▄▄  ▄      ▄  ▄▄ ▄▄▄▄▄▄▄
   █ ▄▄▄ █ ▀█▄█▀ ██▄▀█   █ ▄▄▄ █
   █ ███ █ ▀▀▄▀▄█▀▀▄█▄█▄ █ ███ █
   █▄▄▄▄▄█ █ █ ▄ █▀█ ▄ █ █▄▄▄▄▄█
   ▄▄▄▄▄ ▄▄▄▄▄ █▄█▀▀▄▀ ▀▄ ▄ ▄ ▄ 
   ▀ █▄▄▄▄▄ █ ▄▄█▄▄  █▀█ ▀▀█   ▀
   ▄ ██▀ ▄▄▄█▀█  ▀▀▀▄ █     █▄▀ 
    █▀▀ ▄▄  ▀▀ ▀█▄▄██▀ ██▀▀█▄▄ ▀
   ▀█▀  █▄▀ █▄ █▀▄█▀▄▀█▀█▀█▀▄▄▀ 
   █ ▀█▄▀▄▀ ██▄▄  ▄▀█▀▀▄▀███ █ ▀
   █ ▀ ▄ ▄ ▀ ▄█  ▀▄█▄█▄███▄▄ ▄█▄
   ▄▄▄▄▄▄▄ █▀▀ ▀██▄▀█▀▄█ ▄ ███▀▀
   █ ▄▄▄ █ ▄█▀ █▀▄▄▄▄ ▀█▄▄▄█ ▄ ▀
   █ ███ █ █▀ ▄▄  ▄█▄███▄▄▄▄███▀
   █▄▄▄▄▄█ ██▀█  ▀█ ▄ ▄▀▀▄█▄▀▄▀
```

---
# 🎤 Feedback

```
 ▄▄▄▄▄▄▄  ▄  ▄▄▄▄ ▄▄  ▄    ▄▄▄▄▄▄▄
 █ ▄▄▄ █ ▄▄█▀█ ▀██ ▀█▀▀ ▀█ █ ▄▄▄ █
 █ ███ █  ▀█▀ ███ ▄▄██████ █ ███ █
 █▄▄▄▄▄█ ▄▀▄ ▄ ▄▀▄ █▀▄▀▄▀▄ █▄▄▄▄▄█
 ▄▄▄ ▄▄▄▄█▀█▄▀█ ▀ ██  █▀▄ ▄▄   ▄  
  █▄███▄ ▄▄▀▀ ▄ ▀▀▀█▀▀▄▄▀███▄▄█ ▄█
 █ ▀▀▀▄▄▄▀  ▀▄▀▀███▄▀█▀ █▄█▄  █ ▀▄
 ▄ ▄▀  ▄█▄█▄██   ▀▄ ▀▀▄█ ▀▀█▄▄▀▀▄█
 ▄ ▀▄ ▄▄█ █ ▄▀█▀ ▀█▀ █▀ ▄███  ▀ █▄
    █▄▄▄▀ █ ▀  █▀▀  ▀█▄   ▀█  ▄▀▄█
 █   █▄▄ ▀ ▀▀▄█▀█ ▀  █▀ ▄█▄▄  ▀ █▄
 ▄▀█ ▀█▄  ▀ ██▀▀ ███▀▀ ▄ ▀▀█  ▄▀▄█
 ▄▀█▀▀█▄▀▀█▀▄▀█▀ █▀▀█ █▀█▄▄█▄█  ▀ 
 ▄▄▄▄▄▄▄ █ █▀ █▄▀█▀▀▀█▄▄██ ▄ █▄▀██
 █ ▄▄▄ █ █▀▄▀▄▀ ▀▀▀▀█ █  █▄▄▄█▄  █
 █ ███ █ ▄█ ██▀   ▄█▀█ ██▀  ██▀▄█▄
 █▄▄▄▄▄█ █▀ ▄█▀▄▄█▀ ▀██ ▀██▀▄▄  █▄
```
