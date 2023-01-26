#!/bin/bash
clear
echo "AKS cluster smoketest"
echo "---------------------"
echo
echo "Current cluster info is:"
kubectl cluster-info
echo
echo "---------------------"
echo "Flux"
echo "---------------------"
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
echo "---------------------"
echo "Azure AD pod identity"
echo "---------------------"
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
echo "---------------------"
echo "Cert-manager"
echo "---------------------"
echo
echo "Check cert-manager logs for errors or warnings"
echo
kubectl logs --selector "app"="cert-manager" -n ingress-system --all-containers=true --prefix=true --timestamps=true | grep "error\|warning" -i
echo
echo "Check cert-manager logs"
echo
kubectl logs --selector "app"="cert-manager" -n ingress-system --all-containers=true --prefix=true --timestamps=true
echo
echo "---------------------"
echo "External-dns"
echo "---------------------"
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
echo "---------------------"
echo "Kyverno"
echo "---------------------"
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
echo "---------------------"
echo "All"
echo "---------------------"
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