#!/bin/sh
set -eu

cat >/tmp/turnserver.conf <<EOF
use-auth-secret
static-auth-secret=${TURN_STATIC_AUTH_SECRET}
realm=${TURN_REALM}
server-name=${TURN_DOMAIN}
listening-port=${TURN_LISTEN_PORT}
tls-listening-port=${TURN_TLS_LISTEN_PORT}
min-port=${TURN_MIN_PORT}
max-port=${TURN_MAX_PORT}
fingerprint
lt-cred-mech
no-cli
no-multicast-peers
no-loopback-peers
stale-nonce=600
log-file=stdout
simple-log
EOF

exec turnserver -c /tmp/turnserver.conf
