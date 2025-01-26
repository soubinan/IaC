output "ansible_stdout" {
  value = ansible_playbook.configure_lxc_machine[*].ansible_playbook_stdout
}

output "ansible_stderr" {
  value = ansible_playbook.configure_lxc_machine[*].ansible_playbook_stderr
}

output "ip_addresses" {
  value = var.ip_configs[*].ip
}
