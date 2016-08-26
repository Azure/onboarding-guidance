

#### To login to your Azure Subscription
azure login

#### List all the accounts that you have access .
azure account list

#### Set default account for the session
azure account set XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX

#### Verify Is Default options is true
azure account show

#### Change Mode to arm
azure config mode arm


#### To see Location that can be accessed in your current subscriptions

```shell
azure location list

or

azure location list  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX
```
### Prerequisite - Quick Create

1. ResourceGroup
2. SSH Client - for testing purpose


#### Verify available  virtual machine sizes available in the location
```shell
azure vm sizes -l westus

: <<'OUTPUT'
info:    Executing command vm sizes
+ Listing virtual machine sizes available in the location "westus"
data:    Name              CPU Cores  Memory (MB)  Max data-disks  Max data-disk Size (MB)  Max OS-disk Size (MB)
data:    ----------------  ---------  -----------  --------------  -----------------------  ---------------------
data:    Standard_A0       1          768          1               20480                    1047552
data:    Standard_A1       1          1792         2               71680                    1047552
data:    Standard_A2       2          3584         4               138240                   1047552
data:    Standard_A3       4          7168         8               291840                   1047552
data:    Standard_A5       2          14336        4               138240                   1047552
data:    Standard_A4       8          14336        16              619520                   1047552
data:    Standard_A6       4          28672        8               291840                   1047552
data:    Standard_A7       8          57344        16              619520                   1047552
data:    Basic_A0          1          768          1               20480                    1047552
data:    Basic_A1          1          1792         2               40960                    1047552
data:    Basic_A2          2          3584         4               61440                    1047552
data:    Basic_A3          4          7168         8               122880                   1047552
data:    Basic_A4          8          14336        16              245760                   1047552
data:    Standard_D1_v2    1          3584         2               51200                    1047552
data:    Standard_D2_v2    2          7168         4               102400                   1047552
data:    Standard_D3_v2    4          14336        8               204800                   1047552
data:    Standard_D4_v2    8          28672        16              409600                   1047552
data:    Standard_D5_v2    16         57344        32              819200                   1047552
data:    Standard_D11_v2   2          14336        4               102400                   1047552
data:    Standard_D12_v2   4          28672        8               204800                   1047552
data:    Standard_D13_v2   8          57344        16              409600                   1047552
data:    Standard_D14_v2   16         114688       32              819200                   1047552
data:    Standard_D15_v2   20         143360       40              286720                   1047552
data:    Standard_F1       1          2048         2               16384                    1047552
data:    Standard_F2       2          4096         4               32768                    1047552
data:    Standard_F4       4          8192         8               65536                    1047552
data:    Standard_F8       8          16384        16              131072                   1047552
data:    Standard_F16      16         32768        32              262144                   1047552
data:    Standard_DS1_v2   1          3584         2               7168                     1047552
data:    Standard_DS2_v2   2          7168         4               14336                    1047552
data:    Standard_DS3_v2   4          14336        8               28672                    1047552
data:    Standard_DS4_v2   8          28672        16              57344                    1047552
data:    Standard_DS5_v2   16         57344        32              114688                   1047552
data:    Standard_DS11_v2  2          14336        4               28672                    1047552
data:    Standard_DS12_v2  4          28672        8               57344                    1047552
data:    Standard_DS13_v2  8          57344        16              114688                   1047552
data:    Standard_DS14_v2  16         114688       32              229376                   1047552
data:    Standard_DS15_v2  20         143360       40              286720                   1047552
data:    Standard_F1s      1          2048         2               4096                     1047552
data:    Standard_F2s      2          4096         4               8192                     1047552
data:    Standard_F4s      4          8192         8               16384                    1047552
data:    Standard_F8s      8          16384        16              32768                    1047552
data:    Standard_F16s     16         32768        32              65536                    1047552
data:    Standard_DS1      1          3584         2               7168                     1047552
data:    Standard_DS2      2          7168         4               14336                    1047552
data:    Standard_DS3      4          14336        8               28672                    1047552
data:    Standard_DS4      8          28672        16              57344                    1047552
data:    Standard_DS11     2          14336        4               28672                    1047552
data:    Standard_DS12     4          28672        8               57344                    1047552
data:    Standard_DS13     8          57344        16              114688                   1047552
data:    Standard_DS14     16         114688       32              229376                   1047552
data:    Standard_D1       1          3584         2               51200                    1047552
data:    Standard_D2       2          7168         4               102400                   1047552
data:    Standard_D3       4          14336        8               204800                   1047552
data:    Standard_D4       8          28672        16              409600                   1047552
data:    Standard_D11      2          14336        4               102400                   1047552
data:    Standard_D12      4          28672        8               204800                   1047552
data:    Standard_D13      8          57344        16              409600                   1047552
data:    Standard_D14      16         114688       32              819200                   1047552
data:    Standard_G1       2          28672        4               393216                   1047552
data:    Standard_G2       4          57344        8               786432                   1047552
data:    Standard_G3       8          114688       16              1572864                  1047552
data:    Standard_G4       16         229376       32              3145728                  1047552
data:    Standard_G5       32         458752       64              6291456                  1047552
data:    Standard_GS1      2          28672        4               57344                    1047552
data:    Standard_GS2      4          57344        8               114688                   1047552
data:    Standard_GS3      8          114688       16              229376                   1047552
data:    Standard_GS4      16         229376       32              458752                   1047552
data:    Standard_GS5      32         458752       64              917504                   1047552
data:    Standard_A8       8          57344        16              391168                   1047552
data:    Standard_A9       16         114688       16              391168                   1047552
data:    Standard_A10      8          57344        16              391168                   1047552
data:    Standard_A11      16         114688       16              391168                   1047552
info:    vm sizes command OK
OUTPUT
```
## Create a virtual machine with default resources in a resource group (Quick-Create)

