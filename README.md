# carvel-demo

This is the companion repo to the Carvel demo / talk originally given at Swiss Cloud Native day 2023
under the original title
[The Carvel toolsuite: build, configure, deploy k8s apps, following the Unix philosophy](https://cloudnativeday.ch/sessions/458712).

It showcases [Project Carvel](https://carvel.dev/) tools.

Demo is in the `demo/` directory, and slides in the ... `slides/` directory. I know.

You can run the slides with the [slides](https://github.com/maaslalani/slides) program.

To run the demo, you need:
- The Carvel toolsuite installed (see main website for install instructions)
- [KinD](https://kind.sigs.k8s.io/) installed
- Access to a registry

## Demo

> 🚨 WARNING: this README is only intended to give the commands that were run during the demo.
> It is NOT intended to explain _why_ you should run those commands, or exactly _what_ they do.

### Setup

Setup a KinD cluster with all required dependencies with:

```bash
./demo/cluster-setup/setup.sh
```

Ingresses in the cluster can be reached with `http://<INGRESS>.127.0.0.1.nip.io` ; you can test it
out with `./demo/cluster-setup/test/test.sh`, which setups a small nginx, makes sure it's reachable,
and then deletes it.

>  NOTE: setup.sh will exercise `vendir` to download some manifests we want to deploy to the
> cluster.

>  NOTE: setup.sh will exercise `kapp` to deploy things, rather than raw `kubectl`.

>  NOTE: setup.sh will exercise `ytt` overlays to change the CoreDNS configuration stored in a
> ConfigMap, so that internal traffic is routed the same as external traffic.


### YTT tempalting

First, we showcase YTT's templating capabilities. Files involved:
- `demo/application/app/app.yml`: the app itself. Take a look at it to view control-flow and
  functions
- `demo/application/app/values.yml`: default data values
- `demo/application/app/values-schema.yml`: data-values schema

Run the following to see the output:

```bash
ytt --file demo/application/app
```

You can also pass your own values, as such:

```bash
ytt --file demo/application/app --data-values-file demo/other-resources/my-custom-values.yml
```

### kapp deployments

Deploy the above with kapp:


```bash
ytt --file demo/application/app \
    --data-values-file demo/other-resources/my-custom-values.yml |
        kapp deploy --app cloudnative --file - --yes
```

Notice that the `ConfigMap` in `demo/application/app/app.yml` is annotated with:

```yaml
  annotations:
    kapp.k14s.io/versioned: ""
    kapp.k14s.io/versioned-keep-original: ""
```

Any change to the ConfigMap will create a new "version" and update the Deployments depending on it
accordingly.

Once deployed, you should be able to see the `strawberries` website at the following address:
http://strawberries.127.0.0.1.nip.io .

"Inspect" the kapp app with:

```bash
kapp inspect -a cloudnative
```

### ytt overlays

We then deploy a more complex app, by taking some additional manifests and transforming them through
overlays.

- `demo/application/infra/*.yml`: the base "additional" app we want to modify. It has a `dex`
  component that does not need modifying, and an `oauth2-proxy` we will change
- `demo/application/app-private/oauth2-proxy-overlay.yml`: an overlay file to modify the base
  `oauth2-proxy` deployment and config. It mounts the "apples" and "bananas" ConfigMaps in the
  deployment, and updates the `oauth2-proxy-config` ConfigMap to serve static files.

See it in practice with:

```bash
ytt -f demo/application/infra \
    --data-values-file demo/other-resources/my-custom-values.yml |
    kapp cloudnative -a infra -f - --yes
```

You can access the oauth2-proxy app at http://private.127.0.0.1.nip.io .

Note: the above overrides the deployment in the previous chapter.

Then apply the overlay, and redeploy everything:

```bash
ytt -f demo/application/app \
    -f demo/application/infra \
    -f demo/application/app-private \
    --data-values-file demo/other-resources/my-custom-values.yml |
    kapp cloudnative -a infra -f - --yes
```

You can then access both:
- http://private.127.0.0.1.nip.io
- http://strawberries.127.0.0.1.nip.io


### kbld

Leverage `kbld` and resolve images with:

```bash
ytt -f demo/application/app \
    -f demo/application/infra \
    -f demo/application/app-private |
    kbld -f -
```

Notice how images now have a specific sha.

If you want to produce and use a lockfile, try:

```bash
# create lockfile
ytt -f demo/application/app \
    -f demo/application/infra \
    -f demo/application/app-private |
    kbld -f - --imgpkg-lock-output demo/application/.imgpkg/images.yml
# resolve using the lockfile
ytt -f demo/application/app \
    -f demo/application/infra \
    -f demo/application/app-private |
    kbld -f - -f demo/application/.imgpkg/images.yml
```

### imgpkg

You can package up the files using:

```bash
imgpkg push --bundle <OCI-REGISTRY>/<REPOSITORY>:<TAG> --file demo/application
```

And pull them with:

```bash
imgpkg pull --bundle <OCI-REGISTRY>/<REPOSITORY>:<TAG> --output /tmp/my-imgpkg-bundle
```

You can also run a `copy`:

```bash
imgpkg copy --bundle <OCI-REGISTRY>/<REPOSITORY>:<TAG> --to-repo <TARGET-OCI-REGISTRY>/<REPOSITORY>
```

If you pull that bundle, you'll see that all images have been relocated.


### kapp-controller

> 🚨 Don't forget to delete the app deployed in the previous steps before trying the steps below

```bash
kapp delete -a cloudnative
```

GitOps with `kapp-controller`, by applying an `App` directly:

```bash
# delete previously deployed resources
kapp delete -a cloudnative || true
# deploy the App resource
kapp deploy -a cloudnative -f demo/other-resources/app.yml
```

Or, alternatively, using `kctrl`:

```bash
# delete previously deployed resources
kapp delete -a cloudnative || true

# deploy the Package-Repository
kapp deploy -a cloudnative -f demo/other-resources/package-repository.yml

# explore the available packages
kctrl package available list

# Install the demo package
kctrl package install \
    -i carvel-cloudnative \
    -p carvel-demo.garnier.wf \
    --version 1.0.0 \
    --values-file demo/other-resources/my-custom-values.yml \
    --dangerous-allow-use-of-shared-namespace

# View the demo package
kctrl package installed get -i carvel-cloudnative
```

