### Setting up openstack
class openstack_setup inherits os_env { 
  $hostname_lc    	= downcase($hostname)
    



    include ::apache
    include ::apache::mod::wsgi
    include apache::mod::rewrite
    include apache::mod::ssl
    include apache::mod::proxy
    include apache::mod::proxy_http
## this is required to proxy novncproxy

  file { '/etc/apache2/conf.d/horizon.conf':
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    content => template("${puppet_master_files}/apache2/horizon.conf.erb"),
    mode    => '0644',
    notify  => Service['httpd'],
  }
 
  file { '/etc/apache2/conf.d/jiocloud-registration-service.conf':
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    content => template("${puppet_master_files}/apache2/jiocloud-registration-service.conf"),
    mode    => '0644',
    notify  => Service['httpd'],
  }

   
  file { '/etc/apache2/certs':
	ensure	=> directory,
	owner   => www-data,
    	group   => www-data,
  }

  if  $ssl_cert_file_source != undef {
    file { $ssl_cert_file:
        ensure        => file,
        owner         => www-data,
        group         => www-data,
        mode          => 640,
        source        => $ssl_cert_file_source,
	notify  => Service['httpd'],
    }
  }


  if  $ssl_key_file_source != undef {
    file { $ssl_key_file:
        ensure        => file,
        owner         => www-data,
        group         => www-data,
        mode          => 640,
        source        => $ssl_key_file_source,
	notify  => Service['httpd'],
    }
  }

  if  $ssl_ca_file_source != undef {
    file { $ssl_ca_file:
        ensure          => file,
        owner           => www-data,
        group           => www-data,
        mode            => 640,
        source          => $ssl_ca_file_source,
	notify  => Service['httpd'],
    }
  }

  file {'/var/log/horizon':
     ensure 	=> directory,
     owner 	=> horizon,
     group	=> horizon,
     mode	=> '0755',
     notify  => Service['httpd'],
  }

 
  class { '::horizon':
#    cache_server_ip     => $horizon_cache_server_ip,
#    cache_server_port   => $horizon_cache_server_port,
    fqdn		=> $horizon_allowed_fqdn,
    secret_key          => $horizon_secret_key,
    django_debug        => $debug,
    api_result_limit    => $horizon_api_result_limit,
    keystone_url	=> "${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",
    listen_ssl		=> $horizon_ssl_enabled,
    horizon_key		=> $horizon_ssl_key,
    horizon_cert	=> $horizon_ssl_cert,
    horizon_ca		=> $horizon_ssl_cacert,
    regservice_url      => "https://$hostname_lc.jiocloud.com/horizonreg" 
  }


} 
