#!/bin/bash
clear
echo "------------------------------------------"
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
echo "Flux - Check Flux git sources"
echo "------------------------------------------"
echo
kubectl get gitrepositories -A | sed 's/ \+ /\t/g' | q -H -t "select READY, count(*) as cnt from - group by READY" -O -b
echo
kubectl get gitrepositories -A | sed 's/ \+ /\t/g' | q -H -t "select NAMESPACE, NAME, READY, STATUS from -" -O -b
echo
echo "------------------------------------------"
echo "Flux - Check Flux helm repo sources"
echo "------------------------------------------"
echo
kubectl get helmrepositories -A | sed 's/ \+ /\t/g' | q -H -t "select READY, count(*) as cnt from - group by READY" -O -b
echo
kubectl get helmrepositories -A | sed 's/ \+ /\t/g' | q -H -t "select NAMESPACE, NAME, READY, STATUS from -" -O -b
echo
echo "------------------------------------------"
echo "Flux - Check Flux helm releases"
echo "------------------------------------------"
echo
kubectl get helmrelease -A | sed 's/ \+ /\t/g' | q -H -t "select STATUS as helmrelease_status, count(*) as cnt from - group by STATUS" -O -b
echo
kubectl get helmrelease -A | sed 's/ \+ /\t/g' | q -H -t "select * from -" -O -b
echo
echo "------------------------------------------"
echo "Flux - Check Flux helm charts"
echo "------------------------------------------"
echo
kubectl get helmcharts -A | sed 's/ \+ /\t/g' | q -H -t "select READY, count(*) as cnt from - group by READY" -O -b
echo
kubectl get helmcharts -A | sed 's/ \+ /\t/g' | q -H -t "select NAMESPACE, NAME, READY, STATUS from -" -O -b
echo
echo "------------------------------------------"
echo "Flux - Check Flux Kustomizations"
echo "------------------------------------------"
echo
kubectl get kustomizations -A | sed 's/ \+ /\t/g' | q -H -t "select READY, count(*) as cnt from - group by READY" -O -b
echo
kubectl get kustomizations -A | sed 's/ \+ /\t/g' | q -H -t "select * from -" -O -b
echo
echo "------------------------------------------"
echo "AAD podId - Check MIC reconciling"
echo "------------------------------------------"
echo
kubectl logs --selector "app.kubernetes.io/component"="mic" -n pod-identity-system --all-containers=true --prefix=true --timestamps=true | grep "reconciling identity assignment"
echo
echo "------------------------------------------"
echo "AAD podId - Errors or warnings"
echo "------------------------------------------"
echo
kubectl logs --selector "app.kubernetes.io/component"="mic" -n pod-identity-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Cert-manager - Errors or warnings"
echo "------------------------------------------"
echo
kubectl logs --selector "app"="cert-manager" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "External-dns - **zone not found** errors"
echo "------------------------------------------"
echo
kubectl logs --selector "app.kubernetes.io/instance"="external-dns" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "Azure DNS zone was not found" -i
echo
echo "------------------------------------------"
echo "External-dns - **No endpoints could be generated** errors"
echo "------------------------------------------"
echo
kubectl logs --selector "app.kubernetes.io/instance"="external-dns" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "No endpoints could be generated" -i
echo
echo "------------------------------------------"
echo "External-dns - Errors or warnings"
echo "------------------------------------------"
echo
kubectl logs --selector "app.kubernetes.io/instance"="external-dns" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Kyverno - Storage location is valid"
echo "------------------------------------------"
echo
kubectl logs --selector "app.kubernetes.io/instance"="velero" -n velero --all-containers=true --prefix=true --timestamps=true | grep "BackupStorageLocations is valid" -i
echo
echo "------------------------------------------"
echo "Kyverno - Errors or warnings"
echo "------------------------------------------"
echo
kubectl logs --selector "app.kubernetes.io/instance"="kyverno" -n kyverno-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "---------------------------------------------------------------"
echo "Application services"
echo "---------------------------------------------------------------"
echo
echo "------------------------------------------"
echo "Orchestrate API - *network exists* error"
echo "------------------------------------------"
echo
kubectl logs deployment/orchestrate-api -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "a chain with the same name already exists" -i
echo
echo "------------------------------------------"
echo "Orchestrate API - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/orchestrate-api -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Orchestrate tx-listener - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/orchestrate-tx-listener -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Orchestrate tx-sender - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/orchestrate-tx-sender -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Orchestrate quorum-key-manager - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/quorum-key-manager -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Orchestrate vault-configurer - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/vault-configurer -n orchestrate --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Besu explorer - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/explorer -n besu --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Besu explorer-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/explorer-api -n besu --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Besu explorer-ingestion - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/explorer-ingestion -n besu --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Besu explorer-mongodb - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/explorer-mongodb -n besu --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Carbon-place carbon-external - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/carbon-external -n carbon-place --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Carbon-place carbon-front - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/carbon-front -n carbon-place --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets admin-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/admin-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets assets-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/assets-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets assets-front - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/assets-front -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets entity-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/entity-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets external-identity-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/external-identity-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets i18n-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/i18n-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets kyc-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/kyc-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets mailing-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/mailing-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets metadata-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/metadata-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets smart-contract-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/smart-contract-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Codefi-assets workflow-api - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/workflow-api -n codefi-assets --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Kafka confluent-stack-cp-schema-registry - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/confluent-stack-cp-schema-registry -n kafka --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "Kafka kafka-ui - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/kafka-ui -n kafka --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "------------------------------------------"
echo "pgadmin - Errors and warnings"
echo "------------------------------------------"
echo
kubectl logs deployment/pgadmin -n pgadmin --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i -B 10 -A 10
echo
echo "---------------------------------------------------------------"
echo "All resources"
echo "---------------------------------------------------------------"
echo
echo "------------------------------------------"
echo "Check all pods statuses"
echo "------------------------------------------"
echo
kubectl get pods -A | sed 's/ \+ /\t/g' | q -H -t "select STATUS, count(*) as cnt from - group by STATUS" -O -b
echo
echo "------------------------------------------"
echo "Check all pods restarts"
echo "------------------------------------------"
echo
kubectl get pods -A | sed 's/ \+ /\t/g' | q -H -t "select * from - where RESTARTS != '0'" -O -b
echo
echo "------------------------------------------"
echo "Report ends"
echo "------------------------------------------"