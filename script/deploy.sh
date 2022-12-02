#!/bin/bash

name=${JOB_NAME}
image=$(cat ${WORKSPACE}/image)
host=${HOST}

echo "deploying ... name: ${name}, image: ${image}, host: ${host}"

rm -f web-demo-deploy.yaml
cp $(dirname "${BASH_SOURCE[0]}")/template/web-demo-deploy.yaml .
echo "copy success"


sed -i "s, {{name}}, ${name},g" web-demo-deploy.yaml
sed -i "s, {{image}}, ${image},g" web-demo-deploy.yaml
sed -i "s, {{host}}, ${host},g" web-demo-deploy.yaml

echo "ready to apply"
kubectl apply -f web-demo-deploy.yaml

echo "apply success"