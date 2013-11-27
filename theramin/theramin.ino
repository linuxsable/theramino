int ledPin = 13;
const int pingPin = 7;

void setup()
{
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  long duration, pitch;
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
//  delayMicroseconds(1);
  digitalWrite(pingPin, HIGH);
//  delayMicroseconds(1);
  digitalWrite(pingPin, LOW);
  
  pinMode(pingPin, INPUT);
 
  duration = pulseIn(pingPin, HIGH);
  Serial.println(duration);
}
