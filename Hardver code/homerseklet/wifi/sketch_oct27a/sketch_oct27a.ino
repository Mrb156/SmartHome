#include <Arduino.h>
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
#include <Adafruit_NeoPixel.h>

#define PIN       D2
#define NUMPIXELS 8 

Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "OSK_8C81"
#define WIFI_PASSWORD "GXXO2KQKMA"

// Insert Firebase project API Key
#define API_KEY "OMwMInlPA7HzxP8Nu1xcC6pmevQUrDQAhhBKRCdy"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "smarthome-335e5-default-rtdb.europe-west1.firebasedatabase.app" 

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;

uint8_t red = 0;

void setup(){
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  Firebase.RTDB.getInt(&fbdo, "Control/LED control/Colors/Red");
  red = fbdo.intData();
    pixels.begin(); 
}

uint8_t green = 0;
uint8_t blue = 0;

void loop(){
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)){
    sendDataPrevMillis = millis();
    // Write an Int number on the database path test/intDatapixels.clear(); 
  pixels.setBrightness(10);
 
  for (int i=0;i<NUMPIXELS;i++){
    pixels.setPixelColor(i,pixels.Color(red,0,0));
    pixels.show();
    }
  }
}
