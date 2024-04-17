locals {
  redpanda_name             = "redpanda"
  redpanda_repo             = "https://charts.redpanda.com"
  redpanda_version          = "5.7.22"
}

resource "helm_release" "redpanda" {
  count = var.enable_redpanda ? 1 : 0

  name                       = try(var.redpanda_helm_config["name"], local.redpanda_name)
  repository                 = try(var.redpanda_helm_config["repository"], local.redpanda_repo)
  chart                      = try(var.redpanda_helm_config["chart"], "redpanda")
  version                    = try(var.redpanda_helm_config["version"], local.redpanda_version)
  timeout                    = try(var.redpanda_helm_config["timeout"], 300)
  values                     = try(var.redpanda_helm_config["values"], null)
  create_namespace           = try(var.redpanda_helm_config["create_namespace"], true)
  namespace                  = try(var.redpanda_helm_config["namespace"], local.redpanda_name)
  lint                       = try(var.redpanda_helm_config["lint"], false)
  description                = try(var.redpanda_helm_config["description"], "")
  repository_key_file        = try(var.redpanda_helm_config["repository_key_file"], "")
  repository_cert_file       = try(var.redpanda_helm_config["repository_cert_file"], "")
  repository_username        = try(var.redpanda_helm_config["repository_username"], "")
  repository_password        = try(var.redpanda_helm_config["repository_password"], "")
  verify                     = try(var.redpanda_helm_config["verify"], false)
  keyring                    = try(var.redpanda_helm_config["keyring"], "")
  disable_webhooks           = try(var.redpanda_helm_config["disable_webhooks"], false)
  reuse_values               = try(var.redpanda_helm_config["reuse_values"], false)
  reset_values               = try(var.redpanda_helm_config["reset_values"], false)
  force_update               = try(var.redpanda_helm_config["force_update"], false)
  recreate_pods              = try(var.redpanda_helm_config["recreate_pods"], false)
  cleanup_on_fail            = try(var.redpanda_helm_config["cleanup_on_fail"], false)
  max_history                = try(var.redpanda_helm_config["max_history"], 0)
  atomic                     = try(var.redpanda_helm_config["atomic"], false)
  skip_crds                  = try(var.redpanda_helm_config["skip_crds"], false)
  render_subchart_notes      = try(var.redpanda_helm_config["render_subchart_notes"], true)
  disable_openapi_validation = try(var.redpanda_helm_config["disable_openapi_validation"], false)
  wait                       = try(var.airflow_helm_config["wait"], false) # This is critical setting. Check this issue -> https://github.com/hashicorp/terraform-provider-helm/issues/683
  wait_for_jobs              = try(var.redpanda_helm_config["wait_for_jobs"], false)
  dependency_update          = try(var.redpanda_helm_config["dependency_update"], false)
  replace                    = try(var.redpanda_helm_config["replace"], false)

  postrender {
    binary_path = try(var.redpanda_helm_config["postrender"], "")
  }

  dynamic "set" {
    iterator = each_item
    for_each = try(var.redpanda_helm_config["set"], [])

    content {
      name  = each_item.value.name
      value = each_item.value.value
      type  = try(each_item.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    iterator = each_item
    for_each = try(var.redpanda_helm_config["set_sensitive"], [])

    content {
      name  = each_item.value.name
      value = each_item.value.value
      type  = try(each_item.value.type, null)
    }
  }

}