azure vm quick-create --resource-group <> --name <> --location <> --os-type <> --image-urn <> --vm-size <> --admin-username <> --admin-password <>  --subscription <>

Linux VM using Command Line Interface

```shell
azure vm quick-create --resource-group testRG2 --name ubuntuvm --location westus --os-type Linux --image-urn Canonical:UbuntuServer:16.04.0-LTS:latest --vm-size Standard_A0 --admin-username yourusername --admin-password yourpassword  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX -v

or

azure vm quick-create --resource-group testRG2 --name ubuntuvm --location westus --os-type Linux --image-urn Canonical:UbuntuServer:16.04.0-LTS:16.04.201608150 --vm-size Standard_A0 --admin-username yourusername --admin-password yourpassword  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX -v


: <<'OUTPUT'
info:    Executing command vm quick-create
verbose: Looking up the VM "ubuntuvm"
info:    Using the VM Size "Standard_A0"
info:    The [OS, Data] Disk or image configuration requires storage account
verbose: Looking up the storage account cli20027769511914829906
info:    Could not find the storage account "cli20027769511914829906", trying to create new one
verbose: Creating storage account "cli20027769511914829906" in "westus"
verbose: Looking up the storage account cli20027769511914829906
verbose: Looking up the NIC "ubunt-westu-2002776951-nic"
info:    An nic with given name "ubunt-westu-2002776951-nic" not found, creating a new one
verbose: Looking up the virtual network "ubunt-westu-2002776951-vnet"
info:    Preparing to create new virtual network and subnet
verbose: Creating a new virtual network "ubunt-westu-2002776951-vnet" [address prefix: "10.0.0.0/16"] with subnet "ubunt-westu-2002776951-snet" [address prefix: "10.0.1.0/24"]
verbose: Looking up the virtual network "ubunt-westu-2002776951-vnet"
verbose: Looking up the subnet "ubunt-westu-2002776951-snet" under the virtual network "ubunt-westu-2002776951-vnet"
info:    Found public ip parameters, trying to setup PublicIP profile
verbose: Looking up the public ip "ubunt-westu-2002776951-pip"
info:    PublicIP with given name "ubunt-westu-2002776951-pip" not found, creating a new one
verbose: Creating public ip "ubunt-westu-2002776951-pip"
verbose: Looking up the public ip "ubunt-westu-2002776951-pip"
verbose: Creating NIC "ubunt-westu-2002776951-nic"
verbose: Looking up the NIC "ubunt-westu-2002776951-nic"
verbose: Creating VM "ubuntuvm"
verbose: Looking up the VM "ubuntuvm"
verbose: Looking up the NIC "ubunt-westu-2002776951-nic"
verbose: Looking up the public ip "ubunt-westu-2002776951-pip"
data:    Id                              :/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/testRG2/providers/Microsoft.Compute/virtualMachines/ubuntuvm
data:    ProvisioningState               :Succeeded
data:    Name                            :ubuntuvm
data:    Location                        :westus
data:    Type                            :Microsoft.Compute/virtualMachines
data:
data:    Hardware Profile:
data:      Size                          :Standard_A0
data:
data:    Storage Profile:
data:      Image reference:
data:        Publisher                   :Canonical
data:        Offer                       :UbuntuServer
data:        Sku                         :14.04.4-LTS
data:        Version                     :latest
data:
data:      OS Disk:
data:        OSType                      :Linux
data:        Name                        :cli05fdbbcc02514230-os-1471618454902
data:        Caching                     :ReadWrite
data:        CreateOption                :FromImage
data:        Vhd:
data:          Uri                       :https://cli20027769511914829906.blob.core.windows.net/vhds/cli05fdbbcc02514230-os-1471618454902.vhd
data:
data:    OS Profile:
data:      Computer Name                 :ubuntuvm
data:      User Name                     :yourusername
data:      Linux Configuration:
data:        Disable Password Auth       :false
data:
data:    Network Profile:
data:      Network Interfaces:
data:        Network Interface #1:
data:          Primary                   :true
data:          MAC Address               :00-0D-3A-31-25-25
data:          Provisioning State        :Succeeded
data:          Name                      :ubunt-westu-2002776951-nic
data:          Location                  :westus
data:            Public IP address       :52.160.108.119
data:            FQDN                    :ubunt-westu-2002776951-pip.westus.cloudapp.azure.com
data:
data:    Diagnostics Profile:
data:      BootDiagnostics Enabled       :true
data:      BootDiagnostics StorageUri    :https://cli20027769511914829906.blob.core.windows.net/
data:
data:      Diagnostics Instance View:
info:    vm quick-create command OK
OUTPUT
```

