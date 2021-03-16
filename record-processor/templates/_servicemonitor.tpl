{{- define "common.servicemonitortemplate" }}

apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    monitoring: {{ .Values.global.monitoring.name }}
    app: {{ .Values.service.name }}
    application: {{ .Values.service.name }}
  name: "{{ .Values.service.name }}-servicemonitor"
  namespace: k8s-namespace
spec:
  endpoints:
    - port: {{ .Values.service.name }}
      interval: 10s
      path: /actuator/prometheus
  namespaceSelector:
    matchNames:
      - k8s-namespace
  podTargetLabels:
    - pod-template-hash
    - application
  selector:
    matchLabels:
      app: {{ .Values.service.name }}

{{- end }}