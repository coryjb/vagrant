# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3306, host: 33066
  config.vm.network "forwarded_port", guest: 27017, host: 27017
  config.vm.network "forwarded_port", guest: 59844, host: 5984

  config.vm.network "private_network", ip: "192.168.33.10"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  config.vm.synced_folder "./www", "/var/www/html", type: "rsync",
    rsync__exclude: [
      "*/.git/",
      "*/app/bootstrap.php.cache",
      "*/app/cache/",
      "*/web/bundles/",
      "*/web/css/",
      "*/web/js/",
      "*/web/build.js",
      "*/app/logs/",
      "*/app/config/parameters.yml",
      "*/vendor/",
      "*/comparison.json"
    ]  

  config.vm.provider "virtualbox" do |vb|
     vb.gui = false
     vb.cpus = 2
     vb.memory = 2048
  end

  config.vm.provision "shell", path: "scripts/provision.sh"

  if Vagrant.has_plugin?("vagrant-gatling-rsync")
      config.gatling.latency = 2.5
  end
end
