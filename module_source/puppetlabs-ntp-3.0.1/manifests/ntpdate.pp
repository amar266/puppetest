class ntp::ntpdate (
   $ntp_servers = ['c1','c3'],
   $duration = 5
)
{
   $ntp_srvs = join($ntp_servers," ")

   package { 'ntpdate':
	ensure 	=> latest,
	name 	=> 'ntpdate',
   }

   package { 'ntp':
	ensure 	=> purged,
   }
   exec { 'exec_ntpdate':
	path    => "/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin",
	command => "ntpdate -u $ntp_srvs",
  }

## Default cron use user level cronjobs, rather we should use /etc/cron.d/. 
## So not setting cron job right now. will be added later - harish
#   cron { 'ntpdate':
#    ensure  => $ensure,
#    command => "/usr/sbin/ntpdate -u $ntp_srvs ",
#    user    => 'root',
#    minute  => $duration,
#    require => Package['ntpdate'],
#  }
   
}
