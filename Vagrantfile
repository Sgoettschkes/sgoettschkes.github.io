# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
apt-get update &> /dev/null
apt-get install -y ruby ruby-dev &> /dev/null
gem install --no-rdoc --no-ri bundler jekyll rake redcarpet travis &> /dev/null
export DEBIAN_FRONTEND=noninteractive; apt-get install -t jessie -y nodejs &> /dev/null
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "Sgoettschkes/debian7-ansible"

  config.vm.network "forwarded_port", guest: 4000, host: 4000

  # install jekyll and dependencies
  config.vm.provision "shell", inline: $script
end
