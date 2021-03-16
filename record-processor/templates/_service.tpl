{{- define "common.servicetemplate" }}

apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name }}
  namespace: k8s-namespace
  labels:
    app: {{ .Values.service.name }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
spec:
  type: {{ .Values.global.service.type }}
  ports:
    - port: {{ .Values.global.service.externalPort }}
      targetPort: {{ .Values.global.service.internalPort }}
      protocol: TCP
      name: {{ .Values.service.name }}
  selector:
    app: {{ .Values.service.name }}

{{- end }}
