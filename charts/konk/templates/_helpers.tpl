{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "konk.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "apiserver.name" -}}
apiserver
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "konk.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "apiserver.fullname" -}}
{{ include "konk.fullname" . }}-{{ include "apiserver.name" . }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "konk.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "konk.labels" -}}
helm.sh/chart: {{ include "konk.chart" . }}
{{ include "konk.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "konk.selectorLabels" -}}
app.kubernetes.io/name: {{ include "konk.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
apiserver labels
*/}}
{{- define "apiserver.labels" -}}
{{ include "konk.labels" . }}
app.kubernetes.io/component: {{ include "apiserver.name" . }}
{{- end }}

{{/*
apiserver Selector labels
*/}}
{{- define "apiserver.selectorLabels" -}}
{{ include "konk.selectorLabels" . }}
app.kubernetes.io/component: {{ include "apiserver.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "konk.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "konk.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
