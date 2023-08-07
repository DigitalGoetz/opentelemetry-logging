# OpenTelemetry Logging

```bash
bash scripts/setup-basics.sh # if you're running with a local k8s; otherwise skip
bash scripts/deploy.sh
kubectl port-forward service/grafana 8080:80 -n opentelemetry
```

In a browser, access grafana (http://localhost:8080) using the below credentials:

* Username: admin
* Password: <in grafana.pass (generated file)> <or obtain from secret>

The Loki data source should be automatically provisioned, but the dashboard for viewing logs needs to be imported from grafana labs using the following Dashboard ID.

Dashboard ID: 15141  <if you have access to the internet> otherwise, copy the contents of ./dashboards/model.json.template and replace all instances of >LOKI_UID< with the datasource uid, then paste into dashboard JSON textfield.