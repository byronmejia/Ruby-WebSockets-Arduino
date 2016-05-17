int incomingByte = 0;   // for incoming serial data
int LED0 = D0;
int ACC_Z = A0;

void setup() {
  // Start Serial
  Serial.begin(9600);
  // put your setup code here, to run once:
  pinMode(ACC_Z, INPUT);
  pinMode(LED0, OUTPUT);

}

void loop() {
  int Z = analogRead(ACC_Z) - 630;
  
  if(50 < abs(Z)){
   digitalWrite(LED0, HIGH);
   Serial.println(1);
  } else {
   digitalWrite(LED0, LOW);
   Serial.println(0);
  }

  delay(100);
}
