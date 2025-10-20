assert __name__ == "__main__"

import sys
import os
import subprocess
import shutil

from . import config

os.chdir(f'node-{config.nodeVersion}')

configureArgvs = [ '--enable-static' ] + config.configFlags

if sys.platform == 'win32':
    env = os.environ.copy()
    env['config_flags'] = ' '.join(configureArgvs)

    args = ['cmd', '/c', 'vcbuild.bat']
    if not config.x64:
        args.append('x86')
    if config.nodeVersion.startswith('v16.16'):
        args.append('vs2019')
    subprocess.check_call(args, env=env)

elif sys.platform == 'darwin':
    target_cpu = 'x64' if config.x64 else 'arm64'
    target_arch = 'x86_64' if config.x64 else 'arm64'
    env = os.environ.copy()

    for k in ('CFLAGS', 'CXXFLAGS', 'LDFLAGS'):
        env[k] = (env.get(k, '') + f' -arch {target_arch}').strip()

    if target_cpu == 'x64':
        subprocess.check_call(['arch', '-x86_64', sys.executable, 'configure.py']
                              + configureArgvs + [f'--dest-cpu={target_cpu}'], env=env)
        subprocess.check_call(['arch', '-x86_64', 'make', '-j4'], env=env)
    else:
        subprocess.check_call([sys.executable, 'configure.py'] + configureArgvs + [f'--dest-cpu={target_cpu}'], env=env)
        subprocess.check_call(['make', '-j4'], env=env)

else:
    subprocess.check_call([ sys.executable, 'configure.py' ] + configureArgvs)
    subprocess.check_call(['make', '-j4'])
