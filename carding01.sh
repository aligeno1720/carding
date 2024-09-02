#!/bin/bash

# Set your card information as environment variables
export CARD_NUMBER="4389843000183513"
export EXPIRY_DATE="11/25"
export CARD_CVV="149"

# Function to simulate card processing
process_card() {
  echo "Processing card with number: $CARD_NUMBER"
  echo "Expiry Date: $EXPIRY_DATE"
  echo "CVV: $CARD_CVV"

  # Simulate card processing logic
  echo "Data Found..."
  sleep 2  # Simulate a delay for processing

  # Display simulated result
  echo "Transaction ACH Status checking...!"
}

# Function to test card details
test_card() {
  echo "Testing card connections..."
  
  # Simple validation (placeholder logic)
  if [[ ${#CARD_NUMBER} -eq 16 && $CARD_CVV =~ ^[0-9]{3}$ ]]; then
    echo "Card details are valid."
  else
    echo "Invalid card details."
  fi
}

# Run the card simulation functions
process_card
test_card
