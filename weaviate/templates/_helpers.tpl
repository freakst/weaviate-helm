{{/* Generate the enabled modules config. This can be done a lot nicer once we drop Helm v2 support */}}
{{ define "enabled_modules" }}
  {{- $modules := list -}}
  {{- if or (index .Values "modules" "text2vec-contextionary" "enabled") (index .Values "modules" "text2vec-contextionary" "inferenceUrl") -}}
    {{ $modules = append $modules "text2vec-contextionary" }}
  {{- end -}}
  {{- if or (index .Values "modules" "text2vec-transformers" "enabled") (index .Values "modules" "text2vec-transformers" "inferenceUrl") -}}
    {{ $modules = append $modules "text2vec-transformers" }}
  {{- end -}}
  {{- if or (index .Values "modules" "qna-transformers" "enabled") (index .Values "modules" "qna-transformers" "inferenceUrl") -}}
    {{ $modules = append $modules "qna-transformers" }}
  {{- end -}}
  {{- if or (index .Values "modules" "img2vec-neural" "enabled") (index .Values "modules" "img2vec-neural" "inferenceUrl") -}}
    {{ $modules = append $modules "img2vec-neural" }}
  {{- end -}}
  {{- if or (index .Values "modules" "ner-transformers" "enabled") (index .Values "modules" "ner-transformers" "inferenceUrl") -}}
    {{ $modules = append $modules "ner-transformers" }}
  {{- end -}}
  {{- if or (index .Values "modules" "text-spellcheck" "enabled") (index .Values "modules" "text-spellcheck" "inferenceUrl") -}}
    {{ $modules = append $modules "text-spellcheck" }}
  {{- end -}}
  {{- if or (index .Values "modules" "multi2vec-clip" "enabled") (index .Values "modules" "multi2vec-clip" "inferenceUrl") -}}
    {{ $modules = append $modules "multi2vec-clip" }}
  {{- end -}}
  {{- if (index .Values "modules" "text2vec-openai" "enabled") -}}
    {{ $modules = append $modules "text2vec-openai" }}
  {{- end -}}
  {{- if gt (len $modules) 0 -}}
          - name: ENABLE_MODULES
            value: {{ join "," $modules }}
  {{- end -}}
{{- end -}}

{{- define "weaviate.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "weaviate.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "weaviate.fullname" -}}
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

{{/*
Common labels
*/}}
{{- define "weaviate.labels" -}}
helm.sh/chart: {{ include "weaviate.chart" . }}
{{ include "weaviate.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "weaviate.selectorLabels" -}}
app.kubernetes.io/name: {{ include "weaviate.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
