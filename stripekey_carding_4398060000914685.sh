#!/bin/bash

# Stripe API Secret Key
SECRET_KEY="sk_test_your_secret_key"

# Stripe API endpoint for creating a Payment Intent
PAYMENT_URL="https://api.stripe.com/v1/payment_intents"

# Payment details
AMOUNT=10000 # Amount in cents ($100.00)
CURRENCY="usd"

# Function to create a payment intent
create_payment_intent() {
  echo "Creating payment intent..."
  RESPONSE=$(curl -s -X POST "$PAYMENT_URL" \
    -u "$SECRET_KEY:" \
    -d amount="$AMOUNT" \
    -d currency="$CURRENCY" \
    -d payment_method_types[]=card)

  # Parse the payment intent ID from the response
  PAYMENT_INTENT_ID=$(echo "$RESPONSE" | jq -r '.id')

  # Check if the Payment Intent ID was created
  if [ "$PAYMENT_INTENT_ID" != "null" ]; then
    echo "Payment Intent ID: $PAYMENT_INTENT_ID"
  else
    echo "Failed to create Payment Intent. Response: $RESPONSE"
    exit 1
  fi
}

# Function to confirm the payment intent with card details
confirm_payment_intent() {
  echo "Confirming payment intent..."
  CONFIRM_RESPONSE=$(curl -s -X POST "https://api.stripe.com/v1/payment_intents/$PAYMENT_INTENT_ID/confirm" \
    -u "$SECRET_KEY:" \
    -d payment_method_data[type]=card \
    -d payment_method_data[card][number]=4389843000183513 \
    -d payment_method_data[card][exp_month]=11 \
    -d payment_method_data[card][exp_year]=2025 \
    -d payment_method_data[card][cvc]=149)

  # Check if the payment was successful
  STATUS=$(echo "$CONFIRM_RESPONSE" | jq -r '.status')
  
  if [ "$STATUS" == "succeeded" ]; then
    echo "Payment successful!"
  else
    echo "Payment failed or requires additional actions. Response: $CONFIRM_RESPONSE"
    exit 1
  fi
}

# Main script execution
create_payment_intent
confirm_payment_intent
