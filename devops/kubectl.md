# kubectl Cheatsheet

> Kubernetes command-line tool for managing clusters and workloads.
> Last verified: May 2026 | Version: 1.30

---

## Quick Reference

| Command | Description |
|---|---|
| `kubectl get pods` | List all pods in current namespace |
| `kubectl get all` | List all resources in namespace |
| `kubectl describe pod <name>` | Detailed info about a pod |
| `kubectl logs <pod>` | View pod logs |
| `kubectl exec -it <pod> -- bash` | Shell into a running pod |
| `kubectl apply -f file.yaml` | Apply a manifest file |
| `kubectl delete pod <name>` | Delete a pod |
| `kubectl scale deploy <name> --replicas=3` | Scale a deployment |
| `kubectl rollout restart deploy/<name>` | Restart a deployment |
| `kubectl config use-context <ctx>` | Switch cluster context |

---

## Context & Cluster Management

### Listing and Switching Contexts

```bash
# List all contexts
kubectl config get-contexts

# Switch to a different context
kubectl config use-context my-cluster

# Show current context
kubectl config current-context

# Get cluster info
kubectl cluster-info

# List all clusters in kubeconfig
kubectl config get-clusters

# Set a namespace as default for current context
kubectl config set-context --current --namespace=my-namespace

# View raw kubeconfig
kubectl config view

# View kubeconfig with secrets shown
kubectl config view --raw
```

### Merging Kubeconfigs

```bash
# Merge two kubeconfig files
KUBECONFIG=~/.kube/config:~/new-cluster.yaml kubectl config view --flatten > ~/.kube/merged-config

# Use a specific kubeconfig file
kubectl --kubeconfig=/path/to/config get pods

# Use KUBECONFIG env var for temporary override
export KUBECONFIG=~/.kube/config:~/.kube/other-config
```

---

## Getting Resources

### Basic Get Commands

```bash
# List pods in current namespace
kubectl get pods

# List pods in all namespaces
kubectl get pods --all-namespaces
kubectl get pods -A

# List pods with more details (node, IP)
kubectl get pods -o wide

# List pods with labels shown
kubectl get pods --show-labels

# List pods matching a label selector
kubectl get pods -l app=nginx
kubectl get pods -l app=nginx,env=prod

# Get a specific pod in JSON
kubectl get pod my-pod -o json

# Get a specific pod in YAML
kubectl get pod my-pod -o yaml

# Watch pods update in real-time
kubectl get pods -w

# Get all resource types at once
kubectl get all

# Get across multiple resource types
kubectl get pods,services,deployments

# Get resource with custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName

# Get only pod names
kubectl get pods -o name
```

### Filtering and Sorting

```bash
# Get pods by field selector
kubectl get pods --field-selector status.phase=Running

# Sort pods by restart count
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'

# Sort pods by creation time
kubectl get pods --sort-by='.metadata.creationTimestamp'

# Get events sorted by time
kubectl get events --sort-by='.lastTimestamp'

# Get events for a specific namespace
kubectl get events -n my-namespace
```

---

## Describing Resources

```bash
# Describe a pod (full details)
kubectl describe pod my-pod

# Describe a node
kubectl describe node my-node

# Describe a deployment
kubectl describe deployment my-deployment

# Describe a service
kubectl describe service my-service

# Describe a namespace
kubectl describe namespace my-namespace

# Describe all pods matching label
kubectl describe pods -l app=nginx
```

---

## Pods

### Pod Logs

```bash
# View logs from a pod
kubectl logs my-pod

# Follow logs (tail -f equivalent)
kubectl logs -f my-pod

# Get last 100 lines
kubectl logs --tail=100 my-pod

# Get logs since a time duration
kubectl logs --since=1h my-pod
kubectl logs --since=30m my-pod

# Get logs from a specific container in a multi-container pod
kubectl logs my-pod -c my-container

# Get logs from previous (crashed) container
kubectl logs my-pod --previous
kubectl logs my-pod -p

# Get logs from all containers in a pod
kubectl logs my-pod --all-containers=true

# Get logs from all pods matching a label
kubectl logs -l app=nginx --all-containers=true

# Stream logs from all pods in a deployment
kubectl logs -f deployment/my-deployment
```

### Exec Into Pods

```bash
# Get a bash shell in a pod
kubectl exec -it my-pod -- bash

# Get a sh shell (for minimal images)
kubectl exec -it my-pod -- sh

# Run a single command in a pod
kubectl exec my-pod -- env

# Exec into a specific container
kubectl exec -it my-pod -c my-container -- bash

# Copy files from pod to local
kubectl cp my-pod:/path/to/file ./local-file

# Copy files from local to pod
kubectl cp ./local-file my-pod:/path/to/file
```

### Port Forwarding

