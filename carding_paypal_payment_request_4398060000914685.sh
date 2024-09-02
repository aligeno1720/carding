#!/bin/bash

# PayPal API credentials
CLIENT_ID="your_client_id"
SECRET="your_secret"

# Obtain an access token from PayPal
ACCESS_TOKEN=$(curl -s -X POST https://api.sandbox.paypal.com/v1/oauth2/token \
    -u "$CLIENT_ID:$SECRET" \
    -d "grant_type=client_credentials" | jq -r '.access_token')

if [ -z "$ACCESS_TOKEN" ]; then
  echo "Failed to obtain access token"
  exit 1
fi

echo "Access Token: $ACCESS_TOKEN"

# Store credit card securely using PayPal's vault API
CARD_ID=$(curl -s -X POST https://api.sandbox.paypal.com/v1/vault/credit-cards \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -d '{
          "number": "4398060000914685",
          "type": "visa",
          "expire_month": "11",
          "expire_year": "2026",
          "cvv2": "105",
          "first_name": "Justin",
          "last_name": "Walters",
          "billing_address": {
            "line1": "123 Main St",
            "city": "San Jose",
            "state": "CA",
            "postal_code": "95131",
            "country_code": "US"
          }
        }' | jq -r '.id')

if [ -z "$CARD_ID" ]; then
  echo "Failed to store the credit card"
  exit 1
fi

echo "Stored Card ID: $CARD_ID"

# Simulate a PayPal payment request using the stored card
RESPONSE=$(curl -s -X POST https://api.sandbox.paypal.com/v1/payments/payment \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -d '{
          "intent": "sale",
          "payer": {
            "payment_method": "credit_card",
            "funding_instruments": [{
              "credit_card_token": {
                "credit_card_id": "'"$CARD_ID"'"
              }
            }]
          },
          "transactions": [{
            "amount": {
              "total": "10.00",
              "currency": "USD"
            },
            "description": "Payment simulation using credit card"
          }]
        }')

# Check the response
if echo "$RESPONSE" | grep -q "id"; then
  echo "Payment successful"
else
  echo "Payment failed"
  echo "Response: $RESPONSE"
fi
