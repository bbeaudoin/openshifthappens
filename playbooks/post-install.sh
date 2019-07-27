#!/bin/bash -x
oc adm policy add-cluster-role-to-user cluster-admin admin
oc create -f /root/project-request.yml
oc create -f /root/ceph-secret.yml
oc create -f /root/ceph-user-secret.yml
oc create -f /root/ceph-storageclass.yml
exit 0
