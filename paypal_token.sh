#!/bin/bash

# PayPal API credentials
CLIENT_ID="your_client_id"
SECRET="your_secret"

# PayPal API endpoint for token
TOKEN_URL="https://api.paypal.com/v1/oauth2/token"

# PayPal API endpoint for payment
PAYMENT_URL="https://api.paypal.com/v1/payments/payment"

# Get Access Token
echo "Obtaining access token..."
RESPONSE=$(curl -s -X POST "$TOKEN_URL" \
  -u "$CLIENT_ID:$SECRET" \
  -d "grant_type=client_credentials")

# Extract the access token from the response
ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r '.access_token')

# Check if token was retrieved
if [[ -z "$ACCESS_TOKEN" || "$ACCESS_TOKEN" == "null" ]]; then
  echo "Failed to obtain access token."
  exit 1
fi

echo "Access Token obtained: $ACCESS_TOKEN"

# Payment details
PAYLOAD=$(cat <<EOF
{
  "intent": "sale",
  "payer": {
    "payment_method": "credit_card",
    "funding_instruments": [{
      "credit_card": {
        "number": "4389843000183513",
        "type": "visa",
        "expire_month": "11",
        "expire_year": "2025",
        "cvv2": "123",
        "first_name": "Justin",
        "last_name": "Walters"
      }
    }]
  },
  "transactions": [{
    "amount": {
      "total": "100.00",
      "currency": "USD"
    },
    "description": "Payment description"
  }],
  "redirect_urls": {
    "return_url": "http://example.com/return",
    "cancel_url": "http://example.com/cancel"
  }
}
EOF
)

# Make the payment request
echo "Making payment request..."
PAYMENT_RESPONSE=$(curl -s -X POST "$PAYMENT_URL" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

# Parse the payment response
PAYMENT_ID=$(echo "$PAYMENT_RESPONSE" | jq -r '.id')
PAYMENT_STATE=$(echo "$PAYMENT_RESPONSE" | jq -r '.state')

# Output the results
echo "Payment Response:"
echo "$PAYMENT_RESPONSE"

echo "Payment ID: $PAYMENT_ID"
echo "Payment State: $PAYMENT_STATE"
