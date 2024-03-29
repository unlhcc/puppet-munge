# Class: munge
# ===========================
#
# Note that munge_key should be provided via hiera as base64 encoded
#
class munge (
    $package_ensure     = 'present',
    $service_ensure     = 'running',
    $service_enable     = true,
    $munge_key          = undef,
) {

    package { 'munge':
        ensure => $::munge::package_ensure,
    }

    service { 'munge':
        ensure     => $::munge::service_ensure,
        enable     => $::munge::service_enable,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['munge'],
        subscribe  => File['munge.key'],
    }

    file { 'munge.key':
        ensure  => present,
        name    => '/etc/munge/munge.key',
        mode    => '0400',
        owner   => 'munge',
        group   => 'munge',
        require => Package['munge'],
        notify  => Service['munge'],
        content => Sensitive(Binary($::munge::munge_key)),
        #                    ^- This does b64 decode
    }

}
