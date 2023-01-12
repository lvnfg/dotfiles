## Create AZURE VPN Gateway
- https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal

# SETUP AZURE VPN ON IOS USING LINUX CLI TOOLS - IPSEC/IKE

## Install dependencies
- Extra steps may be needed for Alpine. Google install strongswan on alpine linux.
- Remember to allow iSH to connect to local network to be able to connect to repo and install packages.
- Install strongswan:

    sudo apt install strongswan
    sudo apt install strongswan-pki
    sudo apt install libstrongswan-extra-plugins

## Generate client certificate
- Each user must have their own CA and client certificate. Do not save CA cert for reuse later since there is no protection on it.
- Define key names:

    export CA_KEY_NAME="ca_key.pem"
    export CA_CERT_NAME="ca_cert.pem"
    export CLIENT_USERNAME="van"
    export CLIENT_KEY_NAME="${CLIENT_USERNAME}_key.pem"
    export CLIENT_CERT_NAME="${CLIENT_USERNAME}_cert.pem"
    export CLIENT_BUNDLE_NAME="${CLIENT_USERNAME}.p12"

- Set client key password:

    export CLIENT_PASSWORD="" 

- Generate CA certificate:

    ipsec pki --gen --outform pem > "${CA_KEY_NAME}"
    ipsec pki --self --in "${CA_KEY_NAME}" --dn "CN=VPN CA" --ca --outform pem > "${CA_CERT_NAME}"
    # ----------------------
    # ipsec pki --gen --outform pem > caKey.pem
    # ipsec pki --self --in caKey.pem --dn "CN=VPN CA" --ca --outform pem > caCert.pem

- Print the CA certificate in base 64 format, which will need to be uploaded to Azure.

    openssl x509 -in "${CA_CERT_NAME}" -outform der | base64 -w0 ; echo

- Generate user certificate:

    ipsec pki --gen --outform pem > "${CLIENT_KEY_NAME}"
    ipsec pki --pub --in "${CLIENT_KEY_NAME}" | ipsec pki --issue --cacert "${CA_CERT_NAME}" --cakey "${CA_KEY_NAME}" --dn "CN=${CLIENT_USERNAME}" --san "${CLIENT_USERNAME}" --flag clientAuth --outform pem > "${CLIENT_CERT_NAME}"
    # ----------------------
    # ipsec pki --gen --outform pem > "${USERNAME}Key.pem"
    # ipsec pki --pub --in "${USERNAME}Key.pem" | ipsec pki --issue --cacert caCert.pem --cakey caKey.pem --dn "CN=${USERNAME}" --san "${USERNAME}" --flag clientAuth --outform pem > "${USERNAME}Cert.pem"

- Generate a p12 bundle containing the user certificate:

    openssl pkcs12 -in "${CLIENT_CERT_NAME}" -inkey "${CLIENT_KEY_NAME}" -certfile "${CA_CERT_NAME}" -export -out "${CLIENT_BUNDLE_NAME}" -password "pass:${CLIENT_PASSWORD}"
    # ----------------------
    # openssl pkcs12 -in "${USERNAME}Cert.pem" -inkey "${USERNAME}Key.pem" -certfile caCert.pem -export -out "${USERNAME}.p12" -password "pass:${PASSWORD}"

- Export generated certificate files out of iSH

## Generate VPN client configuration file

## Delete all generated files for security


# SETUP AZURE VPN ON MACOS USING KEYCHAIN

## Create a self-signed root certificate authority
- Open keychain access
- In menu bar: Keychain Access > Certificate Assistant > Create a Certificate Authority
- Name: any
- Identity Type: Self Signed Root CA
- User Certificate: VPN Server
- Create

## Create the client certificate
- Open keychain access > Create a certificate:
	- Name: any
	- Identity type: Leaf
	- Certificate type: VPN client
	- Create
- Select the root certificate created earlier

## Export the root certificate's public key
- Open keychain access
- Open certificates tab
- Select the root certificate
- Right click > Export [cert name]
- File format: Certificate (.cer)
- Save
- Convert the certificate to base64:
	- Open a terminal tab and run:
	- openssl base64 -in <infile> -out <outfile>
- Open the new cert in a text editor and replace all linebreaks to get 1 continous line:
	- In vim : %s/\n//g
- Copy the edited text

## Create VPN configuration
- Download the Azure VPN P2S client config site:
	- Gateway resource > Point-to-site configureation > Download VPN client
- Extract the zip file and open the Generic folder (for macos)
- Double click on the .cer file to add to keychain (probably doesn't matter)
- Open the .xml file in preview and copy the url between <VpnServer> tags:
	- Ex: azuregateway-11fc0062-1773-4d1c-9b60-72706ded574e-3ada87e0fd39.vpn.azure.com
- Open System Preferences > Network
- New network interface (+ button):
	- Interface: VPN
	- VPN Type: IKEv2
	- Service Name: any
	- Create
- Server address: <VpnServer>
- Remote ID: <VpnServer>
- Local ID: any
- Authentication Settings:
	- Authentication settings: None
	- Certificate > Select > Select the leaf certificate created earlier
	- Ok
- Apply
- Connect
# -----------------------------------------------------------------------------------------------------------
