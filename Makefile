create_cluster:
	eksctl create cluster --name fyc-esgi-app-cluster --version 1.22 --region eu-west-1 --nodegroup-name linux-nodes --node-type t2.micro --nodes 3

delete_cluster:
	eksctl delete cluster fyc-esgi-app-cluster

describe_cluster:
	eksctl utils describe-stacks --region=eu-west-1 --cluster=fyc-esgi-app-cluster --node-type t2.micro --nodes 3

aws_identity:
	aws sts get-caller-identity

set_context:
	eksctl utils write-kubeconfig --cluster=fyc-esgi-app-cluster --set-kubeconfig-context=true

enable_iam_sa_provider:
	eksctl utils associate-iam-oidc-provider --cluster=fyc-esgi-app-cluster --approve

create_cluster_role:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml

create_iam_policy:
	aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://role/iam_policy.json

create_service_account:
	eksctl create iamserviceaccount --cluster=fyc-esgi-app-cluster --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::264441729266:policy/AWSLoadBalancerControllerIAMPolicy --override-existing-serviceaccounts --approve

add_graphical_ref_eks_to_helm:
	helm repo add eks https://aws.github.io/eks-charts

install_TargetGroupBinding:
	kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

install_graphical_helm:
	helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=fyc-esgi-app-cluster --set serviceAccount.create=false --set region=eu-west-1 --set vpcId=vpc-0d2c1f378b17babfc --set serviceAccount.name=aws-load-balancer-controller -n kube-system

deploy_application:
	kustomize build ./ | kubectl apply -f -

delete_application:
	kustomize build ./ | kubectl delete -f -
