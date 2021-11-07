int pirPin = 5;// pirPin változó 7-es láb, PIR sensor
void setup()
{
pinMode(pirPin, INPUT);//a 7-es láb bemenet
Serial.begin(9600);//soros monitor bitsebessége
}
void loop()
{
if (digitalRead(pirPin) == HIGH)//ha pirPin állapota magas szinten van akkor
{
Serial.println("MOZGÁS");//kiíratja a soros monitora a mozgás szót
}
else//különben
{
Serial.println("Csend");//kiíratja ezt
}
delay(500);
}
