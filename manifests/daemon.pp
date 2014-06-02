class sauceconnect::daemon($username, $apikey) {
  $logdir = '/var/log/sauce'

  file {
    $logdir :
      ensure => directory;

    '/etc/default/sauce-connect' :
      ensure  => present,
      content => "
SAUCE_CONNECT=/usr/share/sauce/sc
SAUCE_CONNECT_ARGS=\"--user ${username} --api-key $apikey --logfile ${logdir}/sauce-connect.log\"
API_USER=${username}
API_KEY=${apikey}
USERNAME=
GROUP=
LOG_DIR=${logdir}
LOG_FILE=${logdir}/sc.log
";

    '/etc/init.d/sauce-connect' :
      ensure => 'present',
      mode   => 0755,
      notify => Service['sauce-connect'],
      source => "puppet:///modules/sauceconnect/sauce-connect.${::osfamily}.init";
  }

  service {
    'sauce-connect' :
      ensure     => running,
      hasrestart => true,
      hasstatus  => true;
  }
}
