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

# HEALTH CKECK
count=60
success=0
IFS=','
sleep 5
while [$[count] -gt 0]
do 
  replicas=$(kubectl get deploy ${name} -o go-template='{{.status.replicas}},{{.status.updatedReplicas}}.{{.status.readyReplicas}}.{{.status.availabeReplicas}}')
  echo "replicas: ${replicas}"
  arr=(${replicas})
  if [ "${arr[0]}" == "${arr[1]}" -a "${arr[1]}" == "${arr[2]}" -a "${arr[2]}" == "${arr[3]}"];then
    echo "health check success"
    success = 1
    break
  fi
  ((count--))
  sleep 2
done

if [ ${success} -ne 1];then
  echo "health check failed!"
  exit 1
fi