# NP-audit-log-monitoring

Monitoring Script for Kubernetes Network Policy Audit log.
It will keep running on the worker node as daemon forever.

# Assumption

1. Using OVN-K8S CNI (The audit log will store to /var/log/ovn)
2. Allow to use SUDO (Because only sudo can access to /var/log/ovn)
3. Script is storing on `/var/home/core/np_audit_log_montioring/log/runtime.log`

# Deployment

``` sh
# Create the log file on the correct path
mkdir -p /var/home/core/np_audit_log_montioring/log/
touch /var/home/core/np_audit_log_montioring/log/runtime.log

sudo nohup ./script/np_audit_log_montioring.sh </dev/null >/dev/null 2>&1 &
# OR
sudo nohup ./script/np_audit_log_montioring.sh </dev/null >/var/home/core/np_audit_log_montioring/log/runtime.log 2>&1 & 
```

# Kill the Process

``` sh
sudo kill -9 $(ps -fade | grep np_audit_log_montioring.sh | grep -v grep | awk '{print $2}')
```
