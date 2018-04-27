#! /usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import falcon

from logging.handlers import RotatingFileHandler

from .umount import Umount
from .stats import Stats

log_formatter = logging.Formatter('[%(asctime)s] [%(process)d] [%(levelname)s] %(message)s', '%Y-%m-%d %H:%M:%S %z')

log_file = '/run/rest_server/rest_server.log'
file_handler = RotatingFileHandler(log_file, maxBytes=5 * 1024 * 1024)
file_handler.setLevel(logging.WARNING)
file_handler.setFormatter(log_formatter)

stdout_handler = logging.StreamHandler()
stdout_handler.setFormatter(log_formatter)

root_logger = logging.getLogger('rest_server')
root_logger.addHandler(file_handler)
root_logger.addHandler(stdout_handler)
root_logger.setLevel(logging.INFO)

logger = logging.getLogger('rest_server')
logger.warn('Starting...')

app = application = falcon.API()

umount = Umount()
stats = Stats()

app.add_route('/umount/{label}', umount)
app.add_route('/stats/{resource}', stats)

