## Requirements

The following requirements are needed by this module:

- <a name="requirement_helm"></a> [helm](#requirement\_helm) (~> 3.0)

## Providers

The following providers are used by this module:

- <a name="provider_helm"></a> [helm](#provider\_helm) (~> 3.0)

- <a name="provider_null"></a> [null](#provider\_null)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.istio_cni](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.istio_gateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.istio_ztunnel](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [null_resource.install_gateway_api_crds](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: The name of the Kubernetes cluster to configure (used for kubectl context)

Type: `string`

### <a name="input_config_path"></a> [config\_path](#input\_config\_path)

Description: The path to the kubeconfig file to use for kubectl commands

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version)

Description: The version of the Istio Helm charts to install

Type: `string`

Default: `"1.27.1"`

### <a name="input_gateway_api_version"></a> [gateway\_api\_version](#input\_gateway\_api\_version)

Description: The version of the Kubernetes Gateway API to install

Type: `string`

Default: `"1.3.0"`

### <a name="input_istio_mode"></a> [istio\_mode](#input\_istio\_mode)

Description: Istio installation mode, see https://github.com/istio/istio/tree/master/manifests/profiles

Type: `string`

Default: `"ambient"`

### <a name="input_istio_system_namespace"></a> [istio\_system\_namespace](#input\_istio\_system\_namespace)

Description: The Kubernetes namespace to install Istio components into

Type: `string`

Default: `"istio-system"`

### <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)

Description: A prefix to add to the name of the Istio Helm releases

Type: `string`

Default: `""`

## Outputs

No outputs.
