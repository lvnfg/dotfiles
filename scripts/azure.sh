azDefaultRG="rgDev"

# -----------------------------------------------
# az nsg: Network Security Group
# -----------------------------------------------
nsgSourceIP=""
nsgAccessType=""
function azNSGUpdate() {
    az network nsg rule update              \
        -g $azDefaultRG                     \
        --nsg-name nsgDev                   \
        --name  van                         \
        --source-address-prefixes "$nsgSourceIP"     \
        --destination-address-prefix "*"    \
        --access "$nsgAccessType"
}
function azNSGOpenAll() {
    nsgSourceIP="*" 
    nsgAccessType="Allow" 
    azNSGUpdate
}
function azNSGOpenSingle() {
    nsgSourceIP="$(getPublicIP)" 
    nsgAccessType="Allow" 
    azNSGUpdate
}
function azNSGCloseAll() {
    nsgSourceIP="*"
    nsgAccessType="Deny"
    azNSGUpdate
}

# -----------------------------------------------
# az vm: Virtual Machine 
# -----------------------------------------------
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
