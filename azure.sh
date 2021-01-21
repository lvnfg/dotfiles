currentIP=""

# -----------------------------------------------
# Personal access
# -----------------------------------------------
function openCurrentIP() {
    currentIP="$(getPublicIP)" 
    echo "$currentIP"
    # -----------
    azRG="rgDev"
    azNSGName="nsgdev"
    azNSGRuleName="van"
    azNSGAccessType="allow"
    azNSGSourceAddressPrefix="$currentIP"
    azNSGDestinationAddressPrefix="*"
    azNSGUpdate
    # -----------
    azRG="rgHQ"
    azSQLServer="phuongphatgroup"
    azSQLServerFirewallRuleName="van"
    azSQLServerFirewallRuleStartIPAddress="$currentIP"
    azSQLServerFirewallRuleEndIPAddress="$currentIP"
    azSQLServerFirewallUpdate
}
function openAllIP() {
    currentIP="$(getPublicIP)" 
    echo "$thisIP"
    # -----------
    azRG="rgDev"
    azNSGName="nsgdev"
    azNSGRuleName="van"
    azNSGAccessType="allow"
    azNSGSourceAddressPrefix="*"
    azNSGDestinationAddressPrefix="*"
    azNSGUpdate
    # -----------
    azRG="rgHQ"
    azSQLServer="phuongphatgroup"
    azSQLServerFirewallRuleName="van"
    azSQLServerFirewallRuleStartIPAddress="$currentIP"
    azSQLServerFirewallRuleEndIPAddress="$currentIP"
    azSQLServerFirewallUpdate
}
function closeAllAccess() {
    azRG="rgDev"
    azNSGName="nsgdev"
    azNSGRuleName="van"
    azNSGAccessType="deny"
    azNSGSourceAddressPrefix="*"
    azNSGDestinationAddressPrefix="*"
    azNSGUpdate
    # -----------
    azRG="rgHQ"
    azSQLServer="phuongphatgroup"
    azSQLServerFirewallRuleName="van"
    azSQLServerFirewallRuleStartIPAddress="0.0.0.0"
    azSQLServerFirewallRuleEndIPAddress="0.0.0.0"
    azSQLServerFirewallUpdate
}

# -----------------------------------------------
# az nsg: Network Security Group
# -----------------------------------------------
azNSGName=""
azNSGRuleName=""
azNSGAccessType=""
azNSGSourceAddressPrefix=""
azNSGDestinationAddressPrefix=""
function azNSGUpdate() {
    echo "Updating nsg rule"
    az network nsg rule update                  \
        --resource-group    $azRG               \
        --nsg-name          $azNSGName          \
        --name              $azNSGRuleName      \
        --access            $azNSGAccessType    \
        --source-address-prefixes       "$azNSGSourceAddressPrefix"         \
        --destination-address-prefix    "$azNSGDestinationAddressPrefix"    
}

# -----------------------------------------------
# az vm: Virtual Machine 
# -----------------------------------------------
function azVMDev() {
    vmName="dev-vm"
    if [[ "$1" = create ]]; then
        az vm create                        \
            --resource-group    $azRG       \
            --name $vmName                  \
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

# -----------------------------------------------
# az sql sever 
# -----------------------------------------------
azSQLServer=""
azSQLServerFirewallRuleName=""
azSQLServerFirewallRuleStartIPAddress=""
azSQLServerFirewallRuleEndIPAddress=""
function azSQLServerFirewallUpdate() {
    echo "Updating sql server firewall rule"
    az sql server firewall-rule update      \
        --resource-group        $azRG                                   \
        --server                $azSQLServer                            \
        --name                  $azSQLServerFirewallRuleName            \
        --start-ip-address      $azSQLServerFirewallRuleStartIPAddress  \
        --end-ip-address        $azSQLServerFirewallRuleEndIPAddress    
}
