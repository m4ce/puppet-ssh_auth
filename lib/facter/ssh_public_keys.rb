ssh_public_keys = {}
Etc.passwd do |pw|
  user = pw.name
  homedir = pw.dir
  key = false

  if File.directory?(homedir + "/.ssh")
    Dir[homedir + "/.ssh/id_*.pub"].each do |file|
      key = IO.read(file)

      if key
        type, id, comment = key.split
        ssh_public_keys[comment] = {
          "type" => type,
          "key" => id
        }
      end
    end
  end
end

unless ssh_public_keys.empty?
  Facter.add("ssh_public_keys") do
    setcode do
      ssh_public_keys
    end
  end
end
