#!/bin/bash

# Stripe API Secret Key
SECRET_KEY="sk_test_your_secret_key"

# Create a customer first if needed
create_customer() {
  echo "Creating customer..."
  CUSTOMER_RESPONSE=$(curl -s -X POST "https://api.stripe.com/v1/customers" \
    -u "$SECRET_KEY:" \
    -d name="John Doe" \
    -d email="johndoe@example.com")

  CUSTOMER_ID=$(echo "$CUSTOMER_RESPONSE" | jq -r '.id')
  echo "Customer ID: $CUSTOMER_ID"
}

# Attach a bank account to the customer
attach_bank_account() {
  echo "Attaching bank account..."
  BANK_RESPONSE=$(curl -s -X POST "https://api.stripe.com/v1/customers/$CUSTOMER_ID/sources" \
    -u "$SECRET_KEY:" \
    -d source="btok_us_verified" \
    -d object="bank_account" \
    -d country="US" \
    -d currency="usd" \
    -d account_holder_name="xxx" \
    -d account_holder_type="individual" \
    -d routing_number="xxxx" \
    -d account_number="xxxx")

  BANK_ACCOUNT_ID=$(echo "$BANK_RESPONSE" | jq -r '.id')
  echo "Bank Account ID: $BANK_ACCOUNT_ID"
}

# Create a charge using the bank account
create_charge() {
  echo "Creating charge..."
  CHARGE_RESPONSE=$(curl -s -X POST "https://api.stripe.com/v1/charges" \
    -u "$SECRET_KEY:" \
    -d amount="10" \
    -d currency="usd" \
    -d customer="$CUSTOMER_ID" \
    -d source="$BANK_ACCOUNT_ID" \
    -d description="Test ACH Payment")

  STATUS=$(echo "$CHARGE_RESPONSE" | jq -r '.status')
  echo "Charge Status: $STATUS"
}

# Main script execution
create_customer
attach_bank_account
create_charge
