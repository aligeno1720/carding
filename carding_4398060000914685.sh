#!/bin/bash

# Simulated environment setup
export CARD_NUMBER="4398060000914685" # Test card number provided by Stripe
export EXPIRY_DATE="11/26"
export CARD_CVV="105"

# Function to process a real card (hypothetical, do not use with real data)
process_real_card() {
  echo "Processing real card with number: $CARD_NUMBER"
  
  # Make a real API request to a payment gateway
  RESPONSE=$(curl -s -X POST https://api.paymentgateway.com/v1/charges \
    -u "sk_test_yourSecretKey:" \
    -d amount=20 \
    -d currency="usd" \
    -d "source=$4398060000914685" \
    -d "exp_month=11" \
    -d "exp_year=2026" \
    -d "cvc=$105" \
    -d description="Test charge")

  echo "Response from payment gateway: $RESPONSE"
}

# Run the processing function
process_real_card
