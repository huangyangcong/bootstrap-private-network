# Use Cases

## Purpose

There are two purposes to this repository. The primary purpose is to act as a developer reference for the Savanna algorithm. The reference includes the following:
- The git commit level for Antelope Software.
   - Spring
   - CDT
   - Reference Contracts
- Build and Install Antelope Software from source.
- The exact protocol activations to use.
- Creation and Application of BLS Finalizer Keys.
- Activation of Savanna protocol. *Note: may be automated, a no-op*

The second purpose is to create an early access release for the developer community. Furthermore this early access release provides two things
- Local dev setup showing faster finality through log examination
- Local dev setup to connect and test SDKs

## Non-Goals

This reference does not provide advice on how to setup or run a production network. None of the configuration settings, nor setup details are recommended for a production setup.

## Use Cases

### Reference Implementation
Currently we have not documented the versions of **Spring**, **CDT**, and **Reference Contracts** to use for a **Savanna** network. This is a moving target, the reference implementation would be updated on a weekly basis with compatible versions across the AntelopeIO software chain. In addition, the weekly versions would be tagged in this repository. The protocol activation must also be documented, as not all protocol activations are currently supported with the **Savanna** implementation. As protocol support is enhanced a reference implementation would be the best documentation for what is supported. Finally the BLS keys are new. It would be good to have working code to initialize these keys from commands, and apply them.

### Early Access
Fully scripting the end-2-end build, install, and setup of software is difficult and time consuming. A reference implementation with examples would allow developers easier access to **Savanna**. This would allow community members to run and set up their own version of AntelopeIO, and switch over to the **Savanna** finalization protocol. Community members will see the dramatically, faster finality, in their own local environments, providing a tangible demonstration of the new implementation.

Hopefully, this reference implementation would allow developers to connect their SDKs and try out the new **Savanna** protocol. Other test networks may have patches or non-standard configurations to work around issues or provide temporary backwards compatibility. A true reference implementation will act as the most current thinking. In addition by providing named git tags for each release of this repo, there will be named versions across Antelope software chain. These named versions should be used by the community to specify the version of the Antelope software stack they are using, and for reporting any issues.

In addition, a local test network can be setup to have looser resource rules, allowing longer tests. Having looser resource rules is nice when trying out something new. It allows for faster iterations.

## Technical Approach
Using Docker allow the separation of concerns. The Docker build step can download the source code, build the software, and cache the results. Once the Docker image is built is can be used many times to start **Savanna** compatible versions of **Spring**, **CDT**, and **Reference Contracts**. This repo will provide the scripts to build the docker image.

In addition, this repo will provide the scripts needed to start a multi-producer private network. A multi-producer network is needed demonstrate the delta between the Head Block and Last Irreversible Block (LIB). A single producer network, can not be used; it would always have a 1 block delta between the Head Block and LIB. Finally there would be scripts to generate the BLS finalizer keys, apply those keys, and initiate the transition to the **Savanna** protocol.

Providing data is too time consuming and difficult. This reference implementation will be started from *genesis*, with the reference contracts and a starting token balance belonging to the *eosio* user.
