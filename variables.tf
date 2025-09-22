variable "cluster_name" {
  type        = string
  description = "The name of the Kubernetes cluster to configure (used for kubectl context)"
}

variable "config_path" {
  type        = string
  description = "The path to the kubeconfig file to use for kubectl commands"
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "A prefix to add to the name of the Istio Helm releases"
}

variable "chart_version" {
  type        = string
  default     = "1.27.1"
  description = "The version of the Istio Helm charts to install"
}

variable "istio_system_namespace" {
  type        = string
  default     = "istio-system"
  description = "The Kubernetes namespace to install Istio components into"
}

variable "gateway_api_version" {
  type        = string
  default     = "1.3.0"
  description = "The version of the Kubernetes Gateway API to install"
}

variable "istio_mode" {
  type        = string
  default     = "ambient"
  description = "Istio installation mode, see https://github.com/istio/istio/tree/master/manifests/profiles"
}
