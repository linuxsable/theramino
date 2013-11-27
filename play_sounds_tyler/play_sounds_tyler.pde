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

AudioOutput out;
 
void setup() {
  size(200, 200);
  
  String portName = Serial.list()[2];
  println("Connecting on serial: " + portName);
  
  myPort = new Serial(this, portName, 9600);

  Minim minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 512);
    
  LowPassSP lowpass = new LowPassSP(200, 44100);
  out.addEffect(lowpass);  
  frameRate(30);
}
 
void draw() {
  if (myPort.available() > 0) {
    val = myPort.readString().trim();
    String[] list = split(val, '\n');
    float distance = float(list[0]);
    
    // Take out some distance to allow lower notes
    distance -= 500;
    println("Frequency: " + distance);
    
    if (distance < 3000 && distance > 0) {
      SineWave sine = new SineWave(distance, 0.90, 44100);
      sine.setPan(-0.50);
      
      SineWave sineOctave = new SineWave(distance / 2, 0.85, 44100);
      sineOctave.setPan(0.50);
      
      SquareWave square = new SquareWave(distance, 0.10, 44100);
      
      out.clearSignals();
      out.addSignal(sine);
      out.addSignal(sineOctave);
      out.addSignal(square);
    } else if (distance > 3000 || distance < 0) {
      out.clearSignals();
    }
  }
}
