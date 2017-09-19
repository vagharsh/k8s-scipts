# Deploy Docker 1.12.6 with Kubernetes latest version

# Configuration
- Configure the `confs/daemon.json`
- To customize the disk creation edit the `preps/prep-disks.sh` file.
- Check the `envars.sh` and configure the following variables.
	 - DOCKER_BIP : docker bip address.
	 - BLOCK_DEVICE : the block device that you will setup the devicemapper on it.
	 - KUBE_VERSION : kubernetes version that you want to initialize with.

# Master Setup
- Execute the `master.sh`
- Kube-flannel, Kubernetes Dashoboard will be installed as well

# Worker Setup
- Execute the `worker.sh`

**After the deployment docker and kubernetes will be added to the exclude yum list in `/etc/yum.conf`.**
