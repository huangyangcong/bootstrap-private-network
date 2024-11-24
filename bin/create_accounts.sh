#!/usr/bin/env bash

ENDPOINT_ONE=$1
WALLET_DIR=$2

cleos --url $ENDPOINT_ONE transfer eosio enf "10000 EOS" "init funding"
cleos --url $ENDPOINT_ONE system buyram eosio enf "1000 EOS"

# create 21 producers error out if vars not set
for producer_name in bpa bpb bpc
do
    [ ! -s "$WALLET_DIR/${producer_name}.keys" ] && cleos create key --to-console > "$WALLET_DIR/${producer_name}.keys"
    # head because we want the first match; they may be multiple keys
    PRIVATE_KEY=$(grep Private "$WALLET_DIR/${producer_name}.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
    PUBLIC_KEY=$(grep Public "$WALLET_DIR/${producer_name}.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
    cleos wallet import --name finality-test-network-wallet --private-key $PRIVATE_KEY

    # 400 staked per producer x21 = 8400 EOS staked total
    cleos --url $ENDPOINT_ONE system newaccount eosio ${producer_name:?} ${PUBLIC_KEY:?} --stake-net "500 EOS" --stake-cpu "500 EOS" --buy-ram "1000 EOS"
    # get some spending money
    cleos --url $ENDPOINT_ONE transfer eosio ${producer_name} "10000 EOS" "init funding"
    # self stake some net and cpu
    cleos --url $ENDPOINT_ONE system delegatebw ${producer_name} ${producer_name} "4000.0 EOS" "4000.0 EOS"
done

# create user keys
[ ! -s "$WALLET_DIR/user.keys" ] && cleos create key --to-console > "$WALLET_DIR/user.keys"
# head because we want the first match; they may be multiple keys
USER_PRIVATE_KEY=$(grep Private "$WALLET_DIR/user.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
USER_PUBLIC_KEY=$(grep Public "$WALLET_DIR/user.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
cleos wallet import --name finality-test-network-wallet --private-key $USER_PRIVATE_KEY

for user_name in usera userb userc userd usere userf userg userh useri userj \
   userk userl userm usern usero userp userq userr users usert useru \
   userv userw userx usery userz
do
  # create user account
  cleos --url $ENDPOINT_ONE system newaccount eosio ${user_name:?} ${USER_PUBLIC_KEY:?} --stake-net "50 EOS" --stake-cpu "50 EOS" --buy-ram "100 EOS"
  # get some spending money
  cleos --url $ENDPOINT_ONE transfer eosio ${user_name} "11540000 EOS" "init funding"
  # stake 1154K EOS x26 accounts = 300,004,000 EOS Total Staked
  cleos --url $ENDPOINT_ONE system delegatebw ${user_name} ${user_name} "5770000.000 EOS" "5770000.0000 EOS"
done
