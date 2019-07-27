# openshifthappens
This set of scripts and playbooks started a few years ago based on training and documentation and has served as a test bed for new versions of OpenShift.

Initially this ran on my personal laptop until I bought a new desktop where I installed my new home lab which I described as "Built to break" because of resource limitations and a constant stream of hardware issues.

Although not complex, this set of playbooks and scripts is what lets me make changes and be able to repeat my deployment on pre-installed infrastructure.

# Notes
Some of the files have vaulted secrets and will not work unless they are replaced with user-supplied secrets. For example:

inventory/openshift-3.11/common/group_vars/all.yml
playbooks/project-request.yml
ceph/ceph-secret.yml
ceph/ceph-user-secret.yml

Some files, like certificates, were just difficult to address using relative paths and were easier to leave out. My vault secret, for example, is not included here. To create your own vault secret, you may choose to use

```bash
head -c 32 /dev/urandom | base64>~/.vault_password
```

The project-request template may be generated with the following:

```bash
oc adm create-bootstrap-project-template -o yaml > project-request.yaml
```

There is a script named `makecerts` in the examples/scripts directory that I had used at one point to generate an untrusted CA with SubjectAltName (SAN) for testing certificates for an mTLS demo (it create a client and server certificate, while it takes a hostname as an argument the v3.exts has a hard-coded SAN).

# Warnings

These playbooks, roles, and scripts are provided as-is without warranty. These are not expected to work without modification. The vaulted secrets aren't to any public resources and the remaining plaintext passwords and hashes, such as "openshift", are in comments or left for example purposes (such as those remaining from the original hosts.example).

At least one of the playbooks was used to wipe all filesystems on /dev/sdc on my Ceph storage node. If you have a /dev/sdc and care about it, don't run the uninstall-storage playbook. In fact, please read all of the playbooks before executing if you wish to avoid damage to your systems.
