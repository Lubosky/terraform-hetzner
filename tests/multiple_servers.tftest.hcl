variables {
  web_servers_count = 2
}

run "create_servers" {
  command = plan

  assert {
    condition = hcloud_server.web.*.name == ["web-1", "web-2"]
    error_message = "Server name is not correct"
  }

  assert {
    condition = hcloud_load_balancer.web_load_balancer[0].name != null
    error_message = "Load balancer was not created"
  }

  assert {
    condition = can(regex("web-1", data.cloudinit_config.cloud_config_web[0].rendered))
    error_message = "Cloud-init config for web-1 is not correct"
  }

  assert {
    condition = can(regex("web-2", data.cloudinit_config.cloud_config_web[1].rendered))
    error_message = "Cloud-init config for web-2 is not correct"
  }
}
