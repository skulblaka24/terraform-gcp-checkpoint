# Palo Alto rule management

terraform {
  required_providers {
    checkpoint = {
      source = "CheckPointSW/checkpoint"
      version = "1.3.0"
    }
  }
}

# Configure the Check Point Provider
provider "checkpoint" {
    server = var.fw_ip
    username = var.username
    password = var.password
    context = "web_api"
}

# Create access rules
resource "checkpoint_management_access_rule" "rule1" {
  layer = "Network"
  name  = "Outgoing traffic from spokes"
  position = {
    top = "top"
  }
  source      = ["demo-tf-Spoke1"]
  destination = ["All_Internet"]
  action      = "Accept"
  track = {
    type = "Log"
  }
}

# Publish
resource "checkpoint_management_publish" "publish" {
  depends_on = [checkpoint_management_access_rule.rule1]
}

resource "checkpoint_management_logout" "logout" {
  depends_on = [checkpoint_management_publish.publish]
}