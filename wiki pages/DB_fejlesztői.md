# Adatbázis fejlesztői dokumentáció
## Technológia ismertetése, általános leírás
A projekt adatbázisaként a Google szolgáltatását a Firebase-t használjuk. Ez egy felhő alapú megoldás, mely korlátozásokkal ingyenesen igénybe vehető. A dokumentum tartalmazni fogja az adatbázis összekapcsolását az alkalmazással, valamint a struktúrát, és az igénybe vett szolgáltatások leírását.
## Realtime Database
Az adatok tárolása az un. **Realtime Database** tároló eljárásban valósul meg. Ez egy noSQL megoldás, amely remekül átlátható, nagyon felhasználóbarát köntöst kapott. A megvalósítás lényege, hogy az adatokat egy fa struktúrába rendezzük, ezen belül kategorizáljuk őket. A fa levelei pedig lényegében az elérendő adatokat tároló változók. Minden adatot egy elérési út határoz meg, amellyel elérhető.