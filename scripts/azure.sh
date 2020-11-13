azDefaultRG="rg-dev"

function aznsg() {
    if [[ "$1" = open ]]; then
        ip="$(getPublicIP)" 
        accessType="Allow" 
    elif [[ "$1" = openall ]]; then
        ip="*" 
        accessType="Allow" 
    else
        ip="*"
        accessType="Deny"
    fi
    az network nsg rule update              \
        -g rg-dev                           \
        --nsg-name dev-nsg                  \
        --name  van                         \
        --source-address-prefixes "$ip"     \
        --destination-address-prefix "*"    \
        --access "$accessType"
}

function azVMDev() {
    vmName="dev-vm"
    if [[ "$1" = create ]]; then
        az vm create                        \
            -n $vmName                      \
            -g $azDefaultRG                 \ 
            --location southeastasia        \
            --accelerated-networking true   \
            --vnet-name dev-vnet            \
            --nsg dev-nsg                   \
            --subnet default                \
            --public-ip-address dev-vm-ip   \
            --storage-sku Premium_LRS       \
            --size Standard_F8s_v2          \
            --admin-username van            \
            --ssh-key-values $HOME/.ssh/id_rsa.pub  \
            --image debian:debian-10:10-gen2:latest                          
    fi
}
