# Puppet SSH auth module (ext_ssh_authorized_key)

This puppet module allows to easily manage your SSH pubic keys distribution across your Infrastructure.

It has several <b>advantages</b> compared to the original ssh_authorized_key which comes with Puppet.

1. allows to distribute the same key to multiple users on the same node. The original ssh_authorized_key treats the comment as the resource namevar, hence if you need to distribute the same key to two different users on the same machine, it will error out saying that the resource already exists
2. ssh public keys are stored in hiera
3. optionally look up ssh_public_keys node fact from PuppetDB

## Usage
The module is quite simple per se. You would only need to use the defined type ssh::authorized_key to roll out your keys.

```
ssh::authorized_key {"user1:bar@example.org": }
ssh::authorized_key {"user2:bar@example.org": }
```

The title is a composite namevar made of:
```
<target_user>:<ssh_key_comment>
```

Should you want to use ext_ssh_authorized_key directly, you would write it like this:
```
ext_ssh_authorized_key {"user1:ssh-dss:bar@example.org":
  key => "<user_key>",
  ensure => "present" # default in any case
}
```

## Contact
Matteo Cerutti - matteo.cerutti@hotmail.co.uk
