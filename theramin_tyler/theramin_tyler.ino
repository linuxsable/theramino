const int pingPin = 13; 
const int inPin = 12;

void setup() {
  Serial.begin(9600);
}

void loop() {
  //raw duration in milliseconds, cm is the 
  //converted amount into a distance
  long duration, cm, ft;

  //initializing the pin states
  pinMode(pingPin, OUTPUT);
  
  //sending the signal, starting with LOW for a clean signal
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  //setting up the input pin, and receiving the duration in 
  //microseconds for the sound to bounce off the object infront
  pinMode(inPin, INPUT);
  duration = pulseIn(inPin, HIGH);

  cm = microsecondsToCentimeters(duration);
  ft = centimetersToFeet(cm);
  
  delay(200);
  
  Serial.println(duration);
}

long microsecondsToCentimeters(long microseconds) {
  return microseconds / 29 / 2;
}

long centimetersToFeet(long centimeters) {
  return centimeters / 30.48;
}
