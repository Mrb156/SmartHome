//alapkönyvtárak
#include "FirebaseESP8266.h"
#define FASTLED_ALLOW_INTERRUPTS 0
#include <Adafruit_NeoPixel.h>
#include <ESP8266WiFi.h>

//led inicializálás
#define PIN        D2
#define NUMPIXELS 8

Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

//hálózat beállítása
const char* ssid = "Galaxy S10 MrB";
const char* password = "Morvai15";

FirebaseData firebaseData;

//sftw led beállítás


//alap változók
uint8_t redValue = 100;
uint8_t greenValue = 100;
uint8_t blueValue = 100;
uint8_t brightness = 0;


unsigned long sendDataPrevMillis1;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  Firebase.begin("smarthome-335e5-default-rtdb.europe-west1.firebasedatabase.app", "OMwMInlPA7HzxP8Nu1xcC6pmevQUrDQAhhBKRCdy");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  #if defined(_AVR_ATtiny85_) && (F_CPU == 16000000)
  clock_prescale_set(clock_div_1);
#endif

  pixels.begin();
}


void loop() {
  Change();
    
    pixels.setBrightness(brightness);

  for(int i=0; i<NUMPIXELS; i++) {
    pixels.setPixelColor(i, pixels.Color(redValue, greenValue, blueValue));
    pixels.show();
  }
}

void Change() {
  if (Firebase.getInt(firebaseData, "/Control/LED control/Colors/Red") != redValue) {
    redValue = firebaseData.intData();
  }


  if (Firebase.getInt(firebaseData, "/Control/LED control/Colors/Green") != greenValue) {
    greenValue = firebaseData.intData();
  }


  if (Firebase.getInt(firebaseData, "/Control/LED control/Colors/Blue") != blueValue) {
    blueValue = firebaseData.intData();
  }

  if (Firebase.getInt(firebaseData, "/Control/LED control/Brightness") != brightness) {
    brightness = firebaseData.intData();
  }

}