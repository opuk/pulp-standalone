exec { "Fetch pulp repo file":
  command => "/usr/bin/curl https://repos.fedorapeople.org/repos/pulp/pulp/rhel-pulp.repo > /etc/yum.repos.d/rhel-pulp.repo",
  creates => "/etc/yum.repos.d/rhel-pulp.repo"
}

exec { "Enable EPEL":
  command => "/usr/bin/rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm",
  creates => "/etc/yum.repos.d/epel.repo"
}

#python-blinker is retired in epel7
exec { "Enable copr python-blinker":
  command => "/usr/bin/curl http://copr.fedoraproject.org/coprs/opuk/python-blinker/repo/epel-7/opuk-python-blinker-epel-7.repo > /etc/yum.repos.d/opuk-python-blinker-epel-7.repo",
  creates => "/etc/yum.repos.d/opuk-python-blinker-epel-7.repo"
}

package { "mongodb-server": ensure => present, require => Exec["Enable EPEL"] } 

service { "mongod":
  ensure  => running,
  enable => true,
  require => Package["mongodb-server"],
}

package { "qpid-cpp-server": ensure => present, require => [ Exec["Enable EPEL"], Exec["Fetch pulp repo file"] ]} 
package { "qpid-cpp-server-store": ensure => present, require => [ Exec["Enable EPEL"], Exec["Fetch pulp repo file"] ]} 

service { "qpidd":
  ensure  => running,
  enable => true,
  require => [ Package["qpid-cpp-server-store"], Package["qpid-cpp-server"] ]
}

yumgroup { "pulp-server-qpid": ensure => present, require =>  [ Exec["Enable EPEL"], 
                                      Exec["Fetch pulp repo file" ], Service["qpidd"]] } 
package { "qpid-tools": ensure => present, require =>  [ Exec["Enable EPEL"], Exec["Fetch pulp repo file" ] ] } 
yumgroup { "pulp-admin": ensure => present, require =>  [ Exec["Enable EPEL"], Exec["Fetch pulp repo file" ] ] } 


exec { "pulp-manage-db":
  command => "/usr/bin/pulp-manage-db && /usr/bin/touch /var/lib/pulp/.puppetinit",
  user     => apache,
  creates  => "/var/lib/pulp/.puppetinit",
  require  => [ Yumgroup["pulp-admin"], Package["qpid-tools"], Yumgroup["pulp-server-qpid"] ],
}

service { "pulp_workers":
  ensure  => running,
  enable => true,
  require => Exec["pulp-manage-db"]
}

service { "pulp_celerybeat":
  ensure  => running,
  enable => true,
  require => Exec["pulp-manage-db"]
}

service { "pulp_resource_manager":
  ensure  => running,
  enable => true,
  require => Exec["pulp-manage-db"]
}

service { 'httpd':
  ensure => running,
  enable => true,
  require => Yumgroup["pulp-server-qpid"],
}
