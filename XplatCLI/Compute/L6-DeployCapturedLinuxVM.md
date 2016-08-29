

Deploy a new VM from the captured image into exiting infrastructure
(Resource Group/VNET/Subnet/Availability Set/Storage Account)

#### Create a public IP:
azure network public-ip create -g TestRGcli -n TestIPcli2 -l westeurope -a Dynamic

#### Create the first network interface card (NIC):
azure network nic create -g TestRGcli -n Test-NIC12 -l westeurope --subnet-vnet-name TestVNetcli --subnet-name FrontEnd --public-ip-name TestIPcli2

#### Verify the NICs by using the JSON parser:
azure network nic show TestRGcli2 Test-NIC12 --json | jq '.'


azure vm create --resource-group TestRGcli --name TestVM1 --location westeurope --os-type Linux --image-urn https://computeteststorecli.blob.core.windows.net/system/Microsoft.Compute/Images/vhds/customubuntuimage-osDisk.af3a619a-d9de-4f3b-bacb-3f8a87bb6d80.vhd --vm-size Standard_A1 --admin-username yourusername --admin-password yourpassword  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX --availset-name TestAvailSetcli --nic-name Test-NIC12 --vnet-name TestVNetcli --vnet-subnet-name FrontEnd --storage-account-name computeteststorecli -vv


"https://computeteststorecli.blob.core.windows.net/system/Microsoft.Compute/Images/vhds/customubuntuimage-osDisk.af3a619a-d9de-4f3b-bacb-3f8a87bb6d80.vhd
