{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jitsi-meet.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the web server name
*/}}
{{- define "jitsi-meet.name-web" -}}
{{- default .Chart.Name "web" | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the XMPP server name
*/}}
{{- define "jitsi-meet.name-prosody" -}}
{{- default .Chart.Name "prosody" | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the jicofo cmp name
*/}}
{{- define "jitsi-meet.name-jicofo" -}}
{{- default .Chart.Name "jicofo" | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the jicofo config name
*/}}
{{- define "jitsi-meet.name-jicofo-config" -}}
{{- default .Chart.Name "jicofo" "config" | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the jvb server name
*/}}
{{- define "jitsi-meet.name-jvb" -}}
{{- default .Chart.Name "jvb" | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the jvb config name
*/}}
{{- define "jitsi-meet.name-jvb-config" -}}
{{- default .Chart.Name "jvb" "config" | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jitsi-meet.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jitsi-meet.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "jitsi-meet.labels" -}}
app.kubernetes.io/name: {{ include "jitsi-meet.name" . }}
helm.sh/chart: {{ include "jitsi-meet.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jitsi-meet.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "jitsi-meet.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the link URL namespace/service:port for UDP route tables
*/}}
{{- define "jitsi-meet.udp-route-table-entry" -}}
{{- if .Values.jvb.service.udpPort -}}
{{ printf "%d:%s/%s-jvb:%d" .Values.jvb.udpPort .Release.Namespace .Release.Name .Values.jvb.udpPort }}
{{- end }}
{{- if .Values.jvb.service.tcpPort -}}
{{ printf "%d:%s/%s-jvb:%d" .Values.jvb.tcpPort .Release.Namespace .Release.Name .Values.jvb.tcpPort }}
{{- end }}
{{- end -}}

{{/*
Create the link URL namespace/service:port for TCP route tables
*/}}
{{- define "jitsi-meet.tcp-route-table-entry" -}}
{{- if .Values.jvb.service.tcpPort -}}
{{ printf "%d:%s/%s-jvb:%d" .Values.jvb.tcpPort .Release.Namespace .Release.Name .Values.jvb.tcpPort }}
{{- end }}
{{- end -}}