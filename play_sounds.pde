import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import processing.serial.*;

Serial myPort;
String val;
String[] lines;
Integer i;

Minim minim;
AudioOutput out;
SawWave square;
LowPassSP lowpass;
 
void setup() {
  size(200, 200);
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);

  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 512);
    
  lowpass = new LowPassSP(200, 44100);
  out.addEffect(lowpass);  
  frameRate(30);
  i = 0;
}
 
void draw() {
  
  if (myPort.available() > 0) {
    val = myPort.readString().trim();
    String[] list = split(val, '\n');
    float distance = float(list[0]);
    if (distance < 2000 && distance > 300) {
      square = new SawWave(distance, 5000, 44100);
      out.clearSignals();
      out.addSignal(square);
    }
    i++;
  }
  
}
