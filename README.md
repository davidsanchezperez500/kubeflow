# kubeflow

## Project info
**Project name:** mlops

**Project ID:** mlops-312413



## Go to the following pages on the GCP Console and ensure that the specified APIs are enabled:
~~~
gcloud services enable \
  compute.googleapis.com \
  container.googleapis.com \
  iam.googleapis.com \
  servicemanagement.googleapis.com \
  cloudresourcemanager.googleapis.com \
  ml.googleapis.com \
  meshconfig.googleapis.com

# Cloud Build API is optional, you need it if using Fairing.
# gcloud services enable cloudbuild.googleapis.com
~~~

## Initialize your project to prepare it for Anthos Service Mesh installation:
~~~
PROJECT_ID=mlops-312413
curl --request POST \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --data '' \
  https://meshconfig.googleapis.com/v1alpha1/projects/${PROJECT_ID}:initialize
~~~
## Install the required tools 
~~~
gcloud components install kubectl kpt anthoscli beta
gcloud components update
~~~

## Install Kustomize
~~~
# Detect your OS and download corresponding latest Kustomize binary
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

# Add the kustomize package to your $PATH env variable
sudo mv ./kustomize /usr/local/bin/kustomize
~~~

## Install yq
snap install yq --channel=v3/stable


## Install jq
sudo apt  install jq


## Create Cluster

Create with Terraform. Folder kubeflow/terraform/cluster-gke-mlops


## Enviroment Variables
~~~
# bash
MGMT_PROJECT=mlops-312413
MGMT_DIR=/home/david/repos/kubeflow/kf-deployments/management
MGMT_NAME=cluster-mlops
LOCATION=us-east1

# fish
set MGMT_PROJECT mlops-312413
set MGMT_DIR /home/david/repos/kubeflow/kf-deployments/management
set MGMT_NAME cluster-mlops
set LOCATION us-east1
~~~

## Setting up a management cluster
1. Fetch the management blueprint to current directory 
~~~
kpt pkg get https://github.com/kubeflow/gcp-blueprints.git/management@v1.2.0 "${MGMT_DIR}"
~~~

2. Change to the Kubeflow directory
~~~
cd "${MGMT_DIR}"
~~~

3. Fetch the upstream management package
~~~
make get-pkg
~~~

4. Use kpt to set values for the name, project, and location of your management cluster:
~~~
kpt cfg set -R . name "${MGMT_NAME}"
kpt cfg set -R . gcloud.core.project "${MGMT_PROJECT}"
kpt cfg set -R . location "${LOCATION}"
~~~

5. Create or apply the management cluster:
~~~
make apply-cluster

# Optionally, you can verify the management cluster spec before applying it by:
make hydrate-cluster
~~~

6. Create a kubectl context for the management cluster, it will be named ${MGMT_NAME}:
~~~
make create-context
~~~

7. Install the Cloud Config Connector:
~~~
make apply-kcc
~~~

## Authorize Cloud Config Connector for each managed project 
1. Set the managed project:
~~~
kpt cfg set ./instance managed-project "${MGMT_PROJECT}"
~~~

2. Update the policy:
~~~
gcloud beta anthos apply ./instance/managed-project/iam.yaml
~~~



# Deploy using kubectl and kpt

~~~
# bash

KF_NAME=my-kubeflow
KF_PROJECT=mlops-312413
KF_DIR=/home/david/repos/kubeflow/kf-deployments/my-kubeflow
MGMT_NAME=cluster-mlops
MGMTCTXT="${MGMT_NAME}"
LOCATION=us-east1
~~~

## Fetch packages using kpt 
1. Fetch the Kubeflow package
~~~
kpt pkg get https://github.com/kubeflow/gcp-blueprints.git/kubeflow@v1.2.0 "${KF_DIR}"
~~~

2. Change to the Kubeflow directory
~~~
cd "${KF_DIR}"/kubeflow
~~~

3. Fetch Kubeflow manifests
~~~
make get-pkg
~~~

# Configure Kubeflow 
### You need to edit the makefile at ${KF_DIR}/Makefile to set the parameters to the desired values.
- The management cluster deployment instructions creates a kubectl context named ${MGMT_NAME} for you. You can use it as ${MGMTCTXT}:
~~~
kpt cfg set ./instance mgmt-ctxt ${MGMTCTXT}
~~~

### You need to configure the kubectl context ${MGMTCTXT}.
- Choose the management cluster context
~~~
kubectl config use-context "${MGMTCTXT}"
~~~

- Create a namespace in your management cluster for the managed project if you haven’t done so.
~~~
kubectl create namespace "${KF_PROJECT}"
~~~

- Make the Kubeflow project’s namespace default of the ${MGMTCTXT} context:
~~~
kubectl config set-context --current --namespace "${KF_PROJECT}"
~~~

- Set environment variables with OAuth Client ID and Secret for IAP
~~~
export CLIENT_ID=<Your CLIENT_ID>
export CLIENT_SECRET=<Your CLIENT_SECRET>
~~~

- Invoke the make rule to set the kpt setters:
~~~
make set-values
~~~

# Deploy Kubeflow 
make apply











## Links
https://www.kubeflow.org