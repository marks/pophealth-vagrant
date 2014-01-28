# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrant.require_plugin 'vagrant-berkshelf'
Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.berkshelf.enabled = false
  config.vm.hostname = "pophealthinstance"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "10.0.10.10"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "apt"
    chef.add_recipe "git"
    chef.add_recipe "build-essential"
    chef.add_recipe "mongodb::10gen_repo"
    chef.add_recipe "mongodb"
    chef.add_recipe "pophealth::prep"
    chef.add_recipe "rvm::user"
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "pophealth"
    chef.json = {
      "pophealth" => {
        "nlm_username" => "NLMUSERNAME",
        "nlm_password" => "NLMPASSWORD",
      },
      "rvm" => {
        'rvm_gem_options' => "--rdoc --ri",
        "user_installs" => [{
          'user' => 'vagrant',
          'default_ruby'    => 'ruby-2.0.0',
          'rubies' => [
            "ruby-2.0.0"
          ]
        }]
      }
    }
  end

end
