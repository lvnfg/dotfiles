# Setup Azure VPN

## Create VPN Gateway
- https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal

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
