#!/cygdrive/c/Anaconda/python
import subprocess
import os
import shutil

class Gphoto:
    def __init__(self, gphoto_dir, photo_dir):
        self.gphoto_dir = gphoto_dir
        self.photo_dir = photo_dir
        try:
            os.makedirs(photo_dir)
        except WindowsError:
            pass # okay if it already exists.
        self.gphoto = "%s\\%s" % (gphoto_dir, "gphoto2.exe")
        self.env = {"CAMLIBS" : "%s\\camlibs" % self.gphoto_dir,
                    "IOLIBS"  : "%s\\iolibs"  % self.gphoto_dir,
                    "CYGWIN"  : "nodosfilewarning",
        }
        
    def take_photo(self, photo_identifier_string):
        cmd = [self.gphoto, "--capture-image-and-download", "--force-overwrite"]
        env = self.env
        sub =  subprocess.Popen(cmd, env=env, shell=False)
        sub.wait()
        #Move the photo into the right place, with the right name
        shutil.copy("capt0000.jpg", "%s/%s.jpg" % (self.photo_dir, photo_identifier_string))

if (__name__ == '__main__'):
    gp = Gphoto("c:\\progs\\gphoto2", ".")
    gp.take_photo("test_photo")