```bash
# Forward local port 8080 to pod port 80
kubectl port-forward pod/my-pod 8080:80

# Forward to a deployment (picks a pod automatically)
kubectl port-forward deployment/my-deployment 8080:80

# Forward to a service
kubectl port-forward service/my-service 8080:80

# Forward multiple ports
kubectl port-forward pod/my-pod 8080:80 9090:90

# Listen on all interfaces (not just localhost)
kubectl port-forward --address 0.0.0.0 pod/my-pod 8080:80
```

### Running Temporary Pods

```bash
# Run a temporary debug pod
kubectl run debug --image=busybox --rm -it --restart=Never -- sh

# Run a curl pod for testing
kubectl run curl --image=curlimages/curl --rm -it --restart=Never -- sh

# Run a pod with env vars
kubectl run my-pod --image=nginx --env="ENV=prod" --env="PORT=8080"

# Run a pod and expose as service
kubectl run my-pod --image=nginx --port=80 --expose
```

---

## Deployments

### Managing Deployments

```bash
# Create a deployment
kubectl create deployment my-app --image=nginx:1.25

# Scale a deployment
kubectl scale deployment my-deployment --replicas=5

# Scale using patch
kubectl patch deployment my-deployment -p '{"spec":{"replicas":3}}'

# Update container image
kubectl set image deployment/my-deployment my-container=nginx:1.26

# View rollout status
kubectl rollout status deployment/my-deployment

# View rollout history
kubectl rollout history deployment/my-deployment

# View specific revision details
kubectl rollout history deployment/my-deployment --revision=2

# Rollback to previous version
kubectl rollout undo deployment/my-deployment

# Rollback to a specific revision
kubectl rollout undo deployment/my-deployment --to-revision=2

# Pause a rollout
kubectl rollout pause deployment/my-deployment

# Resume a paused rollout
kubectl rollout resume deployment/my-deployment

# Restart all pods in a deployment (rolling restart)
kubectl rollout restart deployment/my-deployment
```

---

## Services

```bash
# List all services
kubectl get services
kubectl get svc

# Expose a deployment as a ClusterIP service
kubectl expose deployment my-deployment --port=80 --target-port=8080

# Expose as NodePort
kubectl expose deployment my-deployment --type=NodePort --port=80

# Expose as LoadBalancer
kubectl expose deployment my-deployment --type=LoadBalancer --port=80

# Get service endpoint details
kubectl get endpoints my-service

# Delete a service
kubectl delete service my-service
```

---

## ConfigMaps & Secrets

### ConfigMaps

```bash
# Create configmap from literal values
kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2

# Create configmap from a file
kubectl create configmap my-config --from-file=config.properties

# Create configmap from a directory of files
kubectl create configmap my-config --from-file=./config-dir/

# View configmap data
kubectl get configmap my-config -o yaml

# Edit a configmap
kubectl edit configmap my-config

# Delete a configmap
kubectl delete configmap my-config
```

### Secrets

```bash
# Create a generic secret
kubectl create secret generic my-secret --from-literal=password=supersecret

# Create a secret from a file
kubectl create secret generic my-secret --from-file=./secret.txt

# Create a TLS secret
kubectl create secret tls my-tls-secret --cert=tls.crt --key=tls.key

# Create a Docker registry secret
kubectl create secret docker-registry regcred \
  --docker-server=my-registry.example.com \
  --docker-username=user \
  --docker-password=pass \
  --docker-email=user@example.com

# View secret (base64 encoded)
kubectl get secret my-secret -o yaml

# Decode a secret value
kubectl get secret my-secret -o jsonpath='{.data.password}' | base64 --decode

# Edit a secret
kubectl edit secret my-secret
```

---

## Namespaces

```bash
# List all namespaces
kubectl get namespaces
kubectl get ns

# Create a namespace
kubectl create namespace my-namespace

# Run commands in a specific namespace
kubectl get pods -n my-namespace
kubectl get pods --namespace=my-namespace

# Delete a namespace (deletes everything in it!)
kubectl delete namespace my-namespace

# Set default namespace for current context
kubectl config set-context --current --namespace=my-namespace
```

---

## Applying & Creating Resources

```bash
# Apply a manifest (create or update)
kubectl apply -f deployment.yaml

# Apply all manifests in a directory
kubectl apply -f ./manifests/

# Apply from URL
kubectl apply -f https://example.com/manifest.yaml

# Create a resource (fails if exists)
kubectl create -f deployment.yaml

# Replace a resource (delete and recreate)
kubectl replace -f deployment.yaml

# Force replace (use cautiously)
kubectl replace --force -f deployment.yaml

# Dry run to preview changes
kubectl apply -f deployment.yaml --dry-run=client

# Server-side dry run
kubectl apply -f deployment.yaml --dry-run=server

# Diff current state vs manifest
kubectl diff -f deployment.yaml

# Delete resources defined in a manifest
kubectl delete -f deployment.yaml

# Patch a resource (strategic merge patch)
kubectl patch deployment my-deploy -p '{"spec":{"template":{"spec":{"terminationGracePeriodSeconds":60}}}}'

# Patch with JSON patch
kubectl patch pod my-pod --type='json' -p='[{"op":"replace","path":"/spec/containers/0/image","value":"nginx:1.26"}]'
```

