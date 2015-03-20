#include <Debounce.h>
const int button_pin = 4;
const int debounce_time_ms = 10;
const int button_sense = BUTTON_HIGH_IS_PRESSED;

Debounce button(button_pin, button_sense, debounce_time_ms);

#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
unsigned pressed_count = 0;
unsigned down_count = 0;
void setup()
{
  lcd.init();                      // initialize the lcd 
 
  // Print a message to the LCD.
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Pressed Down");
  pinMode(4, INPUT_PULLUP); 

}

unsigned loop_count = 0;
void loop()
{
  ButtonEvent event = button.check();
  if (event.pressed()) {
    pressed_count++;
  }
  if (event.down()) {
    down_count++;
  }
  if ((loop_count++ % 10000) == 0)
  {
    lcd.setCursor(0, 0);
    lcd.print(button.Debounce_state);
    lcd.setCursor(0, 1);
    lcd.print("                ");
    lcd.setCursor(0, 1);
    lcd.print(pressed_count);
    lcd.setCursor(8, 1);
    lcd.print(down_count);
  }
}

