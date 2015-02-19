define ssh::authorized_key ($options = [], $ensure = "present") {
  validate_re($name, '^\w+:.*?$', "The define name must be in the format of <user>:<comment>")
  validate_array($options)

  unless defined(Class["ssh"]) {
    fail("You must include the ssh base class before using any ssh defined resources")
  }

  unless empty($options) {
    Ext_ssh_authorized_key {
      options => $options
    }
  }

  $array = split($name, ':')
  $user = $array[0]
  $comment = $array[1]

  if has_key($ssh::public_keys, $comment) {
    $type = $ssh::public_keys[$comment]['type']
    $key = $ssh::public_keys[$comment]['key']
  } else {
    $remote = split($comment, '@')
    $remote_host = $remote[1]

    $keys = query_facts("hostname='$remote_host', ['ssh_public_keys']")
    if is_hash($keys) and has_key($keys, $comment) {
      $type = $keys[$comment]['type']
      $key = $keys[$comment]['key']
    } else {
      fail("Failed to look up '$comment' ssh key")
    }
  }

  ext_ssh_authorized_key {"${user}:${type}:${comment}":
    key => $key,
    ensure => $ensure
  }
}
