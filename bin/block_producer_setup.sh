#!/usr/bin/env bash

ENDPOINT_ONE=$1
WALLET_DIR=$2

# create 21 producers error out if vars not set
for producer_name in bpa bpb bpc
do
    [ ! -s "$WALLET_DIR/${producer_name}.keys" ] && cleos create key --to-console > "$WALLET_DIR/${producer_name}.keys"
    # head because we want the first match; they may be multiple keys
    PRIVATE_KEY=$(grep Private "$WALLET_DIR/${producer_name}.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
    PUBLIC_KEY=$(grep Public "$WALLET_DIR/${producer_name}.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
    cleos wallet import --name finality-test-network-wallet --private-key $PRIVATE_KEY

    # register producer
    cleos --url $ENDPOINT_ONE system regproducer ${producer_name} ${PUBLIC_KEY}
done

# create user keys
[ ! -s "$WALLET_DIR/user.keys" ] && cleos create key --to-console > "$WALLET_DIR/user.keys"
# head because we want the first match; they may be multiple keys
USER_PRIVATE_KEY=$(grep Private "$WALLET_DIR/user.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
cleos wallet import --name finality-test-network-wallet --private-key $USER_PRIVATE_KEY

for user_name in usera userb userc userd usere userf userg userh useri userj \
   userk userl userm usern usero userp userq userr users usert useru \
   userv userw userx usery userz
do
  # vote
  cleos --url $ENDPOINT_ONE system voteproducer prods ${user_name} bpa bpb bpc
done

# delegate active permissions
cat > $HOME/required_auth.json << EOF
{
  "threshold": 3,
  "keys": [],
  "accounts": [
    {
      "permission": {
        "actor": "bpa",
        "permission": "active"
      },
      "weight": 1
    },
    {
      "permission": {
        "actor": "bpb",
        "permission": "active"
      },
      "weight": 1
    },
    {
      "permission": {
        "actor": "bpc",
        "permission": "active"
      },
      "weight": 1
    }
  ],
  "waits": []
}
EOF
cleos  --url $ENDPOINT_ONE set account permission eosio active $HOME/required_auth.json
