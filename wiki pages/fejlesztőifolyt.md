# Fejlesztői dokumentáció SmartHome applikációhoz

## Technológia és általános leírás

Az applikáció Android rendszerre készül, mivel iOS fejlesztésre nincs lehetőségünk. Ettől függetlenül Flutter keretrendszert használtam, mely egy neutral technológia.  
Flutter a Google fejlesztése, ebből kifolyólag remekül együtt tud működni az adatbázissal, a Firebase-zel, mely szintén a Google-é (ld. később). Nagyon részletesen nem szeretnék kitérni, hogy hogyan épül fel egy alkalmazás, de ami lényeges a projekt szempontjából, az mindenképp leírásra kerül. Emellett a forráskód is commentelve van a megfelelő helyeken.  
Flutter-ben minden elem egy un. widget. Erre a szóra többször is fogok hivatkozni a leírás során.

## Alkalmazás felépítése
Ebben a részben egy rövid bemutatást tartok a szoftver felépítéséről. Erről részletesen a felhasználói dokumentációban lesz szó.
Az alkalmazás megnyitása után a főoldalon megjelnnek az eddigi biztonsági riasztások egy listában. Itt megjelnik még egy kapcsoló, mellyel ki lehet kapcsolni a rendszert, ha szeretnénk. Az un. *bottom navigation bar*-on találhatók a vezérlő oldalak. Baloldalon a **Color Picker**, középen van a **Főoldal**, jobb oldalon pedig a **Heating**, vagyis a termosztát.  
A **Color Picker** oldalon található egy color picker, mellyen szín állítható, egy fényerőszabályzó csúszka, valamint egy gomb, mellyel kikapcsolható, illetve bekapcsolható a LED csík.  
A **Heating** oldalon egy hőmérsékletszabályzó, és a jelenlegi hőmérséklet látható.

## Forráskód struktúrája, és kódleírás
A *lib* mappában találhatóak a fájlok, és mappák, amik nekünk szükségesek. Ezeket fogom felsorolni elérési útjuk szerint.  
Az egyik legfontosabb fájl a projektben a *pubspec.yaml*. Ez tartalmazza az összes külső beimportálandó könyvtárakat, melyeket az app igénybe vesz. Ez a projekt mappájában, kívül található.
#### pubspec.yaml
Most csak azokat a könyvtárakat jelenítem meg, melyek nem automatikusan, a projekt létrehozásakor kerülnek bele a fájlba, hanem manuálisan kell beírni őket. A nevük mellett a verziók láthatók. Ezek beimportálása a megfelelő fájlba, mindig a fájl legtetején történjen meg!
```
  cloud_firestore: ^2.5.3
  flutter_colorpicker: ^0.6.0
  firebase_database: ^8.0.1
  firebase_core: ^1.8.0
  sleek_circular_slider: ^2.0.1
  flutter_circular_slider : 
  flutter_local_notifications: ^9.0.2
  rxdart: ^0.27.1
```

### /lib/objects
Itt található fájlok tartalmazzák azokat az objektumokat, melyek megjelennek az alkalmazás oldalain. _buttons.dart_-ban vannak a gombok, _cards.dart_-ban pedig a kártyák, de főleg csak a biztonsági értések kártyája.

#### buttons.dart
Ez a gomb vezérli a ki-bekapcsolását egy-egy elemnek. A **TurnOnOffButton** egy un. _StatefulWidget_. Kétféle widget-féle létezik, egyik az előbb említett. A másik a _StatelessWidget_. Utóbb nem képes változni futás során. Ennél az eleménél azért van szükség az elsőre, mert attól függően, hogy az adott vezérlés be-, vagy ki van kapcsolva, más felirat, illetve más ikon jelenik meg a gombon. Paraméterként a függvényt, a kikapcsolt, és a bekapcsolt ikonokat, valamint a kapcsolat állását várja. Ezeket minde kötelező megadni, ezáltal elkerülhető, hogy a kód abnormálisan fusson le.
``` 
class TurnOnOffButton extends StatefulWidget {
  Function onPressed;
  bool iconIsOn = true;
  Icon iconOn;
  Icon iconOff;
  TurnOnOffButton(
      {Key? key,
      required this.iconOn,
      required this.iconOff,
      required this.onPressed,
      required this.iconIsOn})
      : super(key: key);

  @override
  State<TurnOnOffButton> createState() => _TurnOnOffButtonState();
}

class _TurnOnOffButtonState extends State<TurnOnOffButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            widget.iconIsOn = !widget.iconIsOn;
          });
          widget.onPressed();
        },
        icon: widget.iconIsOn ? widget.iconOn : widget.iconOff,
        label: Text(widget.iconIsOn ? 'On' : 'Off'));
  }
}
```  
Ez a gomb az, amelyik elküldi az adatokat az adatbázisba a LED csík beállításához. Paraméterként egy függvényt vár el, melyet kötelező megadni, ez akár egy üres függvény is lehet a futó kódon belül.
```
class SendButton extends StatelessWidget {
  final Function onPressed;
  const SendButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: const Text('Set color'),
    );
  }
}
```  
#### cards.dart
Ebben van a biztonsági értesítéseket megjelenítő kártya kódja.
```
class AlertCard extends StatefulWidget {
  String date;
  AlertCard({Key? key, required this.date}) : super(key: key);

  @override
  _AlertCardState createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(widget.date),
      ),
    );
  }
}
```
### /lib/services
A services mappa tartalmazza főleg azokat a fájlokat, és függvényeket, melyek az adatbázis elérésével, és azzal való kapcsolattartásával foglalkoznak. Az adatbázis működéséről, és struktúrájáról egy másik dokumentációban lesz szó. Itt csupán a függvények működését és logikáját magyarázom. Röviden, az adatbázis egy _noSQL_ adatbázis, amiben elérési utakat használunk az objektumok eléréséhez.  
A függvények egy osztályban vannak összegyűjtve, amely csak formaság, és az átláthatóság miatt van, mivel nincsenek kihasználva előnyei.

