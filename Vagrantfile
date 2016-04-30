# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
apt-get update &> /dev/null
apt-get install -y build-essential git ruby ruby-dev &> /dev/null
gem install --no-rdoc --no-ri bundler jekyll rake redcarpet travis &> /dev/null
apt-get install -y nodejs &> /dev/null
ln -fs /usr/bin/nodejs /usr/bin/node
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-15.04"

  config.vm.network "forwarded_port", guest: 4000, host: 4000

  config.vm.provision "shell", inline: $script
end
