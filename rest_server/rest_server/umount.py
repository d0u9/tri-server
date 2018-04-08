#! /usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import json
import falcon
import subprocess

from shlex import quote

from time import sleep
from filelock import FileLock, Timeout

logger = logging.getLogger('rest_server')
lock_file = '/run/rest_server/lock.lock'
umount_scripts = '/usr/local/bin/tri-umount'

class Umount(object):
    def __init__(self):
        self.label = None
        self.lock = FileLock(lock_file, timeout=1)

    def on_get(self, req, resp, label):
        logger.warn('Umount disk: %s', label)

        self.lock.acquire()
        r = subprocess.run('/bin/sudo' + ' ' + umount_scripts + ' ' + quote(label),
                           stdout=subprocess.PIPE,
                           stderr=subprocess.STDOUT,
                           encoding='utf-8', shell=True)
        logger.warn(r.args)
        self.lock.release()
        stdout = r.stdout.rstrip()

        if r.returncode is 0:
            resp_body = { 'status': 'OK' }
            status = falcon.HTTP_200
        elif r.returncode is 1:
            logger.error('Umount %s error: %s', label, stdout)
            resp_body = { 'error': 'No such file or directory: ' + label }
            status = falcon.HTTP_404
        else:
            logger.error('Umount %s error: %s', label, stdout)
            resp_body = { 'error': r.stderr }
            status = falcon.HTTP_500

        resp.body = json.dumps(resp_body, ensure_ascii=False)
        resp.status = status

