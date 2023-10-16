#!/bin/bash
set -e -u -x

#####################################
#
# adds external dependences to wheels when it is possible
#
#####################################

WHEELS=/wheels/results/wheelhouse/

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel"  -w ${WHEELS} || true
    fi
}


# Bundle external shared libraries into the wheels
for whl in ${WHEELS}/*.whl; do
    repair_wheel "$whl"
done

