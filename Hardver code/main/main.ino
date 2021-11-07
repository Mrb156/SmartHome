//alapkönyvtárak
#include "FirebaseESP8266.h"
#include <Adafruit_NeoPixel.h>
#include <ESP8266WiFi.h>

#include <DHT.h>

//led inicializálás
#define PIN       D2
#define NUMPIXELS 8

#define DHTPIN D3
#define DHTTYPE DHT11

Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);
DHT dht(DHTPIN, DHTTYPE);

//hálózat beállítása
const char* ssid = "Vodafone-4DBE";
const char* password = "Cc5fvxrdsuEr";

FirebaseData firebaseData;

//sftw led beállítás


//LED változók
uint8_t redValue = 100;
uint8_t greenValue = 100;
uint8_t blueValue = 100;
uint8_t brightness = 50;
bool isAuto = false;
bool LEDisOn = true;

//fényérzékelőhöz a változók
const int sensorPin = A0;
int sensorMin = 1023; 
int sensorMax = 0; 
int sensorValue = 0;


unsigned long sendDataPrevMillis1;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  Firebase.begin("smarthome-335e5-default-rtdb.europe-west1.firebasedatabase.app", "OMwMInlPA7HzxP8Nu1xcC6pmevQUrDQAhhBKRCdy");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  dht.begin();
  pixels.begin();

  pinMode(sensorPin, INPUT);
  sensorValue = analogRead(sensorPin);

   pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  while (millis() < 3000) {
    sensorValue = analogRead(sensorPin);

    // maximum szenzorérték beállítása
    if (sensorValue > sensorMax) {
      sensorMax = sensorValue;
    }

    // minimum szenzorérték beállítása
    if (sensorValue < sensorMin) {
      sensorMin = sensorValue;
    }
  }
  digitalWrite(LED_BUILTIN, LOW);
   
  if(Firebase.getBool(firebaseData,"/Control/LED control/Auto") != isAuto){
    isAuto = firebaseData.boolData();
  }
  if(Firebase.getInt(firebaseData,"/Control/LED control/Brightness") != 0){
    LEDisOn = true;
    
  }
  else{
    LEDisOn = false;
  }
  
}

void temp(){
  Serial.print("Humidity: ");
  Serial.print(dht.readHumidity());
  Serial.print("%  Temperature: ");
  Serial.print(dht.readTemperature());
  Serial.println("°C ");
 
  delay(1000);
  Firebase.setFloat(firebaseData,"/Control/Heating/currTemp", dht.readTemperature());
 
}
  
unsigned long sendDataPrevMillis = 0;

void autoLed(){
  sensorValue = analogRead(sensorPin);
  sensorValue = map(sensorValue, sensorMin, sensorMax, 0, 100);
  sensorValue = constrain(sensorValue, 0, 100);
    
  pixels.setBrightness(sensorValue);

  for(int i=0; i<NUMPIXELS; i++) {
    pixels.setPixelColor(i, pixels.Color(redValue, greenValue, blueValue));
  }
  pixels.show();
}

void led(){
  pixels.setBrightness(brightness);

  for(int i=0; i<NUMPIXELS; i++) {
    pixels.setPixelColor(i, pixels.Color(redValue, greenValue, blueValue));
  }
  pixels.show();
}

void Change() {
  if(Firebase.getBool(firebaseData,"/Control/LED control/Auto")){
    if(firebaseData.boolData() == true){
      isAuto = true;
    }
    else{
      isAuto = false;
    }  
  }
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

void loop() {
  if(brightness != 0){
    if(isAuto == true){
      autoLed();
    }
    else if(isAuto == false){
      led();    
    }
  }
  
    if (millis() - sendDataPrevMillis > 1500)
  {
    Serial.println("check");
    Change();
    sendDataPrevMillis = millis();
  }
}
