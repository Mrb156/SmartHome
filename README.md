# Okosház vezérlő rendszer
## Projekt leírás
Ebben a projektben egy okos otthon belső szabályozását, és vezérlését modellezzük. A "ház" egy NodeMCU, melyhez különböző hardver elemeket kötve reprezentáljuk egy otthon komponenseit (világítás, fűtés). Minden adat felhőben tárolódik. Maga a vezérlést okostelefonos alkalmazással valósítjuk meg, mellyel a Világ bármely részéről irányíthatóvá válik az otthon. 3 fő elemből áll a megvalósítás. Van egy biztonsági rendszer, egy állítható világítás, valamint fűtés, illetve termosztát.
## Alkalmazás rövid bemutatása
Az alkalmazást Flutter keretrendszerben készítettük el, Dart programozási nyelv segítségével. Az app megnyitása után a főoldal fogad minket, ahol a főbb komponensek ki-/ bekapcsolhatók, valamint néhány fontos információ látható rajtuk. A főoldal másik részén láthatók a biztonsági értesítések. Ezek a szenzor által küldött adatokat mutatják, vagyis, hogy a szenzor mikor kapcsolt be. Innen navigálhatunk tovább az egyes összetevők részletes felületeire, ahol azok beállításait tudjuk módosítani.
## Adatbázis rövid leírása
Adatbázisnak egy felhő alapú szolgáltatást veszünk igénybe. A Firebase a Google szerverein hosztolt NoSQL adatbázis. A herdverelemek, és az applikáció is ide küld adatokat, és innen is olvassa ki őket, valamint dolgozza fel. Nagy előnye, hogy valós időben és dinamikusan képes adatokat kezelni.
## Hardver rövid leírása
A vezérlés alapja egy NodeMCU esp8266 chippel, mely a hálózati elérést valósítja meg. Ehhez csatlakozik egy 8 LED-ből álló NeoPixel ledcsík, mely a ház világítását reprezentálja. Egy másik ilyen ledcsík a radiátor szerepét tölti be. Található még egy hőmérséklet/ páratartalom érzékelő is, valamint egy fotoellenállás, mellyel a világítás automatikus fényerősség-állítását valósítjuk meg. Ezeken kívül pedig egy infra mozgásérzékelő a biztonsági rendszerhez. Ennek programozását Arduino IDE fejlesztő környezetben végeztük.
## Bővebb szakmai leírást a wiki oldalak tartalmaznak!
