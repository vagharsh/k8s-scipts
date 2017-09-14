# Deploy Docker 1.12.6 with Kubernetes latest version

# Master Setup
- Execute the `master-setup.sh`
- Kubernetes will be initialized with v1.6.7
- Kube-flannel, Kubernetes Dashoboard will be installed as well
- Configure the docker `daemon.json` file from inside the `master-setup.sh`

# Worker Setup
- Execute the `worker-setup.sh`
- To customize the disk creation edit the `prep-disks.sh` file.
- Configure the docker `daemon.json` file from inside the `worker-setup.sh`


**After the deployment docker and kubernetes will be added to the exclude yum list in `/etc/yum.conf`.**