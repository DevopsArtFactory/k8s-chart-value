# !/bin/bash

# check installed kubectl
if command -v kubectl &> /dev/null
then
    echo "✅ kubectl is installed!"
else
    echo "❌ kubectl is NOT installed!"
fi

DIRECTORY_PATH="$1/argocd"

if [ ! -d "$DIRECTORY_PATH" ]; then
    echo "❌ Error: Directory '$DIRECTORY_PATH' does not exist!"
else
    echo "✅ Directory '$DIRECTORY_PATH' exists."
    cd $DIRECTORY_PATH
fi

while true; do
    kustomize build | kubectl apply -f -; 
    STATUS=$(kubectl get application external-secrets -n argocd  | awk 'NR>1 {print $3}')

    if [[ "$STATUS" == "Healthy" ]]; then
        echo "✅ Successfully applied Kustomize manifests!"
        break
    else
        echo "Application is not Healthy. Retrying in 60 seconds..."
        sleep 60
    fi
done