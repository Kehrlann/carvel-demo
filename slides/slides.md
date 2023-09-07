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
- 📩 `dgarnier@vmware.com`

---
# The plan

1. **What's Carvel?**
1. Build and deploy a simple application
1. Modify an existing app
1. Make it prod-ready and publish it
1. GitOps and Package Management

---
# Disclaimer 📄

🔭 This is an overview, very partial

🧑‍💻I'm more of a "Developer", not much of an "Operator"

---
# What's carvel?

🏖️ CNCF **Sandbox** project

> Carvel provides a set of reliable, single-purpose, composable tools that aid in your application
> building, configuration, and deployment to Kubernetes.

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

- **Group resources**
- _Wait rules_
- **ConfigMap and Secret versioning**
- ...

---
# The plan

1. What's Carvel?
1. Build and deploy a simple application
1. **Modify an existing app**
1. Make it prod-ready and publish it
1. GitOps and Package Management

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
# Modify an existing app: ytt and kapp

### kapp: "app"-aware replacement for kubectl

Client-side + ConfigMap, equivalent to kubectl

- _Group resources_
- **Wait rules**
- _ConfigMap and Secret versioning_
- ...

---
# Note: YTT playground

⏩ https://carvel.dev/ytt/

<span style=conceal>
```bash
open https://carvel.dev/ytt/
```
</span>

---
# The plan

1. What's Carvel?
1. Build and deploy a simple application
1. Modify an existing app
1. **Make it prod-ready and publish it**
1. GitOps and Package Management

---
# Prod-readioness and publication: kbld and imgpkg

### kbld

kbld

<span></span>

### imgpkg

imgpkg

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

kctrl
