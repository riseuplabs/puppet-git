define git::web::repo::lighttpd(
  $ensure = 'present',
  $gitweb_url,
  $gitweb_config
){
  if $ensure == 'present' { include git::web::lighttpd }
  file{"/etc/lighttpd/gitweb.d/${name}.conf": }
  if $ensure == 'present' {
    File["/etc/lighttpd/gitweb.d/${name}.conf"]{
     content => template("git/web/lighttpd"),
     owner => root, group => 0, mode => 0644
    }
  } else {
    File["/etc/lighttpd/gitweb.d/${name}.conf"]{
      ensure => $ensure,
    }
  }
  line{"include_of_gitwebrepo_${name}":
    ensure => $ensure,
    line => "include \"gitweb.d/${name}.conf\"",
    file => "/etc/lighttpd/lighttpd-gitweb.conf",
  }
  if defined(Service['lighttpd']) {
    File["/etc/lighttpd/gitweb.d/${name}.conf"]{
      notify => Service['lighttpd'],
    }
    Line["include_of_gitwebrepo_${name}"]{
      notify => Service['lighttpd'],
    }
  }
  if defined(File['/etc/lighttpd/lighttpd-gitweb.conf']){
    Line["include_of_gitwebrepo_${name}"]{
      require => File['/etc/lighttpd/lighttpd-gitweb.conf'],
    }
  }
}
