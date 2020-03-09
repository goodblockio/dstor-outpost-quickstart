#!/usr/bin/env python3

import subprocess
import os
import sys
from pathlib import Path
import pystache
import datetime
import base64

now = datetime.datetime.now()

handles = {
  'YEAR': now.year
}

try:
  handles['REPO_TITLE'] = os.environ['REPO_TITLE']
  handles['REPO_NAME'] = os.environ['REPO_NAME']
  handles['RELEASE'] = os.environ['RELEASE']
  handles['MINOR'] = os.environ['MINOR']
  handles['PATCH'] = os.environ['PATCH']
  handles['REPO_PATH'] = os.environ['REPO_PATH']
  handles['DEVELOPER'] = os.environ['DEVELOPER']
except:
  print("Error: %s\n" %  sys.exc_info()[0])
  print("Is direnv working correctly?\n")
  os.Exit(1)


def load_snippets():
  res = subprocess.getoutput("cd / && find %s/repo/snippets -type f -not -path '*/\.*'" % handles['REPO_PATH'])
  overlay = str.split(res, '\n')

  for file in overlay:
    # Reverse the full path, cut the short name off, reverse back
    v = str.split(file[::-1],'/')[0][::-1]
    handles[v] = Path(file).read_text()

def load_commit_count():
  handles['COMMIT_COUNT'] = int(subprocess.getoutput("git rev-list --count HEAD"))

def load_branch():
  handles['BRANCH'] = subprocess.getoutput("git branch | egrep '^\*' | rev | cut -d'/' -f1 | cut -d' ' -f1 | rev")


def load_version():
  branch = str.split(subprocess.getoutput("git branch|grep '^*'|cut -d' ' -f2"),'/')
  if branch[0] == 'master' or branch[0] == 'release':
    handles['VERSION'] = "%s.%s.%s" % (handles['RELEASE'], handles['MINOR'], handles['PATCH'])
    handles['DEV_VERSION'] = ""
  else:
    handles['VERSION'] = "%s.%s.%s-%s%d" % (handles['RELEASE'], handles['MINOR'], handles['PATCH'], handles['BRANCH'], handles['COMMIT_COUNT'])
    handles['DEV_VERSION'] = base64.b32encode(bytearray("%s.%s" % (handles['DEVELOPER'], now),'ascii')).decode('utf-8')

def update_repo():
  res = subprocess.getoutput("cd / && find %s/repo/root -type f -not -path '*/\.*'" % handles['REPO_PATH'])
  overlay = str.split(res, '\n')

  for template in overlay:
    t = Path(template).read_text()
    d = str.split(template,'repo/root/')[1]
    #print("%s -> %s/%s:\n%s" % (template, handles['REPO_PATH'], d, pystache.render(t,handles)))
    mye = lambda u: u
    Path("%s/%s" % (handles['REPO_PATH'], d)).write_text(pystache.render(t,handles, escape=mye ))
    subprocess.getoutput("git add %s/%s" % (handles['REPO_PATH'], d))

start_dir = os.getcwd()

load_commit_count()
load_branch()
load_version()
load_snippets()

#####

update_repo()

#print(handles)
#fh = Path('../root/README.md').read_text()
#print(pystache.render(fh,handles))

os.chdir(start_dir)
