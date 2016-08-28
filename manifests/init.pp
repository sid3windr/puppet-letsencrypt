class letsencrypt (
  $owner = 'root',
  $group = 'root',
  $dmode = 0755,
) {
  file {
    '/etc/letsencrypt/live':
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $dmode;
    '/etc/letsencrypt':
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $dmode;
  }
}

define letsencrypt::certificate (
  $ensure = present,
  $notify = [],
  $owner = 'root',
  $group = 'root',
  $fmode = 0644,
  $dmode = 0755,
) {
  file {
    "/etc/letsencrypt/live/${name}":
      ensure => $ensure ? {
        'present' => 'directory',
        default   => 'absent',
      },
      owner  => $owner,
      group  => $group,
      mode   => $dmode;
    "/etc/letsencrypt/live/${name}/fullchain.pem":
      ensure => $ensure,
      owner  => $owner,
      group  => $group,
      mode   => $fmode,
      notify => $notify,
      source => "puppet:///modules/letsencrypt/${name}/fullchain.pem";
    "/etc/letsencrypt/live/${name}/privkey.pem":
      ensure => $ensure,
      owner  => $owner,
      group  => $group,
      mode   => $fmode,
      notify => $notify,
      source => "puppet:///modules/letsencrypt/${name}/privkey.pem";
    "/etc/letsencrypt/live/${name}/cert.pem":
      ensure => $ensure,
      owner  => $owner,
      group  => $group,
      mode   => $fmode,
      notify => $notify,
      source => "puppet:///modules/letsencrypt/${name}/cert.pem";
  }
}
