# Create AZURE VPN Gateway:
# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal

# -------------------------------------------------------------------------
# NOTE
# -------------------------------------------------------------------------
# On iOS IKEv2 vpn will disconnect after ~22 minutes (used to be ~minutes).
# Possible reasons discussed here:
#    https://github.com/libreswan/libreswan/issues/222
#    In short, seems to be VPN created by the GUI dones't support PFS, but
#    Azure VPN server does, so on rekeying the VPN fails. Can work around by:
#      - Disable PFS on Azure VPN > tried but VPN fails to connect when using
#        any custom P2S settings, not just PFA
#      - Enable PFS using .mobileconfig profile
# Solutions:
#  - See if can live with the bug > simplest
#  - Configure the server to disable PFS > may not be possible with Azure VPN
#  - Create custom .mobileconfig profile > most complicated but can potentially
#    resolv4 all issues, plus enable always-on / on demand VPN. Done once, use always.

# -------------------------------------------------------------------------
# SETUP AZURE VPN ON IOS USING iSH ALPINE LINUX - IPSEC/IKE
# -------------------------------------------------------------------------

# Install strongswan on iSH - Alpine linux
# Remember to allow iSH to connect to local network to be able to connect to repo and install packages.
    apk add strongswan
    apk add strongswan-pki
    apk add libstrongswan-extra-plugins

# Define certificate file names:
    export CA_KEY_NAME="ca_key.pem"
    export CA_CERT_NAME="ca_cert.pem"
    export CLIENT_USERNAME="vanipad"
    export CLIENT_KEY_NAME="${CLIENT_USERNAME}_key.pem"
    export CLIENT_CERT_NAME="${CLIENT_USERNAME}_cert.pem"
    export CLIENT_BUNDLE_NAME="${CLIENT_USERNAME}.p12"

# Set client key password:
    export CLIENT_PASSWORD=""

# Generate CA certificate:
    ipsec pki --gen --outform pem > "${CA_KEY_NAME}"
    ipsec pki --self --in "${CA_KEY_NAME}" --dn "CN=VPN CA" --ca --outform pem > "${CA_CERT_NAME}"
    # ----------------------
    # ipsec pki --gen --outform pem > caKey.pem
    # ipsec pki --self --in caKey.pem --dn "CN=VPN CA" --ca --outform pem > caCert.pem

# Print the CA certificate in base 64 format, which will need to be uploaded to Azure.
    openssl x509 -in "${CA_CERT_NAME}" -outform der | base64 -w0 ; echo

# Generate user certificate:
    ipsec pki --gen --outform pem > "${CLIENT_KEY_NAME}"
    ipsec pki --pub --in "${CLIENT_KEY_NAME}" | ipsec pki --issue --cacert "${CA_CERT_NAME}" --cakey "${CA_KEY_NAME}" --dn "CN=${CLIENT_USERNAME}" --san "${CLIENT_USERNAME}" --flag clientAuth --outform pem > "${CLIENT_CERT_NAME}"
    # ----------------------
    # ipsec pki --gen --outform pem > "${USERNAME}Key.pem"
    # ipsec pki --pub --in "${USERNAME}Key.pem" | ipsec pki --issue --cacert caCert.pem --cakey caKey.pem --dn "CN=${USERNAME}" --san "${USERNAME}" --flag clientAuth --outform pem > "${USERNAME}Cert.pem"

# Generate a p12 bundle containing the user certificate:
    openssl pkcs12 -in "${CLIENT_CERT_NAME}" -inkey "${CLIENT_KEY_NAME}" -certfile "${CA_CERT_NAME}" -export -out "${CLIENT_BUNDLE_NAME}" -password "pass:${CLIENT_PASSWORD}"
    # ----------------------
    # openssl pkcs12 -in "${USERNAME}Cert.pem" -inkey "${USERNAME}Key.pem" -certfile caCert.pem -export -out "${USERNAME}.p12" -password "pass:${PASSWORD}"

