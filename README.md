Start EKS cluster and Applicatio Infrastrcture  with Terraform and Run Deploy of Kalandula App from Jenkins 

This will start an EKS cluster with terraform and other components for deploying the Kalandula App


1. # Prerequisites:
* Install Terraform on your workstation/server
* Install aws cli on your workstation/server
* Install kubectl on your workstation/server


2. # Variables:
* Change the aws_region to your requested region (default: us-east-1)
* Change kubernetes_version to the desired version (default: 1.18)
* Change k8s_service_account_namespace to the namespace for your application (default: default)
* Change k8s_service_account_name to the service account name for your application (default: k8s_service_account_name)


3. # Run:
* Run the following to start your eks environment:
* terraform init
* terraform apply --auto-approve
* After the environement is up run the following to update your kubeconfig file (you can get the cluster_name value from the cluster_name output in terraform)
* aws eks --region=us-east-1 update-kubeconfig --name <cluster_name>


4. # To test the environemet run the following:
* kubectl get nodes -o wide

5. # Optional:
If you'd like to add more authrized users or roles to your eks cluster follow this:

* Create an IAM role or user that is authorized to user EKS

* From an authorized user edit aws-auth-cm.yaml update aws-auth configmap and add the relevant users/roles and execute with kubectl
<<<<<<< HEAD
=======

>>>>>>> ac1bc4d8c0d419adcf6c9cb7ee8b2c76c98347d7
data:
  mapRoles: |
    - rolearn: <Replace with ARN of your EKS nodes role>
      
Important: Make sure you get the nodes role arn from the currently configured configmap using kubectl get configmap aws-auth -n kube-system -o yaml and replace with the above <Replace with ARN of your EKS nodes role>

<<<<<<< HEAD
<<<<<<< HEAD
6.  Add Jenkins Agent to IAM role that have the correct rights to perform all the actions needed.
=======
6. # Add Jenkins Agent to IAM role that have the correct rights to perform all the actions needed.
>>>>>>> ac1bc4d8c0d419adcf6c9cb7ee8b2c76c98347d7
=======
6.  Add Jenkins Agent to IAM role that have the correct rights to perform all the actions needed.
>>>>>>> 80f0a7e9130852a75181a6995e84802771528861

7. # Testing Consul Server :
* connect Consul server Public ip on port 8500 .

8. # Connection Jenkins and Running the Deploy 
* create credentials to connect EKS , choose kubeconfig and paste there the content of  cat .kube/config
* connect Jenkins Seever Public ip on port 8080 
* Run the job : deploy kalandula app 

<<<<<<< HEAD
9.  check form kubectl get pods and kubectl get svc , to see if the app and LB service deployed .

10.  connect EKS public cluster ip to check the Application is up and Running .
=======
9. check form kubectl get pods and kubectl get svc , to see if the app and LB service deployed .

10. connect EKS public cluster ip to check the Application is up and Running .
>>>>>>> ac1bc4d8c0d419adcf6c9cb7ee8b2c76c98347d7
