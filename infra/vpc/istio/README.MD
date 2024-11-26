# Example istio ambient mode

Install kubernetes gateway-api
```bash
kubectl apply -f standard-install.yaml
```

Install istio in ambient mode

```bash
helmfile sync
```

Enable ambient mode for namespace
```bash
kubectl label namespace ${namespace} istio.io/dataplane-mode=ambient
```

Kiali is not included, but you can install it with a few commands

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-${istio_version}/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-${istio_version}/samples/addons/kiali.yaml
```

Accessing the kiali dashboard (you need to install istioctl first)

```bash
istioctl dashboard kiali
```
