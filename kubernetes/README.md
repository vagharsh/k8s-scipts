# Deploy Docker-CE 17.03.2 with Latest Kubernetes version

# Configuration
- Configure the `confs/daemon.json`
- To customize the disk creation edit the `preps/prep-disks.sh` file.
- Check the `envvars.sh` and configure the following variables.
	 - DOCKER_BIP          : [string] Docker bip address.
     - POD_CIDR            : [string] Pods CIDR, if provided Flannel will be used for networking, if not Weave will be used.
	 - BLOCK_DEVICE        : [string] The block device that you will setup the devicemapper on it.
	 - KUBE_VERSION        : [string] Kubernetes version that you want to initialize with. if not specified then, the latest version will be used.
     - DEFAULT_NIC         : [string] Network Interface that will be used by Kubernetes e.g. eth0.
	 - KUBE_ADVERTISE_IP   : [string] The IP address on which to advertise the apiserver to members of the cluster.
     - KUBE_ADVERTISE_NAME : [string] The DNS Name which will be used in the certificate creation DNS name.
 	 - NAMESPACE           : [array] Kubernetes namespaces that will be created after the deployment.
 	 - TIMEZONE            : [string] Timezone of the server which will be setup while OS prep.

# Master Setup
- Execute the `master.sh`

    ```
        When not providing an option, all options will selected by default.

        -o | --os         : Execute the OS Preparation script
        -d | --docker     : Execute the Docker Setup script
        -k | --kubernetes : Kubernetes Master Node Setup script
        -i | --init       : Execute the Kubernetes Master node Initialization script
        -p | --post       : Execute Post Initialization script
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
**After the deployment (kernel) will be added to the exclude yum list in `/etc/yum.conf`.**
