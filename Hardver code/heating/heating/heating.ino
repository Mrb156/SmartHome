  #include <Adafruit_NeoPixel.h>
  
  #define PIN       D3
  #define NUMPIXELS 8
  
  Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);
  
  void setup() {
    Serial.begin(9600);
    pixels.begin();
    pixels.show();
    // put your setup code here, to run once:
  
  }
  int hue=255;
  void loop() {
heating();
  }

void heating(){
  int red = 0;
  int green = 0;
  int blue = 255;
  delay(2000);
  for(int i = green; i<=255; i++){
    pixels.fill(pixels.Color(red, green, blue));
    pixels.show();
    green = i;
    delay(20);
  }
 for(int i = blue; i>=0; i--){
    pixels.fill(pixels.Color(red, green, blue));
    pixels.show();
    blue = i;
    delay(20);
  }
  for(int i = red; i<=255; i++){
    pixels.fill(pixels.Color(red, green, blue));
    pixels.show();
    red = i;
    delay(20);
  }
   for(int i = green; i>=0; i--){
    pixels.fill(pixels.Color(red, green, blue));
    pixels.show();
    green = i;
    delay(20);
  }
  delay(2000);
}
  
void egy(){
for(int i=32768; i>=0; i--){
    pixels.fill(pixels.ColorHSV(i)); 
    //delay(15);
    pixels.show();
  }
}
