#!/bin/bash

# Step 1: Generate a RSA 4096 key (root CA key)
openssl genrsa -out rootCA.key 4096

# Step 2: Generate the root certificate
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 2048 -out rootCA.crt -subj "/C=FR/ST=Paris/L=Paris/O=EPITA/OU=ADLIN/CN=ADLIN/"

# Step 3: Create a 2048 RSA key for the web server
openssl genrsa -out adlin.tiger.org.key 2048

# Step 4: Create a CSR (Certificate Signing Request)
openssl req -new -key adlin.tiger.org.key -out adlin.tiger.org.csr -subj "/C=FR/ST=Paris/L=Paris/O=EPITA/OU=ADLIN/CN=adlin.tiger.org/"

# Step 5: Sign CSR with root CA
openssl x509 -req -in adlin.tiger.org.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out adlin.tiger.org.crt -days 365 -sha256 -extfile <(echo -e "authorityKeyIdentifier=keyid,issuer\nbasicConstraints=CA:FALSE\nkeyUsage = digitalSignature, keyEncipherment\nsubjectAltName = @alt_names\n\n[alt_names]\nDNS.1 = adlin.tiger.org\nDNS.2 = *.adlin.tiger.org")
