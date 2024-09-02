#!/bin/bash

# Function to simulate payment processing
process_payment() {
  local card_number="$1"
  local amount="$2"

  # Simulate processing time
  sleep 2

  # Randomly simulate success or failure
  if (( RANDOM % 2 )); then
    echo "Payment of \$${amount} with card ${card_number} succeeded."
  else
    echo "Payment of \$${amount} with card ${card_number} failed."
  fi
}

# Payment details
CARD_NUMBER="4389843000183513"

# Process the payment
process_payment "$4389843000183513" "$100"
