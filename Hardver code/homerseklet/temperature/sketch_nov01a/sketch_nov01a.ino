#include <DHT.h>
 
#define DHTPIN D3
#define DHTTYPE DHT11
 
DHT dht(DHTPIN, DHTTYPE);
 
void setup() {
  Serial.begin(9600);
  dht.begin();
}
 
void loop() {
  Serial.print("Humidity: ");
  Serial.print(dht.readHumidity());
  Serial.print("%  Temperature: ");
  Serial.print(dht.readTemperature());
  Serial.println("°C ");
 
  delay(1000);
}
