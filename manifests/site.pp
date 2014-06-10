class { '::horizon':
    fqdn                => "beta.jiocloud.com",
    secret_key          => "1212nn2jjds",
    keystone_url        => "https://identity-beta.jiocloud.com:443/v2.0",
    package_ensure      => "latest"

  }

