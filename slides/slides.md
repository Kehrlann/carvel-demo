---
theme: /Users/dgarnier/workspace/daniel/github/carvel-demo/slides/theme.json
author: Daniel Garnier-Moiroux
date: 2023-09-21
paging: Slide %d / %d

---
# The Carvel tool suite

## Deploy apps on Kubernetes following the Unix Philosophy

Daniel Garnier-Moiroux

Swiss Cloud Native Day, 2023-09-21

---
# The plan

1. **What's Carvel?**
1. Build and deploy a simple application
1. Modify an existing app
1. Make it prod-ready and publish it
1. Package it all up as an "application"

---
# What's carvel?

CNCF **Sandbox** project

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
1. Package it all up as an "application"

---
# Build and deploy an app: ytt and kapp

### ytt: YAML templating tool

YAML-aware, equivalent to Helm & Kustomize

Control flow (for, if), functions, data values, overlays

<span></span>

### kapp: "app"-aware replacement for kubectl

Client-side + ConfigMap, equivalent to kubectl

Group resources, wait rules, config versioning

---
# The plan

1. What's Carvel?
1. Build and deploy a simple application
1. **Modify an existing app**
1. Make it prod-ready and publish it
1. Package it all up as an "application"

---
# The plan

1. What's Carvel?
1. Build and deploy a simple application
1. Modify an existing app
1. **Make it prod-ready and publish it**
1. Package it all up as an "application"

---
# ytt

## ytt is back!

⏩ Demo

Overlays, modifying existing documents

⏩ Interactive playground: https://carvel.dev/ytt/

<span style="conceal">
```bash
open https://carvel.dev/ytt/
```
</span>

---
# kbld

## ytt is back!
