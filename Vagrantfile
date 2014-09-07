# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'
require 'open-uri'
require 'yaml'

Vagrant.require_version ">= 1.6.0"

if File.exists?('user-data') && ARGV[0].eql?('up')
 
  token = open('https://discovery.etcd.io/new').read
 
  data = YAML.load(IO.readlines('user-data')[1..-1].join)
  data['coreos']['etcd']['discovery'] = token
 
  lines = YAML.dump(data).split("\n")
  lines[0] = '#cloud-config'
 
  open('user-data', 'w+') do |f|
    f.puts(lines.join("\n"))
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "coreos-alpha"
  config.vm.box_version = ">= 308.0.1"
  config.vm.box_url = "http://alpha.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json"

  config.vm.provider :virtualbox do |v|
    v.check_guest_additions = false
    v.functional_vboxsf     = false
  end

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  CLOUD_CONFIG_PATH = File.join(File.dirname(__FILE__), "user-data")

  3.times do |i|
    config.vm.define vm_name = "core-#{i+1}"  do |config|
      config.vm.hostname = vm_name

      config.vm.network "forwarded_port", guest: 2375, host: (2375 + i), auto_correct: true

      config.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.memory = 1024
        vb.cpus = 1
      end

      config.vm.network :private_network, ip: "172.17.8.#{i+10}"


      if File.exist?(CLOUD_CONFIG_PATH)
        config.vm.provision :file, :source => "#{CLOUD_CONFIG_PATH}", :destination => "/tmp/vagrantfile-user-data"
        config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
      end
    end
  end
end
