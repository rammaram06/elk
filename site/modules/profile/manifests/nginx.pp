class profile::nginx (
  Hash $firewall_multis,
  String $backend_host,
  Integer $backend_port,
  Integer[30000] $uid,
  Integer[30000] $gid,
) {
  create_resources('firewall_multi', $firewall_multis)

  include nginx
  group { 'nginx':
    ensure => present,
    gid    => $gid,
  }
  user { 'nginx':
    ensure     => present,
    uid        => $uid,
    gid        => $gid,
    comment    => 'nginx user',
    home       => '/var/cache/nginx',
    shell      => '/sbin/nologin',
    managehome => false,
  }
  nginx::resource::vhost { $::fqdn:
    proxy => "http://$backend_host:$backend_port",
  }
  User['nginx'] -> Package['nginx']
}
