assert __name__ == "__main__"

import sys
import os
import subprocess
import shutil

from . import config

os.chdir('node-{}'.format(config.nodeVersion))

configureArgvs = [ '--enable-static' ] + config.configFlags

if sys.platform == 'win32':
    env = os.environ.copy()
    env['config_flags'] = ' '.join(configureArgvs)

    args = ['cmd', '/c', 'vcbuild.bat']
    if config.x86:
        args.append('x86')
    args.append('vs2019')
    subprocess.check_call(args, env=env)
    
else:
    subprocess.check_call([ sys.executable, 'configure.py' ] + configureArgvs)
    subprocess.check_call(['make', '-j4'])
