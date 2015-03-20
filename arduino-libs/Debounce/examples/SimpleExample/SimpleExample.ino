#include <Debounce.h>

// This is the pin the button is connected to.
const int button_pin = 4;

// This is how long you think the button will bounce, in milliseconds.
const int debounce_time_ms = 10;

// Use one or the other of the lines below.
// If using the internal pullup on the atmega, 
// you'll want BUTTON_LOW_IS_PRESSED, and your button
// should short the pin to GND.
const int button_sense = BUTTON_LOW_IS_PRESSED;
// const int button_sense = BUTTON_HIGH_IS_PRESSED;


// Declare the button.  You can have as many as you like...
Debounce button(button_pin, button_sense, debounce_time_ms);
// Debounce button2(button2_pin, button2_sense, debounce_time_ms);

void setup()
{
	pinMode(button_pin, INPUT_PULLUP); 
}
void loop()
{
    ButtonEvent event = button.check();
    if (event.pressed()) {
        // This is true once per button press cycle, on press.
    }
    if (event.down()) {
        // This is true once per button press cycle, on release.
    }
    if (event.down()) {
        // This is true WHENEVER the button is down, regardless
        // of anything else.  This can be true MANY times per
        // press/release cycle.
    }
    if (event.up()) {
        // This is true WHENEVER the button is up, regardless
        // of anything else.  This will be true almost all the time
        // except whent he user is pressing the button.
    }
}
