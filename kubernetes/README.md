# Deploy Docker 1.12.6 with Kubernetes 1.7.5 version

# Configuration
- Configure the `confs/daemon.json`
- To customize the disk creation edit the `preps/prep-disks.sh` file.
- Check the `envars.sh` and configure the following variables.
	 - DOCKER_BIP        : Docker bip address.
	 - BLOCK_DEVICE      : The block device that you will setup the devicemapper on it.
	 - KUBE_VERSION      : Kubernetes version that you want to initialize with v1.6.7 (default).
	 - KUBE_ADVERTISE_IP : The IP address the API Server will advertise it's listening on.

# Master Setup
- Execute the `master.sh`
- Kube-flannel, Kubernetes Dashoboard will be installed as well

# Worker Setup
- Execute the `worker.sh`

**After the deployment (kernel, docker and kubernetes) will be added to the exclude yum list in `/etc/yum.conf`.**
