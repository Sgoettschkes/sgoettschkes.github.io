# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
apt-get update &> /dev/null
apt-get install -y ruby ruby-dev &> /dev/null
gem install --no-rdoc --no-ri bundler jekyll rake travis &> /dev/null
export DEBIAN_FRONTEND=noninteractive; apt-get install -t jessie -y nodejs &> /dev/null
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "Sgoettschkes/debian7-ansible"

  config.vm.network "forwarded_port", guest: 4000, host: 4000

  # Put ssh key inside vm
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
  config.vm.provision "shell", inline: "chmod 0600 /home/vagrant/.ssh/id_rsa*"

  # install jekyll and dependencies
  config.vm.provision "shell", inline: $script
end