#### realtimeDatabaseService.dart
Szükséges importálni a megfelelő package-t ahhoz, hogy tudjuk használni a Firebase által nyújtott függvényeket.
```
import 'package:firebase_database/firebase_database.dart';
```
Elsőkörben inicializálni kell egy "referenciát", amely eléri az adatbázis API-ját, ezt el kell tárolni egy változóban, és arra kell hivatkozni elérési úttal.
```
final databaseReference = FirebaseDatabase.instance.reference();
```  
Minden függvény egy un. _Future_, amely lényegében egy aszinkron metódus. Ennek lényege, hogy a kód addig nem folytatódik, ameddig egy megadott sor be nem fejeződik véglegesen.  
Ez a metódus állítja ba a színeket az adatbázisban a LED csíkhoz.
```
  Future updateColor(int _red, int _green, int _blue) async {
    return await databaseReference
        .child("Control/LED control/Colors")
        .update({'Red': _red, 'Green': _green, 'Blue': _blue});
  }
```  
Ezzel elérjük az adatbázist, és a megfelelő értéket beírjuk a _Brightness_ változóhoz.
```
  Future updateBrightness(int br) async {
    return await databaseReference
        .child("Control/LED control")
        .update({'Brightness': br});
  }
```  
Az első függvény lekérdezi a fényerőt, és beírja egy változóba. A második ezt használja fel, hogy megállapítsa, hogy a LED be van-e kapcsolva, vagy nem.
```
  int? br;
  Future getBrightness() async {
    await databaseReference
        .child('Control/LED control/Brightness')
        .once()
        .then((DataSnapshot snapshot) {
      br = snapshot.value;
    });
  }

  Future turnLightOnOff() async {
    await getBrightness();
    if (br! != 0) {
      return await databaseReference
          .child("Control/LED control")
          .update({'Brightness': 0});
    } else if (br! == 0) {
      return await databaseReference
          .child("Control/LED control")
          .update({'Brightness': 100});
    }
  }
```  
Lekérdezzük azt, hogy a biztonsági rendszer be van-e kapcsolva, és ha nem, akkor kikapcsoljuk. Ezt használja a bekapcsoló gomb.
```
  Future checkSecState() async {
    await databaseReference
        .child('Control/Security/On')
        .once()
        .then((DataSnapshot snapshot) {
      secState = snapshot.value;
    });
  }

  Future turnSecOnOff() async {
    await checkSecState();
    await databaseReference
        .child('Control/Security/')
        .update({'On': !secState!});
  }
```  
Ez frissíti a kívánt hőmérsékletet a termosztáthoz az adatbázisban.
```
  Future updateTemp(double temp) async {
    await databaseReference.child('Control/Heating/').update({'Temp': temp});
  }
```
**Meg kell még említeni a fő fájlban, hogy miket kell importálni, beszélni kell a pubspec-ről.**

### /lib/pages
Ebben a mappában találhatóak azoka fájlok, melyekben az alkalmazásban megjelenő oldalak vannak. Az app struktúráját tekintve három fő oldalra tagolható. A **Color Picker**, a **Home**, és a **Heating**. Ezek működése a felhasználói dokumentációban van részletezve, most a leíró kódjukra koncentrálok. 

#### colorPicker2.dart
Tekintsünk el a névhasználattól, nem ő az első verziója az oldalnak. Ez a fájl tartalmazza a color pickert. Ezen az oldalon lehet beállítani a LED csík színét, fényerőt. Ezek mellett pedig ki, és bekapcsolni lehet, valamint manuális vezérlésről átállítani automatikus vezérlésre. Utóbbi esetében a LED adaptálódik a külső fényviszonyokhoz. Lehet választani két mód között. Egyik esetében a bekapcsol, amint a fény egy bizonyos érték alá esik, másik arra való, hogy folyamatosan kövesse a változó fényviszonyokat.


#### homePage.dart
Ebben található az app kezdőoldala, mely megjelenik megnyitás után. Itt a biztonsági rendszer kontrollja található. Itt jelennek meg a biztonsági értesítések, melyek akkor érkeznek, ha a rendszer valamilyen mozgást érzékelt. Természetesen ez is kikapcsolható, hiszen ha otthon vagyunk nem szeretnénk, hogy folyamatosan riasszon. 

#### heating.dart
A termosztátot ez a fájl tartalmazza. Mutatja a jelenlegi hőmérsékletet, és beállítható a kívánt érték is. Amint a hőmérséklet eléri ezt a kívánt értéket, az alkalmazás értesítést küld. A rendzser képes a páratartalmat is mérni, és ezt is megjeleníti a felület.