Windows VM using Command Line Interface

```shell
azure vm quick-create --resource-group testRG2 --name windows2012r2vm --location westus --os-type Windows --image-urn MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:latest --vm-size Standard_A0 --admin-username yourusername --admin-password yourpassword  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX -v

: <<'OUTPUT'
info:    Executing command vm quick-create
verbose: Looking up the VM "windows2012r2vm"
info:    Using the VM Size "Standard_A0"
info:    The [OS, Data] Disk or image configuration requires storage account
verbose: Looking up the storage account cli15666754291914829906
info:    Could not find the storage account "cli15666754291914829906", trying to create new one
verbose: Creating storage account "cli15666754291914829906" in "westus"
verbose: Looking up the storage account cli15666754291914829906
verbose: Looking up the NIC "windo-westu-1566675429-nic"
info:    An nic with given name "windo-westu-1566675429-nic" not found, creating a new one
verbose: Looking up the virtual network "windo-westu-1566675429-vnet"
info:    Preparing to create new virtual network and subnet
verbose: Creating a new virtual network "windo-westu-1566675429-vnet" [address prefix: "10.0.0.0/16"] with subnet "windo-westu-1566675429-snet" [address prefix: "10.0.1.0/24"]
verbose: Looking up the virtual network "windo-westu-1566675429-vnet"
verbose: Looking up the subnet "windo-westu-1566675429-snet" under the virtual network "windo-westu-1566675429-vnet"
info:    Found public ip parameters, trying to setup PublicIP profile
verbose: Looking up the public ip "windo-westu-1566675429-pip"
info:    PublicIP with given name "windo-westu-1566675429-pip" not found, creating a new one
verbose: Creating public ip "windo-westu-1566675429-pip"
verbose: Looking up the public ip "windo-westu-1566675429-pip"
verbose: Creating NIC "windo-westu-1566675429-nic"
verbose: Looking up the NIC "windo-westu-1566675429-nic"
verbose: Creating VM "windows2012r2vm"
verbose: Looking up the VM "windows2012r2vm"
verbose: Looking up the NIC "windo-westu-1566675429-nic"
verbose: Looking up the public ip "windo-westu-1566675429-pip"
data:    Id                              :/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/testRG2/providers/Microsoft.Compute/virtualMachines/windows2012r2vm
data:    ProvisioningState               :Succeeded
data:    Name                            :windows2012r2vm
data:    Location                        :westus
data:    Type                            :Microsoft.Compute/virtualMachines
data:
data:    Hardware Profile:
data:      Size                          :Standard_A0
data:
data:    Storage Profile:
data:      Image reference:
data:        Publisher                   :MicrosoftWindowsServer
data:        Offer                       :WindowsServer
data:        Sku                         :2012-R2-Datacenter
data:        Version                     :latest
data:
data:      OS Disk:
data:        OSType                      :Windows
data:        Name                        :cli6e30ab4e8b0bedd2-os-1471619103622
data:        Caching                     :ReadWrite
data:        CreateOption                :FromImage
data:        Vhd:
data:          Uri                       :https://cli15666754291914829906.blob.core.windows.net/vhds/cli6e30ab4e8b0bedd2-os-1471619103622.vhd
data:
data:    OS Profile:
data:      Computer Name                 :windows2012r2vm
data:      User Name                     :yourusername
data:      Windows Configuration:
data:        Provision VM Agent          :true
data:        Enable automatic updates    :true
data:
data:    Network Profile:
data:      Network Interfaces:
data:        Network Interface #1:
data:          Primary                   :true
data:          MAC Address               :00-0D-3A-34-41-08
data:          Provisioning State        :Succeeded
data:          Name                      :windo-westu-1566675429-nic
data:          Location                  :westus
data:            Public IP address       :13.88.178.237
data:            FQDN                    :windo-westu-1566675429-pip.westus.cloudapp.azure.com
data:
data:    Diagnostics Profile:
data:      BootDiagnostics Enabled       :true
data:      BootDiagnostics StorageUri    :https://cli15666754291914829906.blob.core.windows.net/
data:
data:      Diagnostics Instance View:
info:    vm quick-create command OK
OUTPUT
```


