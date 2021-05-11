# Setting up CI-CD 

## Steps to follow after server setup

### On Ansible-Server

1. Create folder K8s-playbooks and change owner to ansadmin user
    -   Copy image-build-playbook.yml
    -   Copy create-deployment-playbook.yml
    -   Copy create-service-playbook.yml
    -   Copy Dockerfile
    -   Create hosts file and add localhost and kubernetes master node IP address
    -   (This step can also be included in the user data script by using AWS S3 CP command to copy these files from the bucket to instance)

    
## On Jenkins Server

### Steps to create "Kubernetes-CI-Job" Jenkin job

1. Create a project Kubernetes-CI-job

1. Set SCM as github location and set poll SCM as required

1. Under build set pom.xml and set goals as: 'clean install package'

1. Under post build actions:
    - Send build artifacts over SSH
     - *SSH Publishers*
      - SSH Server Name: `ansible-server`
       - `Transfers` >  `Transfer set`
           - Source files: `webapp/target/*.war`
	       - Remove prefix: `webapp/target`
	       - Remote directory: `//opt//K8s-playbooks`
	       - Exec command: 
                ```sh 
                ansible-playbook -i /opt/K8s-playbooks/hosts /opt/K8s-playbooks/image-build-playbook.yml 
                ```

1. Under post build actions (This step needs to be done after creating the CD Job)
    - Build other projects
     - Projects to build: `Kubernetes-CD-Job`
     - Trigger only if buld is stable

### Steps to create "Kubernetes-CD-Job" Jenkin job

1. Create a project Kubernetes-CI-job

1. Under post build actions:
    - Send build artifacts over SSH
     - *SSH Publishers*
      - Exec command: 
            ```sh 
            ansible-playbook -i /opt/K8s-playbooks/hosts /opt/K8s-playbooks/create-deployment-playbook.yml;
            ansible-playbook -i /opt/K8s-playbooks/hosts /opt/K8s-playbooks/create-service-playbook.yml;
            ```

#### This completes the setup. After this we can change the code in the github and it will reflect on the K8s master node IP address in 31200 port.