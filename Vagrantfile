Vagrant.configure('2') do |config|
  config.vm.define :docker do |docker_vm|
    docker_vm.vm.box = 'generic/ubuntu1804'
    docker_vm.vm.hostname = 'docker'
    docker_vm.vm.synced_folder './../../', '/vagrant'
    docker_vm.vm.provision 'shell', path: './scripts/docker_machine.sh'

    docker_vm.vm.provider :libvirt do |lv, override|
      lv.memory = 2*1024
      lv.cpus = 2
      lv.cpu_mode = 'host-passthrough'
    end

  end
end