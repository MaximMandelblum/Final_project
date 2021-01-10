Start EKS cluster and Applicatio Infrastrcture  with Terraform and Run Deploy of Kalandula App from Jenkins 

This will start an EKS cluster with terraform and other components for deploying the Kalandula App


Prerequisites:
Install Terraform on your workstation/server
Install aws cli on your workstation/server
Install kubectl on your workstation/server

Variables:
Change the aws_region to your requested region (default: us-east-1)
Change kubernetes_version to the desired version (default: 1.18)
Change k8s_service_account_namespace to the namespace for your application (default: default)
Change k8s_service_account_name to the service account name for your application (default: k8s_service_account_name)

Run:
Run the following to start your eks environment:

terraform init
terraform apply --auto-approve
After the environement is up run the following to update your kubeconfig file (you can get the cluster_name value from the cluster_name output in terraform)

aws eks --region=us-east-1 update-kubeconfig --name <cluster_name>

To test the environemet run the following:

kubectl get nodes -o wide

Optional:
If you'd like to add more authrized users or roles to your eks cluster follow this:

Create an IAM role or user that is authorized to user EKS

From an authorized user edit aws-auth-cm.yaml update aws-auth configmap and add the relevant users/roles and execute with kubectl
data:
  mapRoles: |
    - rolearn: <Replace with ARN of your EKS nodes role>
      
Important: Make sure you get the nodes role arn from the currently configured configmap using kubectl get configmap aws-auth -n kube-system -o yaml and replace with the above <Replace with ARN of your EKS nodes role>
