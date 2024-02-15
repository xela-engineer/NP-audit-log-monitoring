# NP-audit-log-monitoring
Monitoring Script for Kubernetes Network Policy Audit log.
It will keep running on the worker node forever

# Assumption

1. Using OVN-K8S CNI (The audit log will store to /var/log/ovn)
2. Allow to use SUDO (Because only sudo can access to /var/log/ovn)

# Deployment

``` sh
setsid myscript.sh >/dev/null 2>&1 < /dev/null &
```

# Kill the Process

``` sh
```
