class horizon(
  $secret_key,
  $fqdn                    = $::fqdn,
  $package_ensure          = 'present',
  $cache_server_ip         = undef,
  $cache_server_port       = '11211',
  $swift                   = false,
  $horizon_app_links       = false,
  $keystone_url            = 'http://127.0.0.1:5000/v2.0',
  $keystone_default_role   = '_member_',
  $django_debug            = 'False',
  $openstack_endpoint_type = undef,
  $secondary_endpoint_type = undef,
  $api_result_limit        = 1000,
  $log_level               = 'DEBUG',
  $can_set_mount_point     = 'True',
  $help_url                = 'http://docs.openstack.org',
  $local_settings_template = 'horizon/local_settings.py.erb',
  $configure_apache        = false,  ##FIXME: WORKROUND FOR ssl, it is true
  $bind_address            = '0.0.0.0',
  $listen_ssl              = false,
  $horizon_cert            = undef,
  $horizon_key             = undef,
  $horizon_ca              = undef,
  $compress_offline        = 'True',
  # DEPRECATED PARAMETERS
  $keystone_host           = undef,
  $keystone_port           = undef,
  $keystone_scheme         = undef,
  $regservice_url          = undef,
) {

  include ::horizon::params

  if $swift {
    warning('swift parameter is deprecated and has no effect.')
  }

  if $keystone_scheme {
    warning('The keystone_scheme parameter is deprecated, use keystone_url instead.')
  }

  if $keystone_host {
    warning('The keystone_host parameter is deprecated, use keystone_url instead.')
  }

  if $keystone_port {
    warning('The keystone_port parameter is deprecated, use keystone_url instead.')
  }

  Service <| title == 'memcached' |> -> Class['horizon']

  package { $::horizon::params::package_name:
    ensure  => $package_ensure,
    #name    => $::horizon::params::package_name,
  }



  file { $::horizon::params::config_file:
    content => template($local_settings_template),
    mode    => '0644',
#    require => Package['horizon'],
  }

  if $configure_apache {
    class { 'horizon::wsgi::apache':
      bind_address => $bind_address,
      listen_ssl   => $listen_ssl,
      horizon_cert => $horizon_cert,
      horizon_key  => $horizon_key,
      horizon_ca   => $horizon_ca,
    }
  }
}