---

## Nodes

```bash
# List nodes
kubectl get nodes

# List nodes with resource usage
kubectl top nodes

# Describe a node
kubectl describe node my-node

# Cordon a node (prevent new pods from scheduling)
kubectl cordon my-node

# Uncordon a node
kubectl uncordon my-node

# Drain a node for maintenance (evicts pods)
kubectl drain my-node --ignore-daemonsets --delete-emptydir-data

# Label a node
kubectl label node my-node disktype=ssd

# Remove a label from a node
kubectl label node my-node disktype-

# Taint a node
kubectl taint nodes my-node key=value:NoSchedule

# Remove a taint
kubectl taint nodes my-node key=value:NoSchedule-
```

---

## Resource Usage

```bash
# Show CPU/memory usage of pods
kubectl top pods

# Show CPU/memory usage of pods in all namespaces
kubectl top pods -A

# Show resource usage of a specific pod
kubectl top pod my-pod

# Show resource usage sorted by CPU
kubectl top pods --sort-by=cpu

# Show resource usage sorted by memory
kubectl top pods --sort-by=memory

# View resource requests/limits in a namespace
kubectl describe nodes | grep -A5 "Allocated resources"
```

---

## Troubleshooting

```bash
# Describe a crashing pod for events
kubectl describe pod crashing-pod

# Get logs from a crashed container (previous run)
kubectl logs crashing-pod --previous

# Check events in a namespace for failures
kubectl get events --field-selector type=Warning

# Check events sorted by time
kubectl get events --sort-by='.lastTimestamp'

# Debug using an ephemeral container (K8s 1.23+)
kubectl debug -it my-pod --image=busybox --target=my-container

# Debug a node by running a pod on it
kubectl debug node/my-node -it --image=ubuntu

# Check if a service has valid endpoints
kubectl get endpoints my-service

# Check pod resource constraints
kubectl describe pod my-pod | grep -A3 "Limits\|Requests"

# Get OOMKilled pod details
kubectl get pod my-pod -o jsonpath='{.status.containerStatuses[*].lastState}'

# View pod resource usage vs limits
kubectl top pod my-pod --containers

# Check DNS resolution from a pod
kubectl exec -it my-pod -- nslookup kubernetes.default

# Check network connectivity from a pod
kubectl exec -it my-pod -- curl http://other-service
```

---

## JSONPath & Output Formatting

```bash
# Get a specific field with jsonpath
kubectl get pod my-pod -o jsonpath='{.status.podIP}'

# Get multiple fields
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'

# Get all container images
kubectl get pods -o jsonpath='{.items[*].spec.containers[*].image}'

# Use go-template output
kubectl get pods -o go-template='{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'

# Output as JSON piped to jq
kubectl get pods -o json | jq '.items[].metadata.name'
```

---

## RBAC

```bash
# List roles in a namespace
kubectl get roles

# List cluster roles
kubectl get clusterroles

# List role bindings
kubectl get rolebindings

# List cluster role bindings
kubectl get clusterrolebindings

# Check if you can perform an action
kubectl auth can-i get pods
kubectl auth can-i delete secrets --namespace=prod

# Check permissions for another user
kubectl auth can-i get pods --as=jane
kubectl auth can-i get pods --as=system:serviceaccount:default:my-sa

# Create a service account
kubectl create serviceaccount my-sa
```

---

## Useful Aliases

```bash
# Add to ~/.bashrc or ~/.zshrc
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kga='kubectl get all'
alias kaf='kubectl apply -f'
alias kdp='kubectl describe pod'
alias klf='kubectl logs -f'

# Enable kubectl autocomplete (bash)
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

# Enable autocomplete (zsh)
source <(kubectl completion zsh)
echo "[[ $commands[kubectl] ]] && source <(kubectl completion zsh)" >> ~/.zshrc
```

---

## Tips & Tricks

- Use `kubectl explain <resource>` to get documentation for any resource field, e.g., `kubectl explain pod.spec.containers`
- `kubectl get pods -A | grep -v Running` quickly finds non-Running pods across the cluster
- Use `-o yaml | kubectl apply -f -` to clone a resource: `kubectl get deployment my-app -o yaml | sed 's/my-app/my-app-clone/' | kubectl apply -f -`
- `kubectl delete pod <name> --grace-period=0 --force` force-deletes a stuck pod immediately
- `kubectl wait --for=condition=ready pod -l app=nginx --timeout=60s` waits for pods to be ready in scripts
- `kubectx` and `kubens` (community tools) make switching contexts and namespaces faster
- `k9s` is an excellent TUI dashboard for real-time cluster monitoring
- Add `--dry-run=client -o yaml` to any create command to generate YAML without applying it
- `kubectl get pods --field-selector=status.phase!=Running` finds all non-running pods

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
