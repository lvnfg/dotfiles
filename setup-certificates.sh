# ------------------------------------------------------------------------
# GENERATE CERTIFICATES
# ------------------------------------------------------------------------
# Breaking command into multiple lines in Dockerfile
# may cause docker to ignore some lines and build may
# fail. Don't know why yet.
openssl req -x509 \
    -newkey rsa:4096 -sha256 `# crypto algorithm` \
    -days 3650               `# valid for X days` \
    -nodes                   `# 'No DES' = don't protect private key with a password` \
    -keyout example.key      `# or .pem, private key file` \
    -out example.crt \       `# or .pem, certificate file` \
    -subj "/CN=example.com"  \
    -addext "subjectAltName=DNS:example.com,DNS:*.example.com,IP:10.0.0.1"  # List of valid addresses for this certficate

# ------------------------------------------------------------------------
# IOS - TRUST CERTIFICATES
# ------------------------------------------------------------------------
# Download the .cer file
# Double click to import profile
# Go to Settings > General > VPN & Device Management
#   -> Click on the profile to open
#   -> Click install
# Go to Settings > General > About > Certificate Trust Settings (at the botton of About)
#   -> Turn on full trust for the install certificate profile
# Done

# ------------------------------------------------------------------------
# MACOS - TRUST CERTIFICATES
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
# WINDOWS - TRUST CERTIFICATES
# ------------------------------------------------------------------------
