require 'spec_helper'

describe 'vault_ssh_helper' do

  RSpec.configure do |c|
    c.default_facts = {
      :architecture           => 'x86_64',
      :operatingsystem        => 'Ubuntu',
      :osfamily               => 'Debian',
      :operatingsystemrelease => '10.04',
      :kernel                 => 'Linux',
    }
  end
  Puppet::Util::Log.level = :debug
  Puppet::Util::Log.newdestination(:console)
  # Installation Stuff
  context 'On an unsupported arch' do
    let(:facts) {{ :architecture => 'bogus' }}
    let(:params) {{
      :install_method => 'package'
    }}
    it { expect { should compile }.to raise_error(/Unsupported kernel architecture:/) }
  end

  context 'When not specifying whether to purge config' do
    it { should contain_file('/etc/vault-ssh-helper.d').with(:purge => true,:recurse => true) }
  end

  context 'When passing a non-bool as purge_config_dir' do
    let(:params) {{
      :purge_config_dir => 'hello'
    }}
    it { expect { should compile }.to raise_error(/is not a boolean/) }
  end

  context 'When disable config purging' do
    let(:params) {{
      :purge_config_dir => false
    }}
    it { should contain_class('vault_ssh_helper::config').with(:purge => false) }
  end

  context 'When requesting to install via a package with defaults' do
    let(:params) {{
      :install_method => 'package'
    }}
    it { should contain_package('vault-ssh-helper').with(:ensure => 'latest') }
  end

  context 'When requesting to install via a custom package and version' do
    let(:params) {{
      :install_method => 'package',
      :package_ensure => 'specific_release',
      :package_name   => 'custom_vault-ssh-helper_package'
    }}
    it { should contain_package('custom_vault-ssh-helper_package').with(:ensure => 'specific_release') }
  end

  context "When installing via URL by default" do
    it { should contain_archive('/opt/vault-ssh-helper/archives/vault-ssh-helper-0.1.3.zip').with(:source => 'https://releases.hashicorp.com/vault-ssh-helper/0.1.3/vault-ssh-helper_0.1.3_linux_amd64.zip') }
    it { should contain_file('/opt/vault-ssh-helper/archives').with(:ensure => 'directory') }
    it { should contain_file('/opt/vault-ssh-helper/archives/vault-ssh-helper-0.1.3').with(:ensure => 'directory') }
    it { should contain_file('/usr/local/bin/vault-ssh-helper')}
  end

  context "When installing via URL with a special archive_path" do
    let(:params) {{
      :archive_path   => '/usr/share/puppet-archive',
    }}
    it { should contain_archive('/usr/share/puppet-archive/vault-ssh-helper-0.1.3.zip').with(:source => 'https://releases.hashicorp.com/vault-ssh-helper/0.1.3/vault-ssh-helper_0.1.3_linux_amd64.zip') }
    it { should contain_file('/usr/share/puppet-archive').with(:ensure => 'directory') }
    it { should contain_file('/usr/share/puppet-archive/vault-ssh-helper-0.1.3').with(:ensure => 'directory') }
    it { should contain_file('/usr/local/bin/vault-ssh-helper')}
  end

  context "When installing via URL by with a special version" do
    let(:params) {{
      :version   => '42',
    }}
    it { should contain_archive('/opt/vault-ssh-helper/archives/vault-ssh-helper-42.zip').with(:source => 'https://releases.hashicorp.com/vault-ssh-helper/42/vault-ssh-helper_42_linux_amd64.zip') }
    it { should contain_file('/usr/local/bin/vault-ssh-helper') }
  end

  context "When installing via URL by with a custom url" do
    let(:params) {{
      :download_url   => 'http://myurl',
    }}
    it { should contain_archive('/opt/vault-ssh-helper/archives/vault-ssh-helper-0.1.3.zip').with(:source => 'http://myurl') }
    it { should contain_file('/usr/local/bin/vault-ssh-helper')}
  end


  context 'When requesting to install via a package with defaults' do
    let(:params) {{
      :install_method => 'package'
    }}
    it { should contain_package('vault-ssh-helper').with(:ensure => 'latest') }
  end

  context 'When requesting to not to install' do
    let(:params) {{
      :install_method => 'none'
    }}
    it { should_not contain_package('vault-ssh-helper') }
    it { should_not contain_staging__file('vault-ssh-helper.zip') }
  end

  context 'When pretty config is true' do
    let(:params) {{
      :pretty_config => true,
      :config_hash => {
          'vault_addr' => 'localhost',
          'ssh_mount_point' => 'ssh',
          'allowed_roles' => '*'
      }
    }}
    it { should contain_file('vault_ssh_helper config.json').with_content(/"vault_addr": "localhost"/) }
    it { should contain_file('vault_ssh_helper config.json').with_content(/"ssh_mount_point": "ssh"/) }
    it { should contain_file('vault_ssh_helper config.json').with_content(/"allowed_roles": "*"/) }
  end

  context "Config with custom file mode" do
    let(:params) {{
      :config_mode  => '0600',
    }}
    it { should contain_file('vault_ssh_helper config.json').with(
      :mode  => '0600'
    )}
  end

  context "When installing with default logfile" do
    it { should contain_file('/var/log/vault-ssh-helper').with(:ensure => 'directory')}
  end

  context "With a custom logdir" do
    let(:params) {{
      :log_dir  => '/tmp/dir'
    }}
    it { should contain_file('/tmp/dir').with(:ensure => 'directory')}
  end

end
