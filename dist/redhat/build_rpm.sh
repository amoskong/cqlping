#!/bin/bash

VERSION=0.0.1
RELEASE=0

if [ ! -e dist/redhat/build_rpm.sh ]; then
    echo "run build_rpm.sh in top of cqlping dir"
    exit 1
fi

build_dir=~/rpmbuild/

mkdir -p build
./scripts/git-archive-all --force-submodules --prefix cqlping-$VERSION-$RELEASE $build_dir/SOURCES/cqlping-$VERSION-$RELEASE.tar
echo $build_dir/SOURCES/cqlping-$VERSION-$RELEASE.tar

SPEC_FILE=$build_dir/SPECS/cqlping.spec

cp dist/redhat/cqlping.spec.in $SPEC_FILE
sed -i -e "s/@@VERSION@@/$VERSION/g" $SPEC_FILE
sed -i -e "s/@@RELEASE@@/$RELEASE/g" $SPEC_FILE

rpmbuild -ba $SPEC_FILE
