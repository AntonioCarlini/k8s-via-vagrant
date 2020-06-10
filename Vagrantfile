
require 'securerandom'

## ENV['VAGRANT_NO_PARALLEL'] = 'yes'

# TODO:
# 1. verify all IP addresses are in the specified network
# 2. remove the duplication of host name derivation when setting up the hosts file
# 3. Find a way of deleting the temporary hosts file that does not upset vagrant.
# 4. Perhaps the host network interface could be determined automatically.

box_name = "bento/ubuntu-18.04"                      # The Vagrant box used for each VM
vm_domain = "example.com"
worker_node_count = 2                                # The number of worker nodes to configure
net_intf = "enp0s25"                                 # The host network interface
vm_ip_network = "192.168.1.0/24"                     # The IP network the VMs all live in
vm_ip_addresses = []                                 # The individual VM IP addresses

# These are the addresses used by the VMs
vm_ip_addresses << "192.168.1.75"
vm_ip_addresses << "192.168.1.76"
vm_ip_addresses << "192.168.1.77"

# Nothing below here needs to be changed

vm_master_ip = vm_ip_addresses.shift()

# Build the k8s cluster's hosts file
# vagrant will object if the hosts_file variable does not exist, so be sure that it does
hosts_file_path = "/tmp/VagrantHosts#{SecureRandom.hex(32)}.txt"
File.open(hosts_file_path, "w") {
  |file|
  file.write("# K8S nodes - do not edit!\n")
  file.write("%-16.16s %-30.30s %s\n"% [ "#{vm_master_ip}", "k8s-master.#{vm_domain}", "k8s-master"])
  (1..worker_node_count).each do |i|
    file.write("%-16.16s %-30.30s %s\n"% [ "#{vm_ip_addresses[i-1]}", "k8s-worker#{i}.#{vm_domain}", "k8s-worker#{i}"])
  end
}

Vagrant.configure(2) do |config|

  # Every machine runs these provisioners
  config.vm.provision "file", source: "#{hosts_file_path}", destination: "k8s-hosts.txt"
  config.vm.provision "shell", path: "common-init.sh"

  # Kubernetes Master Server
  config.vm.define "master" do |master|
    master.vm.box = box_name
    master.vm.hostname = "k8s-master.#{vm_domain}"
    master.vm.network "public_network", :bridge => net_intf, ip: vm_master_ip
    master.vm.provider "virtualbox" do |v|
      v.name = "k8s-master"
      v.memory = 2048
      v.cpus = 2
    end
    master.vm.provision "shell", path: "start-master.sh", args: [ vm_master_ip, vm_ip_network ]
  end


  # Kubernetes Worker Nodes
  (1..worker_node_count).each do |i|
    config.vm.define "worker#{i}" do |worker|
      vm_worker_ip = vm_ip_addresses.shift()
      worker.vm.box = box_name
      worker.vm.hostname = "k8s-worker#{i}.#{vm_domain}"
      worker.vm.network "public_network", :bridge => net_intf, ip: vm_worker_ip
      worker.vm.provider "virtualbox" do |v|
        v.name = "k8s-worker#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      worker.vm.provision "shell", path: "start-worker.sh", args: [ "k8s-master.#{vm_domain}" ]
    end
  end

end

#File.delete(hosts_file_path) if File.exist?(hosts_file_path)
