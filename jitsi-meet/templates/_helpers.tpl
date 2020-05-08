{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jitsi-meet.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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
Create the web server name
*/}}
{{- define "jitsi-meet.name-web" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" $name "web" | trunc 63 -}}
{{- end -}}

{{/*
Create the XMPP server name
*/}}
{{- define "jitsi-meet.name-prosody" -}}
{{- printf "%s-%s" .Chart.Name "prosody" | trunc 63 -}}
{{- end -}}

{{/*
Create the jicofo cmp name
*/}}
{{- define "jitsi-meet.name-jicofo" -}}
{{- printf "%s-%s" .Chart.Name "jicofo" | trunc 63 -}}
{{- end -}}

{{/*
Create the jicofo config name
*/}}
{{- define "jitsi-meet.name-jicofo-config" -}}
{{- printf "%s-%s" .Chart.Name "jicofo-config" | trunc 63 -}}
{{- end -}}

{{/*
Create the jvb server name
*/}}
{{- define "jitsi-meet.name-jvb" -}}
{{- printf "%s-%s" .Chart.Name "jvb" | trunc 63 -}}
{{- end -}}

{{/*
Create the jvb config name
*/}}
{{- define "jitsi-meet.name-jvb-config" -}}
{{- printf "%s-%s" .Chart.Name "jvb-config" | trunc 63 -}}
{{- end -}}

{{/*
Create the sidecar name for jwt auth
*/}}
{{- define "jitsi-meet.name-jwt-sidecar" -}}
{{- printf "%s-%s" .Chart.Name "jwt" | trunc 63 -}}
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