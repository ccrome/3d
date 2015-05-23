#!/cygdrive/c/Anaconda/python
import glob
import subprocess
import sys
class PhotoStitcher:
    def __init__(self, hugin_dir):
        self.directory = hugin_dir
    def align(self, file_list, output_prefix):
        cmd = [
            "%s/align_image_stack.exe" % self.directory,
            "-m",
            "-a", output_prefix]
        cmd.extend(file_list)
        subprocess.call(cmd)
ps = PhotoStitcher('c:/Program Files/Hugin/bin')
ps.align(file_list = glob.glob("photos/*.jpg"),
         output_prefix =      "workdir/0.000000_0.000000_")


