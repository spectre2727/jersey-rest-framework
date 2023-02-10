#!/bin/bash
echo "** Gradle **"
gradle clean shadowJar

echo -e "\n** Docker **"
docker rmi spectre27/jerseyspringartifact01
docker build -t spectre27/jerseyspringartifact01 -f docker/Dockerfile.kubernetes .
docker push spectre27/jerseyspringartifact01

echo -e "\n** Kubernetes **"
kubectl apply -f sh/v1.yaml
kubectl delete service jerseyservice
kubectl delete deployment jerseyspring
kubectl create deployment jerseyspring --image=spectre27/jerseyspringartifact01
kubectl apply -f sh/service-jerseyspring.yaml
kubectl get services
# kubectl port-forward service/jerseyspring 8181:8080