# Install the p12 bundle profiel on iOS
#   - Export generated certificate files out of iSH using files provider
#   - Double click on the p12 bundle to install
#   - Delete all root and client files

# Configure the gateway
#   - In the Azure portal, go to the virtual network gateway
#   - On the virtual network gateway page, select Point-to-site configuration to open the Point-to-site configuration page
#   - The default advertised routes are 10.1.0.0/16, 192.168.0.0/24 for non-windows clients.
#   -   https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-point-to-site-routing
#   - Add any additional routes need to be advertised before continuing using the box "Additional routes to advertise" at the bottom

# Generate VPN configuration file
#   - At the top of the Point-to-site configuration page, select Download VPN client.
#   - Once the configuration package has been generated, your browser indicates that
#     a client configuration zip file is available. It's named the same name as your
#     gateway.
#   - Unzip the file to view the folders.
#   - Open the Generic folder:
#       - VpnServerRoot.cer: click on this file to import configuration profile to iOS
#       - VpnSettings.xml: open the file and note the value between <VpnServer> tags
#           - <VpnServer>azuregateway-11fc0062-1773-4d1c-9b60-72706ded574e-3ada87e0fd39.vpn.azure.com</VpnServer>
#   - Delete all downloaded files

# Configure VPN connection
#   - Go to Settings > General > VPN & Device Management > VPN > Add VPN Configuration
#   - Set the following:
#       - Type: IKEv2
#       - Description: <VPNServer>
#       - Server: <VpnServer>
#       - Remote ID: <VpnServer>
#       - Local ID: [azure_vpn]
#   - Set authentication method:
#       - User Authentication: None
#       - Use certificate: Yes
#       - Certificate: select the imported p12 certificate bundle

# -------------------------------------------------------------------------
# SETUP AZURE VPN ON MACOS USING KEYCHAIN - IPSEC/IKE
# -------------------------------------------------------------------------
# Create a self-signed root certificate authority
#   - Open keychain access
#   - In menu bar: Keychain Access > Certificate Assistant > Create a Certificate Authority
#       - Name: any
#       - Identity Type: Self Signed Root CA
#       - User Certificate: VPN Server
#       - Check "Let me override defaults"
#          - Set "Validity period (days)" as needed
#          - Continue all other screens as needed
#       - Create

# Create the client certificate
#   - Open keychain access > Create a certificate:
#       - Name: any
#       - Identity type: Leaf
#       - Certificate type: VPN client
#       - Create
#   - Select the root certificate created earlier

# Export the root certificate's public key
#   - Open keychain access
#   - Open certificates tab
#   - Select the root certificate
#   - Right click > Export [cert name]
#   - File format: Certificate (.cer)
#   - Save
#   - Convert the certificate to base64:
#       - Open a terminal tab and run:
#   	- openssl base64 -in <infile> -out <outfile>
#   - Open the new cert in a text editor and replace all linebreaks to get 1 continous line:
#       - Can open with vi ~/<filename> on macos
#   	- In vim : %s/\n//g
#   - Copy the edited text

# Create VPN configuration
#   - Download the Azure VPN P2S client config site:
#   	- Gateway resource > Point-to-site configureation > Download VPN client
#   - Extract the zip file and open the Generic folder (for macos)
#   - Open the .xml file in preview and copy the url between <VpnServer> tags:
#   	- Ex: azuregateway-11fc0062-1773-4d1c-9b60-72706ded574e-3ada87e0fd39.vpn.azure.com
#   - Open System Preferences > Network
#   - New network interface (+ button):
#   	- Interface: VPN
#   	- VPN Type: IKEv2
#   	- Service Name: any
#   	- Create
#   - Server address: <VpnServer>
#   - Remote ID: <VpnServer>
#   - Local ID: <certificate_name>
#   - Authentication Settings:
#   	- Authentication settings: Certificate
#   	- Certificate > Select > Select the leaf certificate created earlier
#   	- Ok
#   - Apply
#   - Connect
