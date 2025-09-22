locals {
  istio_chart_repository = "https://istio-release.storage.googleapis.com/charts"
  istio_base_chart       = "base"
  istio_istiod_chart     = "istiod"
}

resource "helm_release" "istio_base" {
  name       = var.name_prefix != "" ? "${var.name_prefix}-istio-base" : "istio-base"
  chart      = local.istio_base_chart
  repository = local.istio_chart_repository
  version    = var.chart_version
  namespace  = var.istio_system_namespace
  wait       = true
}

resource "null_resource" "install_gateway_api_crds" {
  # 使用 triggers 來控制何時重新執行
  triggers = {
    gateway_api_version = "v${var.gateway_api_version}" # 當版本變更時重新執行
    cluster_name        = var.cluster_name              # 當 cluster 變更時重新執行
    config_path         = var.config_path
  }

  provisioner "local-exec" {
    command = <<-EOT
      # 設定 kubeconfig 和 cluster context
      kubectl config set-cluster ${var.cluster_name} --kubeconfig ${var.config_path}
      kubectl config use-context ${var.cluster_name} --kubeconfig ${var.config_path}

      # 檢查 Gateway API CRDs 是否已存在
      if ! kubectl --kubeconfig=${var.config_path} get crd gateways.gateway.networking.k8s.io &> /dev/null; then
        echo "Installing Kubernetes Gateway API CRDs..."
        kubectl --kubeconfig=${var.config_path} apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v${var.gateway_api_version}/standard-install.yaml
      else
        echo "Gateway API CRDs already exist, checking for updates..."
        kubectl --kubeconfig=${var.config_path} apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v${var.gateway_api_version}/standard-install.yaml
      fi
    EOT
  }

  # 可選：當資源被銷毀時的清理操作
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kubectl config use-context <CLUSTER_NAME> --kubeconfig <KUBECONFIG_PATH>
      echo "Note: Gateway API CRDs are not automatically removed to prevent data loss"
      echo "If you want to remove them manually, run:"
      echo "kubectl --kubeconfig <KUBECONFIG_PATH> delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/<GATEWAY_API_VERSION>/standard-install.yaml"
    EOT
  }

  # 依賴 istio-base 完成安裝
  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istiod" {
  name       = var.name_prefix != "" ? "${var.name_prefix}-istiod" : "istiod"
  chart      = local.istio_istiod_chart
  repository = local.istio_chart_repository
  version    = var.chart_version
  namespace  = var.istio_system_namespace
  wait       = true

  set {
    name  = "profile"
    value = var.istio_mode
  }

  depends_on = [null_resource.install_gateway_api_crds]
}

resource "helm_release" "istio_cni" {
  name       = var.name_prefix != "" ? "${var.name_prefix}-cni" : "cni"
  chart      = "cni"
  repository = local.istio_chart_repository
  version    = var.chart_version
  namespace  = var.istio_system_namespace
  wait       = true

  set {
    name  = "profile"
    value = var.istio_mode
  }

  depends_on = [helm_release.istiod]
}

resource "helm_release" "istio_ztunnel" {
  name       = var.name_prefix != "" ? "${var.name_prefix}-ztunnel" : "ztunnel"
  chart      = "ztunnel"
  repository = local.istio_chart_repository
  version    = var.chart_version
  namespace  = var.istio_system_namespace
  wait       = true

  depends_on = [helm_release.istio_cni]
}

resource "helm_release" "istio_gateway" {
  name       = var.name_prefix != "" ? "${var.name_prefix}-gateway" : "gateway"
  chart      = "gateway"
  repository = local.istio_chart_repository
  version    = var.chart_version
  namespace  = var.istio_system_namespace
  wait       = true

  depends_on = [helm_release.istio_cni]
}
