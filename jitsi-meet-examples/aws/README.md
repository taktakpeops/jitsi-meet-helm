# AWS EKS Example

An example for creating an EKS cluster and deploying Jitsi in EKS.

## Installation

Make sure that you Helm (v2+) and the AWS CLI installed on your machine. Clone this repository and go to `jitsi-meet-examples/aws`.

AWS offers a free tier that can be used for test purposes, more info [here](https://aws.amazon.com/free/).

In this folder, you can find a CloudFormation template creating an EKS cluster and its VPC along with an EKS node group. A folder called `k8s` contains all the manifest to deploy for installing NGinx ingress, CertManager and ACME issuer.

### Creating the cluster

First, go to your AWS Console in EC2 -> Key Pairs and create a new key called `eks-dev-nodes`. It will be used later for granting SSH access to the nodes.

To create the cluster, make sure that your AWS CLI is correctly setup and authenticated. In your terminal, run the following command:

```bash
aws cloudformation create-stack --stack-name eks-cluster --template-body="$(cat ./cloudformation.yaml)" --capabilities=CAPABILITY_IAM
```

After the stack got created, retrieve the credentials for updating your `kubeconfig` by running `aws eks update-kubeconfig --name dev`.

### Setting up the cluster
Run `helm init` to install `tiller` in your cluster. In case you want to user a service account + a role binding, deploy at first `k8s/rbac-config-helm.yaml` (edit namespace name and service account manifest according to your need. Default is creating a `helm` namespace forcing to suffix all commands with `--tiller-namespace=helm` for executing the different commands).

Once it's done, deploy the ingress controller using the values specified in `k8s/ingress-values.yaml` by doing the following in your terminal:

```bash
kubectl create ns ingress
helm upgrade -f ./k8s/ingress-values.yaml ingress stable/nginx-ingress --namespace ingress -i --wait
```

After it completes, deploy CertManager in the cluster:

```bash
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
helm repo add jetstack https://charts.jetstack.io 
helm repo update
helm upgrade cert-manager jetstack/cert-manager --namespace ingress --version v0.11.0 -i --wait
kubectl apply -f ./k8s/letsencrypt.yaml
```

### Creating the DNS
For creating the DNS, I used [`https://my.freenom.com/`](https://my.freenom.com/) which offers free `.tk` domain name.

For administrating the DNS, I decided to use [`Cloudflare`](https://www.cloudflare.com/pricing/) with a free-account.

After creating your DNS, update the name servers to point to the Cloudflare ones. Once it's done, go to your AWS console in EC2 -> Load Balancers. Look for the ingress NLB and add its domain name as CNAME entry in Cloudflare. Create a new subdomain for Jitsi: add a new CNAME entry for your domain name in Cloudflare targetting the NLB URL. The NLB will take care of redirecting the traffic to the correct ingress controller.

### Deploying Jitsi
Now that the cluster is setup, we can deploy Jitsi Meet in the cluster. Make sure that you edit the value of `web.ingress.hosts[0].host` to target the domain name created in the previous step.

Run the following command in your terminal:
```bash
kubectl create ns jitsi
helm upgrade jitsi ../../jitsi-meet -f ./jitsi-values.yaml --namespace jitsi -i --wait
```

Once the installation is complete, go back to the AWS console in EC2 -> Security Groups. Look for the security group prefixed with the name prefixed with `eks-remoteAccess`. Go to the `inbound rules` and add a custom rule for opening the port 30300 for UDP.

After it's done, launch a session and enjoy a call !

### Cleaning the deployment

To clean up the deployment, delete the Cloudformation stack by running `aws cloudformation delete-stack --stack-name jitsi`.

## Contributing

In case you have questions, found an issue or simply want to improve the example, feel free to open an issue or a pull-requests. Both are welcome !
