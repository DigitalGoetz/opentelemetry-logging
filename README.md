# OpenTelemetry Logging

```bash
bash scripts/initialize.sh
kubectl port-forward service/grafana 8080:80 -n grafana
```

In a browser, access grafana (http://localhost:8080) using the below credentials:

* Username: admin
* Password: <in grafana.pass (generated file)>

The Loki data source should be automatically provisioned, but the dashboard for viewing logs needs to be imported from grafana labs using the following Dashboard ID.

Dashboard ID: 15141