# Detailed VM Creation :

#### Create the resource group:
azure group create TestRGcli -l westeurope
#### Verify the resource group
azure group show TestRGcli --json

#### Create two storage account: one for OS VHD and another one for BootDiagnostics

#### Check availability of the storage account:
azure storage account check computeteststorecli
#### Create the storage account:
azure storage account create computeteststorecli -g TestRGcli -l westeurope --kind Storage --sku-name LRS -v

#### Verify the storage account
azure storage account show -g TestRGcli computeteststorecli --json

(Optional)
#### List storage account keys
azure storage account keys list computeteststorecli --resource-group TestRGcli
#### Create a storage container
azure storage container create --account-name computeteststorecli --account-key <Key1> --container vmdisks



#### Create the virtual network:
azure network vnet create -g TestRGcli -n TestVNetcli -a 192.168.0.0/16 -l westeurope
#### Create the subnet:
azure network vnet subnet create -g TestRGcli -e TestVNetcli -n FrontEnd -a 192.168.1.0/24
#### Verify the virtual network and subnet
azure network vnet show TestRGcli TestVNetcli --json


#### Create a public IP:
azure network public-ip create -g TestRGcli -n TestIPcli -l westeurope -a Dynamic
#### Create the first network interface card (NIC):
azure network nic create -g TestRGcli -n Test-NIC1 -l westeurope --subnet-vnet-name TestVNetcli --subnet-name FrontEnd --public-ip-name TestIPcli
#### Verify the NICs by using the JSON parser:
azure network nic show TestRGcli Test-NIC1 --json

#### Create the availability set:
azure availset create -g TestRGcli -n TestAvailSetcli -l westeurope

#### Create the first Linux VM:
```

azure vm create --resource-group TestRGcli --name TestVM1 --location westeurope --os-type Linux --image-urn Canonical:UbuntuServer:16.04.0-LTS:latest --vm-size Standard_A0 --admin-username yourusername --admin-password yourpassword  --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX --availset-name TestAvailSetcli --nic-name Test-NIC1 --vnet-name TestVNetcli --vnet-subnet-name FrontEnd --storage-account-name computeteststorecli  --os-disk-vhd https://computeteststorecli.blob.core.windows.net/vmdisks/testvm3-os-disk.vhd --boot-diagnostics-storage-uri https://cli3bcbbc495e4e342d14718.blob.core.windows.net/ -v


azure vm create -g TestRGcli -n TestVM1 -l westeurope -y Linux -Q Canonical:UbuntuServer:16.04.0-LTS:latest -z Standard_A0 -u abhanand -p Abhi$495712  -s XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX -r TestAvailSetcli -f Test-NIC1 -F TestVNetcli -j FrontEnd -o computeteststorecli  -d https://computeteststorecli.blob.core.windows.net/vmdisks/testvm3-os-disk.vhd --boot-diagnostics-storage-uri https://cli3bcbbc495e4e342d14718.blob.core.windows.net/ -v

```
