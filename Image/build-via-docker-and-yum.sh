#!/bin/bash
whichyum=${1:-yum}  # yum or microyum
target=${2:-centos} # centos or fedora
releasever=${3:-} 

if test -z ${releasever}; then
    case $target in
	centos)
	    releasever=7 ;;
	fedora)
	    releasever=24 ;;
	*) echo "unknown target $target"; exit 1
    esac
fi

sed -e "s,\@target\@,${target}:${releasever},g" < buildcontainer/Dockerfile.in > buildcontainer/Dockerfile
buildimgname=pipeline/${target}-builder-${whichyum}:${releasever}
(cd buildcontainer && docker build -t ${buildimgname} .)

docker run --privileged --net=host --rm -v $(pwd):/srv --workdir /srv ${buildimgname} /srv/build-via-yum.py --target "${target}" --releasever=${releasever} --whichyum=${whichyum}
