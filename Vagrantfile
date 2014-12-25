# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "Sgoettschkes/debian7"

  config.vm.provision "shell", inline: "apt-get update"
  config.vm.provision "shell", inline: "gem install --no-rdoc --no-ri bundler jekyll rake"
  config.vm.provision "shell", inline: "apt-get install -t testing -y nodejs"
end
