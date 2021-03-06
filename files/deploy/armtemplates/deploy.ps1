PARAM(
    $vnetRgName = "aks-poc-test",
    $rgName = "aks-poc-test-aks", 
    $nodesRGName = "aks-poc-test-nodes",
    $location = "eastus"
)
az group create -n $rgName -l $location

az group deployment create -n aks-deploy -g $vnetRgName --template-file vnet-existing.json  --parameters '@vnet-existing.parameters.json'

(Get-Content ./aks-cluster.parameters.json) -replace "##rgName##", $vnetRgName > aks-cluster.parameters.tempps.json
(Get-Content ./aks-cluster.parameters.tempps.json) -replace "##nodesRGName##", $nodesRGName > aks-cluster.parameters.tempps1.json

az group deployment create -n aks-deploy-cluster -g $rgName --template-file aks-cluster.json --parameter '@aks-cluster.parameters.tempps1.json'

Remove-Item aks-cluster.parameters.tempps*.json
