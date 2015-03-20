/* 
 * Debounce.h
 * Arduino Button Debouncing 
 * 
 * Easy to use button debouncing for arduino.  
 * 
 * Usage:
 * 1) Create a Debounce instance:
 *      Debounce button(4, BUTTON_LOW_IS_PRESSED, 10);
 *      tells the library to read from pin 4, that when the button
 *      is pressed, the pin goes low, and to put in a 10ms debounce
 *      time
 * 2) in setup() remember to configure your input (perhaps with this)
 *      pinMode(4, INPUT_PULLUP); 
 * 3) in loop(), simply call button.check() thusly:
 *      ButtenEvent event = button.check()
 *      if (event.pressed()) {
 *          // do something when pressed.
 *          // this is only true once for each button press
 *      }
 *      if (event.released()) {
 *          // do something when released if you want
 *          // this is only true once for each button press
 *      }
 *      if (event.down()) {
 *          // This is true whenever the button is down.
 *      }
 *      if (event.up()) {
 *          // This is true whenever the button is up.
 *      }
 */


#ifndef _DEBOUNCE_H
#define _DEBOUNCE_H
#define  BUTTON_PRESSED   1
#define  BUTTON_RELEASED  2
#define  BUTTON_DOWN      4
#define  BUTTON_UP        8

#define BUTTON_LOW_IS_PRESSED  0
#define BUTTON_HIGH_IS_PRESSED 1


typedef enum {
    DB_HIGH            = 0,
    DB_DEBOUNCE_H_L    = 1,
    DB_LOW             = 2,
    DB_DEBOUNCE_L_H    = 3,
} Debounce_state_t;

class ButtonEvent {
public:
    ButtonEvent(unsigned _state) {
        state = _state;
    }
    int down() {
        return (state & BUTTON_DOWN);
    }
    int up() {
        return (state & BUTTON_UP);
    }
    int pressed() {
        return (state & BUTTON_PRESSED);
    }
    int released() {
        return (state & BUTTON_RELEASED);
    }
    unsigned state;
protected:
};

class Debounce {
public:
    int pin;
    unsigned long Debounce_time_ms;
    unsigned long last_time;
    Debounce(int _pin, int _pressed_type, int _Debounce_time_ms = 10);
    ButtonEvent check();
    Debounce_state_t Debounce_state;  
protected:
    unsigned phase;
};
#endif
