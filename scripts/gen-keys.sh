#!/bin/bash

PRIVATE_KEY_PEM=$(openssl genrsa 2048 2>/dev/null)

PUBLIC_KEY_PEM=$(echo "$PRIVATE_KEY_PEM" | openssl rsa -pubout 2>/dev/null)

echo "Private Key (PEM; base64 encoded):"
echo -n "$PRIVATE_KEY_PEM" | base64 -w 0
echo -e "\n"

echo "Public Key (PEM; base64 encoded):"
echo -n "$PUBLIC_KEY_PEM" | base64 -w 0
echo ""