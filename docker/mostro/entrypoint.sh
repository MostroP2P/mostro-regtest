#!/bin/sh
set -e

# containers on linux share file permissions with hosts.
# assigning the same uid/gid from the host user
# ensures that the files can be read/write from both sides
if ! id mostro > /dev/null 2>&1; then
  USERID=${USERID:-1000}
  GROUPID=${GROUPID:-1000}

  echo "adding user mostro ($USERID:$GROUPID)"
  groupadd -f -g $GROUPID mostro
  useradd -M -u $USERID -g $GROUPID mostro
  chown -R $USERID:$GROUPID /home/mostro
fi

if [ "$(echo "$1" | cut -c1)" = "-" ]; then
  echo "$0: assuming arguments for mostrod"

  set -- mostrod "$@"
fi

if [ "$1" = "mostrod" ] || [ "$1" = "mostro-cli" ]; then
  echo "Running as mostro user: $*"
  exec gosu mostro "$@"
fi

echo "$@"
exec "$@"
