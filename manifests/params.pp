# == Class vault_ssh_helper::params
#
# This class is meant to be called from vault_ssh_helper
# It sets variables according to platform
#
class vault_ssh_helper::params {


  $bin_dir                = '/usr/local/bin'
  $archive_path           = ''
  $config_dir             = '/etc/vault-ssh-helper.d'
  $config_hash            = {}
  $config_mode            = '0660'
  $download_extension     = 'zip'
  $download_url           = undef
  $download_url_base      = 'https://releases.hashicorp.com/vault-ssh-helper/'
  $log_dir                = '/var/log/vault-ssh-helper'
  $install_method         = 'url'
  $package_ensure         = 'latest'
  $package_name           = 'vault-ssh-helper'
  $pretty_config          = true
  $pretty_config_indent   = 4
  $purge_config_dir       = true
  $version                = '0.1.3'


  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    /^arm.*/:          { $arch = 'arm'   }
    default:           {
      fail("Unsupported kernel architecture: ${::architecture}")
    }
  }

  $os = downcase($::kernel)
}
