resource "harbor_robot_account" "infra-bot" {
  name        = "infra-bot"
  description = "system level robot account"
  level       = "system"
  permissions {
    access {
      action   = "create"
      resource = "label"
    }
    kind      = "system"
    namespace = "/"
  }
  permissions {
    access {
      action   = "push"
      resource = "repository"
    }
    kind      = "project"
    namespace = "*"
  }
  permissions {
    access {
      action   = "pull"
      resource = "repository"
    }
    kind      = "project"
    namespace = "*"
  }
}
