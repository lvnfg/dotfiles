openssl req -x509 \
    -newkey rsa:4096 -sha256 \  # crypto algorithm
    -days 3650 \                # valid for X days
    -nodes \                    # 'No DES' = don't protect private key with a password
    -keyout example.com.key \   # private key file
    -out example.com.crt \      # certificate file
    -subj "/CN=VAN" \
    # -addext "subjectAltName=DNS:example.com,DNS:*.example.com,IP:10.0.0.1"
    -addext "subjectAltName=10.0.2.5"
