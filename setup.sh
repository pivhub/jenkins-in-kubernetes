export DOCKER_REG=harbor.pcfgcp.pkhamdee.com/library
export DOCKER_USR=admin
export DOCKER_PWD=xxxx
export DOCKER_EML=pkhamdee@pivota.io

kubectl create namespace jenkins

kubectl create secret docker-registry docker-reg-secret \
        --docker-server=${DOCKER_REG} \
        --docker-username=${DOCKER_USR} \
        --docker-password=${DOCKER_PWD} \
        --docker-email=${DOCKER_EML} \
        --namespace jenkins

helm upgrade --install jenkins \
        --namespace jenkins \
        --set imagePullSecrets=docker-reg-secret \
        --set image.repository=${DOCKER_REG}/jenkins \
        --set image.tag='lts-k8s' \
        --set adminUser=admin \
        --set adminPassword=Bekind \
        ./helm/jenkins-k8s
