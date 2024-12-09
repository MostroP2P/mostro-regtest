#!/usr/bin/env bash
#
# Mostro utilities.
# This should only be sourced, not executed directly

set -Eeuo pipefail

# Ensure script is sourced
[[ -n "$BASH_VERSION" ]] || fatal "This file must be sourced from bash."
[[ "$(caller 2>/dev/null | awk '{print $1}')" != "0" ]] || fatal "This file must be sourced, not executed."

# -----------------------------------------------------------------------------

# m/44'/1237'/38383'/0/0 -> identity
readonly MOSTRO_DERIVATION_PATH="m/44'/1237'/38383'/0"

readonly MOSTRO_TEST_FIAT_CODES=(VES PEN ARS USD)
readonly MOSTRO_TEST_PAYMENT_METHODS=(F2F BANK_TRANSFER)

mostro_cli() {
  local mostro_pubkey relay
  mostro_pubkey=$(mostro_identity_public_key)
  relay="ws://nostr_relay:8080"
  docker_compose exec --user mostro mostro mostro-cli -m "$mostro_pubkey" -r "$relay" "$@"
}

mostro_private_key_from_mnemonic_index() {
  local mnemonic="${@:1:$#-1}"
  local index="${!#}"
  private_key_from_mnemonic_path "$mnemonic" "$MOSTRO_DERIVATION_PATH/$index"
}

mostro_create_random_orders() {
  info create random sell orders for alice
  for i in 0 1 2; do
    mostro_create_random_sell_order "$(alice_identity_private_key)"
  done

  info create random sell orders for bob
  for i in 0 1 2; do
    mostro_create_random_sell_order "$(bob_identity_private_key)"
  done
}

mostro_create_random_sell_order() {
  local from_private_key="$1"

  local kind="sell"

  local fiat_codes_len=${#MOSTRO_TEST_FIAT_CODES[@]}
  local fiat_code_index
  fiat_code_index=$(($RANDOM % $fiat_codes_len))
  local fiat_code="${MOSTRO_TEST_FIAT_CODES[$fiat_code_index]}"
  
  local fiat_amount=0
  
  local amount
  amount=$(($RANDOM % 401 + 100))
  # local is_range=$(($RANDOM % 2))
  # local amount=0 min_amount=0 max_amount=0
  # if [ $is_range -eq 1 ]; then
    # min_amount=$(($RANDOM % 101 + 100))
    # max_amount=$(($RANDOM % 201 + 300))
  # else
    # amount=$(($RANDOM % 401 + 100))
  # fi

  local premium
  premium=$(($RANDOM % 5 + 1))


  local payment_methods_len=${#MOSTRO_TEST_PAYMENT_METHODS[@]}
  local payment_method_index
  payment_method_index=$(($RANDOM % $payment_methods_len))
  local payment_method="${MOSTRO_TEST_PAYMENT_METHODS[$payment_method_index]}"

  mostro_cli -n "$from_private_key" neworder \
    -k "$kind" \
    -c "$fiat_code" \
    -f "$fiat_amount" \
    -a "$amount" \
    -p "$premium" \
    -m "$payment_method"
}

mostro_identity_private_key() {
  if [[ -z "${MOSTRO_IDENTITY_PRIVATE_KEY-}" ]]; then
    readonly MOSTRO_IDENTITY_PRIVATE_KEY=$(mostro_private_key_from_mnemonic_index "$MOSTRO_MNEMONIC" 0)
  fi
  echo "$MOSTRO_IDENTITY_PRIVATE_KEY"
}

mostro_identity_public_key() {
  local private_key=$(mostro_identity_private_key)
  if [[ -z "${MOSTRO_IDENTITY_PUBLIC_KEY-}" ]]; then
    readonly MOSTRO_IDENTITY_PUBLIC_KEY=$(public_key_from_private_key "$private_key")
  fi
  echo "$MOSTRO_IDENTITY_PUBLIC_KEY"
}

alice_identity_private_key() {
  if [[ -z "${ALICE_IDENTITY_PRIVATE_KEY-}" ]]; then
    readonly ALICE_IDENTITY_PRIVATE_KEY=$(mostro_private_key_from_mnemonic_index "$ALICE_MNEMONIC" 0)
  fi
  echo "$ALICE_IDENTITY_PRIVATE_KEY"
}

alice_identity_public_key() {
  local private_key=$(alice_identity_private_key)
  if [[ -z "${ALICE_IDENTITY_PUBLIC_KEY-}" ]]; then
    readonly ALICE_IDENTITY_PUBLIC_KEY=$(public_key_from_private_key "$private_key")
  fi
  echo "$ALICE_IDENTITY_PUBLIC_KEY"
}

bob_identity_private_key() {
  if [[ -z "${BOB_IDENTITY_PRIVATE_KEY-}" ]]; then
    readonly BOB_IDENTITY_PRIVATE_KEY=$(mostro_private_key_from_mnemonic_index "$BOB_MNEMONIC" 0)
  fi
  echo "$BOB_IDENTITY_PRIVATE_KEY"
}

bob_identity_public_key() {
  local private_key=$(bob_identity_private_key)
  if [[ -z "${BOB_IDENTITY_PUBLIC_KEY-}" ]]; then
    readonly BOB_IDENTITY_PUBLIC_KEY=$(public_key_from_private_key "$private_key")
  fi
  echo "$BOB_IDENTITY_PUBLIC_KEY"
}