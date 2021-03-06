#!/usr/bin/env python

import os
import sys
import subprocess
import tempfile
import shutil
import argparse

def fatal(msg):
    sys.stdout.write(msg + '\n')
    sys.exit(1)
def run_sync(argv, **kwargs):
    print "%s" % (subprocess.list2cmdline(argv), )
    sys.stdout.flush()
    subprocess.check_call(argv, **kwargs)

parser = argparse.ArgumentParser(description='Create base image')
parser.add_argument('--target', action='store', help='centos or fedora', required=True)
parser.add_argument('--releasever', action='store', help='Release version', required=True)
parser.add_argument('--whichyum', action='store', help='yum or microyuminst', required=True)

args = parser.parse_args()
if args.target == 'centos':
    if args.whichyum == 'microyum':
        cmd=['yum']
    else:
        cmd=['yum']
elif args.target == 'fedora':
    cmd=['dnf', '--setopt=install_weak_deps=False']
else:
    fatal("Unknown target {}".format(args.target))

imgname = args.target + '-' + args.releasever + '-' + args.whichyum + '-min'
tempdir = tempfile.mkdtemp('dockerbase')
root = tempdir + '/root'

try:
    for setopt in ['cachedir=' + os.getcwd() + '/cache',
                   'keepcache=1',
                   'tsflags=nodocs',
                   'override_install_langs=en',
                   'reposdir={}/repos-{}'.format(os.getcwd(), args.target)]:
        cmd.append('--setopt=' + setopt)
        
    if args.whichyum == 'microyum':
        cmd.extend(['-y', '--releasever=' + args.releasever,
            '--installroot={}'.format(root),
            'install',
            'micro-yuminst', '{}-release'.format(args.target)])
    else:
        cmd.extend(['-y', '--releasever=' + args.releasever,
            '--installroot={}'.format(root),
            'install',
            'yum','{}-release'.format(args.target)])
        
    run_sync(cmd)
    # We need to run this in target context in the general case       
    run_sync(['install', '-m', '0755', 'locales.sh', '{}/tmp'.format(root)])
    run_sync(['chroot', root, '/tmp/locales.sh'])
    run_sync(['./postprocess.sh', root])

    tarname = '{}.tar.gz'.format(imgname)
    try:
        os.unlink(tarname)
    except:
        pass
    run_sync(['tar', '--numeric-owner', '-zf', tarname, '-C', root, '-c', '.'])
finally:
    subprocess.call(['rm', '-rf', tempdir])
