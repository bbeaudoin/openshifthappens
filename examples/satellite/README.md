# Satellite (or why to use a private repo)
Early on I realized installing OpenShift would require a lot of network bandwidth. It became clear early on that to be able to provision and quickly reprovision a lab environment on-demand I would need to cache packages, and potentially repositories, locally to conserve on my limited bandwidth.

## Installation
Installing Satellite Server on a suitable system can be done with the following commands:
```bash
subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-server-rhscl-7-rpms --enable=rhel-7-server-satellite-6.4-rpms --enable=rhel-7-server-satellite-maintenance-6-rpms --enable=rhel-7-server-ansible-2.6-rpms
subscription-manager release --unset
firewall-cmd --add-port="53/udp" --add-port="53/tcp" --add-port="67/udp" --add-port="69/udp" --add-port="80/tcp"  --add-port="443/tcp" --add-port="5000/tcp" --add-port="5647/tcp" --add-port="8000/tcp" --add-port="8140/tcp" --add-port="9090/tcp"
firewall-cmd --runtime-to-permanent
yum install -y satellite
satellite-installer --scenario satellite --disable-system-checks
```

When I state "suitable" I don't necessarily mean on a system that meets all of the prerequisites. My lab has a minimum amount of RAM, CPU, and storage. More so when I installed than now.

Satellite needs a "subscription manifest" which I configured at https://access.redhat.com/ and uploaded to the server after installing it. However, if one has a subscription that includes Satellite or is using a Spacewalk server, the basic installation can be completed. For Spacewalk users, `yum-repo-sync` can be used with the API to populate repos but I haven't used Spacewalk in a few years and no longer maintain my scripts to populate repos or debug dependency issues.

For subscription licensing, users should configure `/etc/sysconfig/virt-who` appropriately for their Satellite and vSphere or other virtualization provider as appropriate. The command `systemctl enable --now virt-who` will start and enable the service to attach subscriptions to systems. There is a 24-hour subscription grace period for new installations, after which systems will no longer be entitled to installations or updates when using Red Hat Subcription Management.

If using Red Hat IdM, Red Hat Certificate Services, FreeIPA, Dogtag, or any other Certificate Authority the initial instructions will use self-signed (untrusted) certificates. One may use `katello-certs-check` to validate external CA certificates prior to installation and `satellite-installer` can be re-run with the options `-certs-update-server --certs-update-server-ca` to update the certificates. This will require reconfiguring previously installed clients to trust the external CA if a publicly-trusted CA did not issue the certificates.

The `admin` password is stored in `.hammer/cli.modules.d/foreman.yml` and may be used to administer Satellite. My recommendation is to configure a service account in AD/Kerberos/LDAP and set the default groups for users in the Satellite or Spacewalk administration settings for authentication.
