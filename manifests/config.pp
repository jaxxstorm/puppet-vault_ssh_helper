# == Class vault_ssh_helper::config
#
# This class is called from vault_ssh_helper::init to install the config file.
#
# == Parameters
#
# [*config_hash*]
#   Hash for vault_ssh_helper to be deployed as JSON
#
# [*purge*]
#   Bool. If set will make puppet remove stale config files.
#
class vault_ssh_helper::config(
  $config_hash,
  $purge = true,
) {

  file { $::vault_ssh_helper::log_dir:
    ensure  => 'directory'
  }

  file { $::vault_ssh_helper::config_dir:
    ensure  => 'directory',
    purge   => $purge,
    recurse => $purge,
  } ->
  file { 'vault_ssh_helper config.json':
    ensure  => present,
    path    => "${vault_ssh_helper::config_dir}/config.json",
    mode    => $::vault_ssh_helper::config_mode,
    content => vault_ssh_helper_sorted_json($config_hash, $::vault_ssh_helper::pretty_config, $::vault_ssh_helper::pretty_config_indent),
  }

}
