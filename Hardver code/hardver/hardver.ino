

#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
 #include <avr/power.h> 
#endif

#define PIN       4


#define NUMPIXELS 8 


Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

#define DELAYVAL 800

void setup() {

#if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
  clock_prescale_set(clock_div_1);
#endif
  

  pixels.begin(); 
}

void loop() {
  pixels.clear(); 
  pixels.setBrightness(10);
  pixels.show();
  for (int i=0;i<NUMPIXELS;i++){
    pixels.setPixelColor(i,pixels.Color(255,0,0));
    pixels.show();
    }

  pixels.clear();
  
/*for(int i=0;i<NUMPIXELS/2;i++){
  pixels.setPixelColor(i,pixels.Color(255,255,255));
  pixels.setPixelColor((NUMPIXELS-1-i),pixels.Color(255,255,255));
  pixels.show();
  
  delay(DELAYVAL);
  pixels.clear();
  }*/
  
/*for(int i=0;i<NUMPIXELS;i+=2){
  pixels.setPixelColor(i,pixels.Color(255,255,255));
  pixels.show();

  delay(DELAYVAL);
  pixels.clear();

  }

  for(int i=1;i<NUMPIXELS;i+=2){
  pixels.setPixelColor(i,pixels.Color(255,255,255));
  pixels.show();

  delay(DELAYVAL);
  pixels.clear();

  }*/
  
  
 

 
  /*for(int i=0; i<NUMPIXELS; i++) { 
      pixels.setPixelColor(i, pixels.Color(0,150,0));
      

    pixels.show();  

    delay(DELAYVAL);
          pixels.clear(); */
 
  

}
