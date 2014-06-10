class tfile {
	file { '/tmp/testsanjayu.txt':
		ensure => present,
		source => 'puppet:///modules/tfile/ftemplate.txt'
	}
}

