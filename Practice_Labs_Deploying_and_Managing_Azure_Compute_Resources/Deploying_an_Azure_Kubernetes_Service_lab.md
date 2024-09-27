# Task 1: Register the required resource providers for your subscription
1. Search for Subscriptions in the portal search bar.
2. Click Subscriptions.
3. Click your subscription name.
4. Scroll down the menu on the left and click Resource providers under the Settings context.
5. Search for Kubernetes
6. Register both Microsoft.Kubernetes and Microsoft.Kubernetes.Configuration

# Task 2: Deploy an Azure Kubernetes Service cluster
1. Search Kubernetes services in the portal search bar.
2. Click Kubernetes services.
3. Click the Create dropdown and click Create a Kubernetes cluster.
4. Create a new Resource group and name it az104-09c-rg1
5. Scroll down and enter the Kubernetes cluster name as az104-9c-aks1.
6. Change availability zones to None.
7. Scroll down and select Manual as the Scale method.
8. Change the Node count to 1.
9. Click Next: Node pools >. Review.
10. Click Next: Access >. Review.
11. Click Next: Networking >. Review.
12. Enter a DNS name prefix such as samplecluster683331.
13. Click Next: Integrations. 
14. For Container montioring, select Disabled. 
15. Click Review + create.
16. Click Create.

# Task 3: Deploy a pod into the Azure Kubernetes Service Cluster
1. Click Go to resource at the bottom of your depoyment screen.
2. From the left menu under the Settings context, click Node pools.
3. Click the Cloud Shell button.
4. Click the PowerShell dropdown and select Bash.
5. When given the Switch to Bash in Cloud Shell prompt, click Confirm.
6. Click in the window and enter the following (press Enter after each line):
    * RESOURCE_GROUP='az104-09c-rg1'. 
    * AKS_CLUSTER='az104-9c-aks1'
    * az aks get-credentials --resource-group $RESOURCEGROUP --name $AKS_CLUSTER
    * kubectl get nodes
    * kubectl create deployment nginx-deployment --image=nginx
    * kubectl get pods
    * kubectl get deployment
    * kubectl expose deployment nginx-deployment --port=80 --type=LoadBalancer
    * kubectl get service
7. Browse to your container app site and confirm all working.

# Task 4: 
1. Enter the following commands and press enter:
    * kubectl scale --replicas=2 deployment/nginx-deployment
    * kubectl get pods
2. Navigate back to the Azure portal and then to your Kubernetes resource.
3. From the left hand menu click, Overview from the left hand menu, and click Scale node pool from the Node pool blade.
4. From the Scale node pool popup screen, leave Scale method as Manual, Node count as 1 and click Apply.
5. Once the node pool has been successfully created, click the Cloud Shell button at the top of your portal screen.
6. Enter the following lines and press enter after each:
    * Az aks scale –resource-group $RESOURCE_GROUP –name $AKS_CLUSTER –-node-count 2
    * kubectl get nodes
    * kubectl scale –replicas=10 deployment/nginx-deployment deployment.apps/nginx-deployment scaled
    * kubectl get pods
    * kubectl get pod -o=custom-columns=NODE:.spec.nodeName,POD:.metadata.name

# Task 5: 
1.	Execute the following code by entering it in the Cloud Shell and pressing enter:
    * Kubectl delete deployment nginx-deployment
2.	Click the cross at the top of the Cloud Shell to exit the shell. 
