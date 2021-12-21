# Szoftver:

## telepítés:
1. Böngészőben: Arduino Download -> **Arduino.cc**
2. Katt: Just download
3. Letölti a szoftvert, ezután már használható
4. Downloads--katt az exe filera--install

Arduino.cc-ről letölthetőek a különböző segédkönyvtárak is

**Szükséges segédkönyvtárak:**
- Adafruit-NEOpixel.h
- FirebaseESP8266.h
- ESP8266WiFi.h
- DHT.h

## szoftver használata:

**megfelelő board kiválasztása:**
- Tools-- Board-- Boards manager-- Megfelelő típus kiválasztása (pl. ESP8266)

**segédkönyvtárak kiválasztása:**
- Tools--Manage libraries--Library manager

**port kiválasztása az arduinohoz:**
- Tools--port-- *kiválaszt*


## A kód:
A kódban a kommenteléseket érdemes elolvasgatni, ezek segítik a fejlesztő munkáját, átláthatóbb a program

**Internet:**
- a kódban, Wifire való kapcsolódás előtt meg kell változtatni az SSID-t és a jelszót aktuálisra
 
**tesztelés:**
 -Tools--Serial monitor
 (*ezen keresztül ellenőrizhetjük, hogy a program hibátlanul fut*)



---
# Hardver:

## **Komponensek:**
1. Board: ESP8266
2. Breadboard: 3 db(*ez az alappanel, ide csatlakozik az összes komponens*)
3. NeoPixel LED: 2 db
4. DHT11 szenzor(*hőmérséklet és páratartalom érzékelő*)
6. Fotoellenállás(*fény hatására változik az ellenállása*)
7. PIR szenzor(*mozgásérzékelő*)
8. Jumper kábelek(*összeköttetés a komponensek között*)
9. Ellenállás(10Kohm)

### Felépítés:

1. A két breadboard közé helyezzük az arduino chipet, úgy, hogy a chip két első lába a két szélső, 12-ik portba csatlakozzon, a harmadik(*összeköttető*) breadbord pedig a chippel szemben helyezkedjen el.


3. ### Mozgásérzékelő:
- **Jel láb(Signal)** --> Digitális oldal(D7)port
(*zöld szín*)
- **Power láb(vcc)** --> összekötő board pozitív(+) oszlop)--> összekötő board negatív(-) oszlop
(*fekete szín*)

3. ### DHT11 szenzor:

- **Jel láb(Signal)** --> Digitális oldal(D3)port
(*zöld szín*)
- **Power láb(vcc)** --> összekötő board pozitív(+) oszlop
(*piros szín*)
- **Földelés láb(ground)** --> összekötő board negatív(-) oszlop
(*fekete szín*)

4. ### NeoPixel LED(első):

 - **Jel láb(Signal)** --> Digitális oldal(D4)port
(*kék szín*)
- **Power láb(vcc)** --> összekötő board pozitív(+) oszlop
(*sárga szín*)
- **Földelés láb(ground)** --> összekötő board negatív(-) oszlop
(*fekete szín*)

5. ### NeoPixel LED(második):

- **Jel láb(Signal)** --> Digitális oldal(D2)port
(*zöld szín*)
- **Power láb(vcc)** --> összekötő board pozitív(+) oszlop
(*piros szín*)
- **Földelés láb(ground)** --> összekötő board negatív(-) oszlop
(*fekete szín*)

6. ### Fotoellenállás(photoresistor):

- **Jel láb(Signal):**
Analóg oldali **breadboard** d2 port --> Analóg oldal(A0)port
(*kék szín*)
- **Power láb(vcc):**
Analóg oldali **breadboard** d3 port --> összekötő board pozitív(+) oszlop
(*piros szín*)
- **10kOhm ellenállás:**
 Analóg oldali **breadboard** c2 port --> összekötő board negatív(-) oszlop
 - **Fotoellenállás: **
 Analóg oldali **breadboard** e2 port-->Analóg oldali **breadboard** e3 port
 
 Az ezköz összerakásánál segítséget nyújthatnak a bekötési rajzok és a kódban szereplő kommentek is.

