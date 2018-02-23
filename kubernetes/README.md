# Deploy Docker-CE 17.03.2 with Latest Kubernetes version

# Configuration
- Configure the `confs/daemon.json`
- To customize the disk creation edit the `preps/prep-disks.sh` file.
- Check the `envars.sh` and configure the following variables.
	 - DOCKER_BIP        : Docker bip address.
	 - BLOCK_DEVICE      : The block device that you will setup the devicemapper on it.
	 - KUBE_VERSION      : Kubernetes version that you want to initialize with.
	 - KUBE_ADVERTISE_IP : The IP address the API Server will advertise it's listening on.
 	 - NAMESPACE         : kubernetes namespaces that will be created after the deployment.
     - DEFAULT_NIC       : Default Network Interface that will be used by Kubernetes e.g. eth0.

# Master Setup
- Execute the `master.sh`

    ```
        When not providing an option, all options will selected by default.

        -o | --os         : Execute the OS Preparation script
        -d | --docker     : Execute the Docker Setup script
        -k | --kubernetes : Kubernetes Master Node Setup script
        -i | --init       : Execute the Kubernetes Master node Initialization script
        -h | --help       : Help Message
        
    ``` 
- Kube-flannel, Kubernetes Dashoboard will be installed as well

# Worker Setup
- Execute the `worker.sh`

    ```
        When not providing an option, all options will selected by default.

        -o | --os         : Execute the OS Preparation script
        -d | --docker     : Execute the Docker Setup script
        -k | --kubernetes : Kubernetes Master Node Setup script
        -h | --help       : Help Message

    ``` 
**After the deployment (kernel, docker and kubernetes) will be added to the exclude yum list in `/etc/yum.conf`.**
