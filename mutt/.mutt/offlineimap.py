import subprocess
from os.path import expanduser


def decrypt(keyword):
    home = expanduser("~")
    path = home + "/.mutt/offlineimap_" + keyword + ".gpg"
    args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", path]
    proc = subprocess.Popen(args, stdout=subprocess.PIPE)
    output = proc.communicate()[0].strip()
    retcode = proc.wait()
    if retcode == 0:
        return output
    else:
        return ''
