#!/bin/bash
set -ex

/etc/eks/bootstrap.sh ${cluster_name} --b64-cluster-ca ${cluster_auth_base64} --apiserver-endpoint ${cluster_endpoint}
