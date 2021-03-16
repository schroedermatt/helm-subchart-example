{{- define "common.deploymenttemplate" }}

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.service.name }}
  namespace: k8s-namespace
  labels:
    chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
spec:
  replicas: {{ .Values.hpa.minReplicas }}
  selector:
    matchLabels:
      app: {{ .Values.service.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.service.name }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.global.image.repository }}:{{ .Values.global.image.tag }}"
          imagePullPolicy: {{ .Values.global.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.global.service.internalPort }}
          resources:
            limits:
              cpu: {{ .Values.resources.limits.cpu }}
              memory: {{ .Values.resources.limits.memory }}
            requests:
              cpu: {{ .Values.resources.requests.cpu }}
              memory: {{ .Values.resources.requests.memory }}
          livenessProbe:
            httpGet:
              path: /actuator/health
              port: {{ .Values.global.service.internalPort }}
          readinessProbe:
            httpGet:
              path: /actuator/health
              port: {{ .Values.global.service.internalPort }}
          env:

            # Loop over global env vars

            {{- if .Values.global.envVars }}
              {{- range $key, $value := .Values.global.envVars }}
              {{- if $value.value}}
              - name: {{ $key | quote }}
                value: {{ $value.value | quote }}
                {{- end}}
              {{- end}}
            {{- end }}

            # Loop over subchart env vars

            {{- if .Values.envVars }}
              {{- range $key, $value := .Values.envVars }}
              {{- if $value.value}}
              - name: {{ $key | quote }}
                value: {{ $value.value | quote }}
                {{- end}}
              {{- end}}
            {{- end }}

            # Set common config map vars

{{- end }}
