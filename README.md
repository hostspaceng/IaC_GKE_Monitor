# Terraform_Kubernetes_Monitoring

---

# Setting Up Prometheus, Grafana, Loki to Monitor a Pod

## Overview

This guide provides comprehensive steps to set up Prometheus, Grafana, Loki, and monitor a Kubernetes Pod with Prometheus.

### Pre-requisites:

- A running Kubernetes cluster.
- `kubectl` configured to interact with your cluster.
- Helm installed on your local machine

## Step 1: Install Prometheus

The Prometheus using it's Helm Chart

```shell
helm install my-prometheus prometheus-community/prometheus
```

## Step 2: Create a Pod & PodMonitor

Let’s assume you have a Pod manifest as follows:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-metrics
  labels:
    name: demo-metrics
  annotations:
    prometheus.io/scrape: 'true'
spec:
  containers:
    - name: demo-metrics
      image: quay.io/brancz/prometheus-example-app:v0.3.0
      ports:
        - containerPort: 8080
          name: demo-metrics
```

You can create a PodMonitor to scrape metrics from this Pod:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: demo-metrics-pod-monitor
  labels:
    release: prometheus
spec:
  podMetricsEndpoints:
  - port: demo-metrics
  selector:
    matchLabels:
      name: demo-metrics
```

Apply it with:

```shell
kubectl apply -f demo-metrics-pod-monitor.yaml
```

*We can visualize the metrics on the target endpoint*

## Step 3: Install Grafana

Use Helm to install Grafana for visualizing Prometheus metrics.

```shell
helm install grafana grafana/grafana
```

## Step 4: Install Loki

Loki can be installed for log aggregation, making it a great companion for Grafana. We would use Promtail to collect the logs.

```shell
helm install loki grafana/loki \
  --set loki.auth_enabled=false \
  --set minio.enabled=true

helm install promtail grafana/promtail 
```

## Step 5: Access the Deployed Services

- **Prometheus:** Use `kubectl get svc` to find the Prometheus service's CLUSTER-IP and access it at `http://<CLUSTER-IP>:9090`.
- **Grafana:** The same step applies to Grafana, and it can typically be accessed at `http://<CLUSTER-IP>:3000`.
- **Loki:** Loki will be added to Grafana as a datasource, allowing you to query logs directly from the Grafana UI.

## Conclusion

You now have Prometheus scraping metrics from a specific Pod, Grafana for metrics visualization, Loki for log aggregation, and MinIO for storage.
