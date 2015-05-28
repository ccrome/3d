#!/cygdrive/c/Anaconda/python
import time
import gphoto
import arduino_host
import sys
from sys import stdout

def debug_message(message):
    print "DEBUG: %s" % message
    stdout.flush()
    pass



class DeepFocusMacro:
    def __init__(self, rotobot_com_port, gphoto_location, photo_directory, delay_after_moving = 0):
        self.rb = arduino_host.ArduinoHost(rotobot_com_port)
        self.gp = gphoto.Gphoto(gphoto_location, photo_directory)
        self.delay_after_moving = delay_after_moving
        
    def scan(self,
             servo_steps,     # Count of steps to take on the servo
             servo_start,     # Servo start position
             servo_stepsize,  # angle of servo step.
             stepper_steps,   # number of steps to send to the stepper on each angle change
             stepper_angles   # the number of angles to photograph
    ):
        debug_message("starting scan")
        for angle in range(stepper_angles):
            for step in range(servo_steps):
                id = "%03d_%03d" % (angle, step)
                time.sleep(self.delay_after_moving)
                debug_message("taking photo %s" % id)
                self.rb.servo(servo_start+(step*servo_stepsize))
                self.gp.take_photo(id)
                debug_message("next step")
            self.rb.step(stepper_steps)
            debug_message("next angle")
        debug_message("scan complete")
        self.rb.servo(30)
    def quit(self):
        pass


if __name__ == '__main__':

    import argparse
    import sys
    def get_args():
        parser = argparse.ArgumentParser("Run the deep focusing rotobot.")
        parser.add_argument("angles", help="the number of angles to capture in the specified rotation angle", type=int)
        parser.add_argument("output-dir", help="output directory", required=True)
        parser.add_argument("--arduino-com-port", help="Arduino com port.  Defaults to COM5", type=str, default='COM5')
        parser.add_argument("--gphoto-location", help="Gphoto location.  defaults to c:\\progs\\gphoto2", default="c:\\progs\\gphoto2")
        parser.add_argument("--servo-start", help="servo start angle.  default is 30.", type=int, default=30)
        parser.add_argument("--servo-end", help="servo stop angle.  Default 130.", type=int, default=130)
        parser.add_argument("--servo-steps", help="Number of steps for the servo to take between servo_start and servo_end, default=10", default=10, type=int)
        parser.add_argument("--delay-after-moving", help="Time (in seconds) to delay after moving the rotobot to let things settle.  Default is 1.0", type=float, default=1.0)
        return parser.parse_args()
    sys.exit()
    args          = get_args()
    angles        = args.angles 
    servo_start   = args.servo_start
    servo_end     = args.servo_end
    servo_steps   = args.servo_steps

    df = DeepFocusMacro(rotobot_com_port   = args.arduino_com_port,
                        gphoto_location    = args.gphoto_location,
                        photo_directory    = args.output_dir,
                        delay_after_moving = args.delay_after_moving)

    servo_dist    = servo_end-servo_start
    steps_per_rev = 64*32
    servo_stepsize = int(servo_dist/servo_steps)

    print "going to start scan, hit ENTER when ready."
    try:
        df.rb.servo(30)
        raw_input("Position your insect so that it's just barely too close to the camera lens.  Then press enter.")

        df.scan(servo_steps    = servo_steps,
                servo_start    = servo_start,
                servo_stepsize = servo_stepsize,
                stepper_steps  = steps_per_rev/angles,
                stepper_angles = angles,
        )
    except Exception as e:
        print e
