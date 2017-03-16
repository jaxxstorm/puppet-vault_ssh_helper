# == Class vault_ssh_helper::install
#
# Installs vault_ssh_helper based on the parameters from init
#
class vault_ssh_helper::install {

  $install_prefix = '/opt/vault-ssh-helper'
  $install_path = pick($::vault_ssh_helper::archive_path, "${install_prefix}/archives")

  case $::vault_ssh_helper::install_method {
    'url': {
      include '::archive'
      file {[
        $install_path,
        "${install_path}/vault-ssh-helper-${vault_ssh_helper::version}"]:
          ensure => directory,
          owner  => 'root',
          group  => '0',
          mode   => '0555',
      }->
      archive { "${install_path}/vault-ssh-helper-${vault_ssh_helper::version}.${vault_ssh_helper::download_extension}":
        ensure       => present,
        source       => $::vault_ssh_helper::real_download_url,
        extract      => true,
        extract_path => "${install_path}/vault-ssh-helper-${vault_ssh_helper::version}",
        creates      => "${install_path}/vault-ssh-helper-${vault_ssh_helper::version}/vault-ssh-helper",
      } ->
      file {
        "${install_path}/vault-ssh-helper-${vault_ssh_helper::version}/vault-ssh-helper":
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        "${vault_ssh_helper::bin_dir}/vault-ssh-helper":
          ensure => link,
          target => "${install_path}/vault-ssh-helper-${vault_ssh_helper::version}/vault-ssh-helper";
      }
    }
    'package': {
      package { $::vault_ssh_helper::package_name:
        ensure => $::vault_ssh_helper::package_ensure,
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${vault_ssh_helper::install_method} is invalid")
    }
  }
}



