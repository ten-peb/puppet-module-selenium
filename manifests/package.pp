# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include selenium::package
class selenium::package {
  include tenna::config
  include tenna::deps::compression::unzip
  include tenna::deps::libs::xvfb
  include tenna::deps::libs::libxi6
  include tenna::deps::libs::libconf
  # wget https://selenium-release.storage.googleapis.com/3.13/selenium-server-standalone-3.13.0.jar
  $version='3.13'      # parameterize
  $selenium_site = 'https://selenium-release.storage.googleapis.com'
  $jarfile = "selenium-server-standaline-${version}.0.jar"
  $url_path = "${selenium_site}/${version}/${jarfile}"
  $cmd = "wget ${url_path}"

  exec{'download selenium server':
    command => $cmd,
    cwd     => '/usr/local/bin',
    path    => '/bin:/usr/bin',
    require => [
      Package[$tenna::config::libconf],
      Package['unzip'],
      Package['xvfb'],
      Package['libxi6']
    ],
    onlyif => "test ! -f ${jarfile}"
  }

  $testjar_version='6.8.7'
  $testjar_zipfile= "testng-${testjar_version}.jar.zip"
  $testjar        = "/usr/local/bin/testng-${testjar_version}.jar"
  $tjsite         = 'http://www.java2s.com/Code/JarDownload/testng'
  $tjcmd          = "wget ${tjsite}/${testjar_zipfile}"

  exec {'download testng jar':
    command => $tjcmd,
    cwd     => '/tmp',
    path    => '/bin:/usr/bin',
    onlyif  => "test ! -f ${testjar}",
    notify  => Exec['unzip testing jar']
  }

  exec {'unzip testng jar':
    cmd         => "unzip /tmp/${testjar_zipfile}",
    path        => '/bin:/usr/bin',
    cwd         => '/usr/local/bin',
    refreshonly => true
  }
    
}
