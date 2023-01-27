#!/bin/bash
clear
echo "AKS cluster smoketest"
echo "------------------------------------------"
echo
echo "Current cluster info is:"
kubectl cluster-info
echo
echo "---------------------------------------------------------------"
echo "Infra services"
echo "---------------------------------------------------------------"
echo
echo "------------------------------------------"
echo "Flux"
echo "------------------------------------------"
echo
echo "Check Flux git sources"
echo
kubectl get gitrepositories -A | sed 's/ \+ /\t/g' | q -H -t "select READY, count(*) as cnt from - group by READY" -O -b
echo
kubectl get gitrepositories -A | sed 's/ \+ /\t/g' | q -H -t "select NAMESPACE, NAME, READY, STATUS from -" -O -b
echo
echo "Check Flux helm repo sources"
echo
kubectl get helmrepositories -A | sed 's/ \+ /\t/g' | q -H -t "select READY, count(*) as cnt from - group by READY" -O -b
echo
kubectl get helmrepositories -A | sed 's/ \+ /\t/g' | q -H -t "select NAMESPACE, NAME, READY, STATUS from -" -O -b
echo
echo "Check Flux helm releases"
echo
kubectl get helmrelease -A | sed 's/ \+ /\t/g' | q -H -t "select STATUS as helmrelease_status, count(*) as cnt from - group by STATUS" -O -b
echo
kubectl get helmrelease -A | sed 's/ \+ /\t/g' | q -H -t "select * from -" -O -b
echo
echo
echo "Check Flux helm charts"
echo
kubectl get helmcharts -A | sed 's/ \+ /\t/g' | q -H -t "select READY, count(*) as cnt from - group by READY" -O -b
echo
kubectl get helmcharts -A | sed 's/ \+ /\t/g' | q -H -t "select NAMESPACE, NAME, READY, STATUS from -" -O -b
echo
echo "Check Flux Kustomizations"
echo
kubectl get kustomizations -A | sed 's/ \+ /\t/g' | q -H -t "select READY, count(*) as cnt from - group by READY" -O -b
echo
kubectl get kustomizations -A | sed 's/ \+ /\t/g' | q -H -t "select * from -" -O -b
echo
echo "------------------------------------------"
echo "Azure AD pod identity"
echo "------------------------------------------"
echo
echo "Check MIC appears to be reconciling ok"
echo
kubectl logs --selector "app.kubernetes.io/component"="mic" -n pod-identity-system --all-containers=true --prefix=true --timestamps=true | grep "reconciling identity assignment"
echo
echo "Check MIC for errors or warnings"
echo
kubectl logs --selector "app.kubernetes.io/component"="mic" -n pod-identity-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "Check the managed identity controller (MIC) logs"
echo
kubectl logs --selector "app.kubernetes.io/component"="mic" -n pod-identity-system --all-containers=true --prefix=true --timestamps=true
echo
echo "------------------------------------------"
echo "Cert-manager"
echo "------------------------------------------"
echo
echo "Check cert-manager logs for errors or warnings"
echo
kubectl logs --selector "app"="cert-manager" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "Check cert-manager logs"
echo
kubectl logs --selector "app"="cert-manager" -n ingress-system --all-containers=true --prefix=true --timestamps=true
echo
echo "------------------------------------------"
echo "External-dns"
echo "------------------------------------------"
echo
echo "Check external-dns logs for **zone not found** errors"
echo
kubectl logs --selector "app.kubernetes.io/instance"="external-dns" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "Azure DNS zone was not found" -i
echo
echo "Check external-dns logs for **No endpoints could be generated** errors"
echo
kubectl logs --selector "app.kubernetes.io/instance"="external-dns" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "No endpoints could be generated" -i
echo
echo "Check external-dns logs for errors or warnings"
echo
kubectl logs --selector "app.kubernetes.io/instance"="external-dns" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "Check external-dns logs"
echo
kubectl logs --selector "app.kubernetes.io/instance"="external-dns" -n ingress-system --all-containers=true --prefix=true --timestamps=true
echo
echo "------------------------------------------"
echo "Kyverno"
echo "------------------------------------------"
echo
echo "Check Kyverno backup storage location is valid"
echo
kubectl logs --selector "app.kubernetes.io/instance"="velero" -n velero --all-containers=true --prefix=true --timestamps=true | grep "BackupStorageLocations is valid" -i
echo
echo "Check Kyverno logs for errors or warnings"
echo
kubectl logs --selector "app.kubernetes.io/instance"="kyverno" -n kyverno-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "Check Kyverno logs"
echo
kubectl logs --selector "app.kubernetes.io/instance"="kyverno" -n kyverno-system --all-containers=true --prefix=true --timestamps=true
echo
echo "---------------------------------------------------------------"
echo "Application services"
echo "---------------------------------------------------------------"
echo
echo "------------------------------------------"
echo "Orchestrate API"
echo "------------------------------------------"
echo
echo "Check for Orchestrate *network exists* error"
echo
kubectl logs deployment/orchestrate-api -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "a chain with the same name already exists" -i
echo
kubectl logs deployment/orchestrate-api -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Orchestrate tx-listener"
echo "------------------------------------------"
echo
kubectl logs deployment/orchestrate-tx-listener -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Orchestrate tx-sender"
echo "------------------------------------------"
echo
kubectl logs deployment/orchestrate-tx-sender -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Orchestrate quorum-key-manager"
echo "------------------------------------------"
echo
kubectl logs deployment/quorum-key-manager -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Orchestrate vault-configurer"
echo "------------------------------------------"
echo
kubectl logs deployment/vault-configurer -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Besu explorer"
echo "------------------------------------------"
echo
kubectl logs deployment/explorer -n besu --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Besu explorer-api"
echo "------------------------------------------"
echo
kubectl logs deployment/explorer-api -n besu --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Besu explorer-ingestion"
echo "------------------------------------------"
echo
kubectl logs deployment/explorer-ingestion -n besu --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Besu explorer-mongodb"
echo "------------------------------------------"
echo
kubectl logs deployment/explorer-mongodb -n besu --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Carbon-place carbon-external"
echo "------------------------------------------"
echo
kubectl logs deployment/carbon-external -n carbon-place --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Carbon-place carbon-front"
echo "------------------------------------------"
echo
kubectl logs deployment/carbon-front -n carbon-place --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "------------------------------------------"
echo "Codefi-assets carbon-front"
echo "------------------------------------------"
echo
kubectl logs deployment/admin-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "---------------------------------------------------------------"
echo "All resources"
echo "---------------------------------------------------------------"
echo
echo "Check all pods statuses"
echo
kubectl get pods -A | sed 's/ \+ /\t/g' | q -H -t "select STATUS, count(*) as cnt from - group by STATUS" -O -b
echo
echo "Check all pods restarts"
echo
kubectl get pods -A | sed 's/ \+ /\t/g' | q -H -t "select * from - where RESTARTS != '0'" -O -b
echo
echo "Check policy violations"
echo
kubectl get events | sed 's/ \+ /\t/g' | q -H -t "select OBJECT as policy, count(*) as cnt from - where REASON ='PolicyViolation' group by OBJECT order by cnt DESC" -O -b