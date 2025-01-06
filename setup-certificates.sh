openssl req -x509 \
    -newkey rsa:4096 -sha256 `# crypto algorithm` \
    -days 3650               `# valid for X days` \
    -nodes                   `# 'No DES' = don't protect private key with a password` \
    -keyout example.key      `# or .pem, private key file` \
    -out example.crt \       `# certificate file` \
    -subj "/CN=Example"      \
    -addext "subjectAltName=DNS:example.com,DNS:*.example.com,IP:10.0.0.1"  # List of valid addresses for this certficate
