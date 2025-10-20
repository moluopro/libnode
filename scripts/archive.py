assert __name__ == "__main__"

import shutil
import sys
import os
from . import config

zipBasename = 'libnode-{}-{}-{}{}'.format(
    config.nodeVersion,
    sys.platform,
    'x64' if config.x64 else ('x86' if sys.platform == 'win32' else 'arm64'),
    config.zipBasenameSuffix
)

source_dir = os.path.join('libnode', 'lib')

shutil.make_archive(
    zipBasename,
    'zip',
    root_dir=source_dir,
    base_dir='.'
)

print(zipBasename + '.zip')
