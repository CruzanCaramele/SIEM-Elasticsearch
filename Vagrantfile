Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "public_network"
  # config.vm.network "forwarded_port" , guest: 9200, host: 9200

  config.vm.provision "shell", path: "scripts/elk.sh"

end
