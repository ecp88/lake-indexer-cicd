# Near Lake deployment instructions

## When to update?

There is no simple answer. I recommend following the rules:

nearcore release had happened (regular one, not the urgent on-fire; we have time before the voting)

A day or two passed from the nearcore release, no new hotfix release happened, and no significant issues have been found

So, the main recommendation is not to update near-lake instances simultaneously with the SRE team doing the RPC release. Wait a bit and ensure everything went well with the RPC.

** High-level upgrade steps **

We’ll go deeper into details below, but I wanted to give a high-level overview of the flow ideally.

Developers from Near One create a pull request with the upgrade of NEAR Lake in the repo

After merging, Near One developers create a release (examples: 1.0.0-rc.2, 1.0.0), which triggers the GitHub Action to build a binary that will be attached to the release assets (binary name near-lake-indexer)

Pagoda maintainer then removes one of the near-lake nodes from the instance group on GCP and deletes the other one (we assume there are two nodes in the group, it can change in the future, and the flow has to be improved according to the situation)

Pagoda maintainer performs terraform apply in the corresponding folder of the near-ops to bring new nodes to the near-lake instance group on GCP.

After some time (when new nodes catch up with the network according to the Grafana dashboard), the Pagoda maintainer deletes the leftover node from step 3 that was removed from the instance group

## Pagoda maintainer instructions in detail

- Right now we use the Instance Group `testnet-lake-group-1` on GCP in the near-core project for the testnet, but the group name might change, keep that in mind.

- Find the instance group in the GCP console. It should be in the near-core project. The name of the group is `testnet-lake-group-1` (or another one if it was changed).

- Now we need to remove one node from the group (to make sure the Lake service continue working while we spinning up new nodes). We need to decide which node to keep working based on its performance.

- We select the node (checkmark it) and press “REMOVE FROM GROUP”. This action will detach this node from the group and will keep it as an independent VM. This will ensure we don’t have any downtimes during the upgrade.

- When the instance is removed from the group, we need terraform apply so new instance with the new version of the binary will be created.

- /near-lake/testnet and do `terraform apply` in the folder. This will create a new instance with the new version of the binary.

- After the new instance is up and running, we need to check the Grafana dashboard to ensure the new instance is catching up with the network.

- When we see that the new instance is catching up with the network, we can remove the old instance from the group. We select the old instance and press “DELETE”.
