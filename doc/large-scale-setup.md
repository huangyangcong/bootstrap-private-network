# Large Scale Setup

Changes you may consider when setting up a large multi-node network.

## Installing Software
There is a missing step to copy the Spring deb packages to all hosts. The Step by Step and reference scripts assume a single host with several separate processes running nodeos on different ports. In a multi-host setup this isn't the case.

## Configuration
- Increase `chain-state-db-size-mb` in `config.ini` to production levels.
- Add `database-map-mode = mapped_private` for better disk IO. See [Leap 5 performance testing](https://eosnetwork.com/blog/leap-5-performance-testing/). Need to make sure swap space is large enough to cover `chain-state-db-size-mb`.
- Decrease `max-transaction-time` significantly
- Suggest secure connections, you may not want to allow `any` connections

## Peer Settings
The scripts assume localhost for all three instances of nodoes. When running a multi-host network the correct ip addresses will need to be used. By using distinct IP, you may use the same ports for all nodeos instances.

## Multi-Producers Per Node
To get a network up to 21 block-finalizers there may need to be multiple-producers on each nodeos. The Savanna algorithm will work with multiple producers on a single node. When using multiple block-finalizers be sure to correctly set the `threshold` in `finalizer_policy` action to a 2/3 weight. If there are 21 producers each with a weight of 1, 2/3 `threshold` would be 15.
