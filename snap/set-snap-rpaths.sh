#!/bin/bash
set -x

if [ -z "$SNAPCRAFT_PROJECT_NAME" ]; then
  echo "This script has to be called from snapcraft"
  exit 1
fi

if [ -z "$SNAPCRAFT_RPATH_RUNTIMES" ]; then
  echo 'The varialbe $SNAPCRAFT_RPATH_RUNTIMES is not defined'
  exit 1
fi

for cnt in $SNAPCRAFT_PROJECT_NAME $SNAPCRAFT_RPATH_RUNTIMES core; do
  rpath+="$([ -n "$rpath" ] && echo "$rpath:" || echo "")"
  rpath+="/snap/$cnt/current/lib"
  rpath+=":/snap/$cnt/current/lib/$SNAPCRAFT_ARCH_TRIPLET"
  rpath+=":/snap/$cnt/current/usr/lib"
  rpath+=":/snap/$cnt/current/usr/lib/$SNAPCRAFT_ARCH_TRIPLET"
done

for f in $*; do
  if [ -f "$f" ] && ! [ -L "$f" ]; then
    patchelf --force-rpath --set-rpath "$rpath" "$f"
  fi
done
