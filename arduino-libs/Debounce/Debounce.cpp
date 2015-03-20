#ifndef _DEBOUNCE_CPP
#define _DEBOUNCE_CPP
#include "Arduino.h"
#include "Debounce.h"
Debounce::Debounce(int _pin, int _pressed_type, int _Debounce_time_ms) {
    pin = _pin;
    Debounce_time_ms = _Debounce_time_ms;
    last_time = millis();
    phase = _pressed_type;
    int button = digitalRead(pin);
    if (phase == BUTTON_HIGH_IS_PRESSED)
        button = !button;
    if (button)
        Debounce_state = DB_HIGH;
    else
        Debounce_state = DB_LOW;
}

ButtonEvent Debounce::check() {
    int button = digitalRead(pin);
    if (phase == BUTTON_LOW_IS_PRESSED)
        button = !button;
    unsigned  event;
    if (button) {
        event = BUTTON_UP;
    } else {
        event = BUTTON_DOWN;
    }
    switch (Debounce_state) {
    case DB_HIGH:
        if (!button) {
            Debounce_state = DB_DEBOUNCE_H_L;
            last_time = millis();
            event |= BUTTON_PRESSED;         
        }
        break;
    case DB_DEBOUNCE_H_L:
        if (millis() > last_time + Debounce_time_ms) {
            Debounce_state = DB_LOW;
        }
        break;
    case DB_LOW:
        if (button) {
            Debounce_state = DB_DEBOUNCE_L_H;
            last_time = millis();
            event |= BUTTON_RELEASED;
        }
        break;
    case DB_DEBOUNCE_L_H:
        if (millis() > last_time + Debounce_time_ms) {
            Debounce_state = DB_HIGH;
        }
        break;
    }
    ButtonEvent e(event);
    return e;
}

#endif
