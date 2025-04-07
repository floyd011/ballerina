# Ballerina Observability Starter Kit

This starter kit contains a basic Ballerina application integrated with Prometheus and Grafana for monitoring metrics. It also includes a Helm chart for easy deployment on a Kubernetes cluster.

## Components

- **Ballerina App**: A REST service with a health endpoint and custom metrics.
- **Prometheus**: Collects application metrics and exposes them for visualization and alerting.
- **Grafana**: Visualizes your metrics with beautiful, customizable dashboards.
- **AlertManager**: Sends notifications based on alerting rules.
- **Helm Chart**: For easy deployment on Kubernetes.

## Prerequisites

Before starting the deployment, ensure you have the following installed:
- A Kubernetes cluster (local or cloud-based)
- Helm 3
- Prometheus and Grafana installed in the cluster
- Docker (if you want to build images locally)

## Deploy

### 1. Build Docker Image for Ballerina Application

First, we need to build a Docker image for your Ballerina application. Create a `Dockerfile` in the root directory of the repository:

```Dockerfile
FROM ballerina/ballerina:slbeta

COPY ballerina-app/ /home/ballerina/ballerina-app/

WORKDIR /home/ballerina/ballerina-app/

RUN ballerina build main.bal

CMD ["bal", "run", "main.bal"]
```

Then, build the Docker image:

```bash
docker build -t ballerina-user-service:latest .
```

### 2. Deploy with Helm

Before deploying the application, we need to set up Prometheus monitors via Helm.
	1.	Add the Prometheus repo (if not already added):
 
    ```bash
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    ```

2.	Deploy Prometheus and Grafana:

    ```bash
    helm install prometheus prometheus-community/kube-prometheus-stack
    ```

3.	Deploy your Ballerina application with the Helm chart:

    ```bash
    helm install ballerina-app ./helm/ballerina-app
    ```

### 3. Access Prometheus and Grafana

- **Prometheus**: You can access it via port forwarding:

    ```bash
    kubectl port-forward svc/prometheus-operated 9090:9090
    ```

    Then, open [http://localhost:9090](http://localhost:9090) in your browser.

- **Grafana**: You can access it via port forwarding:

    ```bash
    kubectl port-forward svc/grafana 3000:80
    ```

    Then open [http://localhost:3000](http://localhost:3000) in your browser.
    The default username and password are `admin/admin`.

### 4. Alerts and Alerting

Prometheus will automatically start tracking your metrics. If the latency crosses a threshold or if your application goes down, AlertManager will send a notification based on the configured alerting rules.

To set up email notifications, modify `monitoring/alertmanager-config.yaml` file with your SMTP details.

### 5. Health Endpoint

TheAdditional Configurationsxposes a health endpoint at port 8081. You can check the application status using:

```bash
curl http://<your-k8s-service-ip>:8081/healthz
```

If everything is working correctly, you should see the response: `"OK"`

## Additional Configurations

If you wish to add more metrics or modify the existing ones, feel free to update the Ballerina code in `ballerina-app/main.bal` and the Helm chart configuration.

