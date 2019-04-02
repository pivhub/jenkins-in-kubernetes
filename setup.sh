export DOCKER_REG=harbor.pks.pkhamdee.com/library
export DOCKER_USR=admin
export DOCKER_PWD=password
export DOCKER_EML=pkhamdee@pivota.io

kubectl create secret docker-registry docker-reg-secret \
        --docker-server=${DOCKER_REG} \
        --docker-username=${DOCKER_USR} \
        --docker-password=${DOCKER_PWD} \
        --docker-email=${DOCKER_EML} \
        --namespace automate

helm upgrade --install jenkins \
        --namespace automate \
        --set imagePullSecrets=docker-reg-secret \
        --set image.repository=${DOCKER_REG}/jenkins \
        --set image.tag='lts-k8s' \
        ./helm/jenkins-k8s
