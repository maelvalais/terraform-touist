#! /bin/bash
#
# deprovision.sh
# Copyright (C) 2018 Maël Valais <mael.valais@gmail.com>
#
# Distributed under terms of the MIT license.
#

function help() {
    cat <<EOF
    --init        run 'terraform init' before any apply
    --apply       terraform apply
    --destroy     terraform destroy
EOF
}

while [ $# -gt 0 ]; do
case $1 in
    --init) INIT=1;;
    --apply) ACTION=apply; ORDER="base-infra services/touist-api services/touist-www";;
    --destroy) ACTION=destroy; ORDER="services/touist-api services/touist-www base-infra";;
    --help) help; exit 0;;
esac
shift
done
set -xe
for i in $ORDER; do
    pushd "$i"
    if [ -n "$INIT" ]; then terraform init; fi
    terraform $ACTION <<< yes
    popd
done
