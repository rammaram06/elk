class profile::elasticsearch::data_node (
  String $datadir,
  Hash $firewall_multis,
  Hash $volume_groups,
  Hash $config,
  Hash $init_defaults,
  Integer[0,1] $vm_swappiness,
) {
  create_resources('firewall_multi', $firewall_multis)
  create_resources('lvm::volume_group', $volume_groups)

  include elasticsearch
  include profile::elasticsearch
  $cluster_name = $config['cluster.name']
  elasticsearch::instance { $cluster_name:
    init_defaults => $init_defaults,
    config        => $config,
    datadir       => $datadir,
  }
  Mount[$datadir] -> File[$datadir]

  Service["elasticsearch-instance-${cluster_name}"]
  ->
  sysctl { 'vm.swappiness': value => $vm_swappiness }
}
