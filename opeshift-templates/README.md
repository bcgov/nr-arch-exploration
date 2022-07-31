## Redis HA Deployment

```
oc apply -f https://raw.githubusercontent.com/bcgov/nr-arch-templates/main/opeshift-templates/redis-ha-dc.yaml
```
* Once the pods are running, run the following command to initialize the cluster:

```
oc exec -it redis-0 -- redis-cli --cluster create --cluster-replicas 1 $(oc get pods -l app=redis -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')
```

#Delete Scripts
##Redis HA
`oc delete -n <namespace-env> all,rc,svc,dc,route,pvc,secret,configmap,sa,RoleBinding -l app=redis`
