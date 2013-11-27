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
 
float cMajorKey[] = {
  261.626 / 2, // C
  293.665 / 2, // D
  329.628 / 2, // E
  349.228 / 2, // F
  391.995 / 2, // G
  440.000 / 2, // A
  493.883 / 2,  // B,
  261.626, // C
  293.665, // D
  329.628, // E
  349.228, // F
  391.995, // G
  440.000, // A
  493.883,  // B,
  261.626 * 2, // C
  293.665 * 2, // D
  329.628 * 2, // E
  349.228 * 2, // F
  391.995 * 2, // G
  440.000 * 2, // A
  493.883 * 2,  // B
  261.626 * 3, // C
  293.665 * 3, // D
  329.628 * 3, // E
  349.228 * 3, // F
  391.995 * 3, // G
  440.000 * 3, // A
  493.883 * 4,  // B
  261.626 * 4, // C
  293.665 * 4, // D
  329.628 * 4, // E
  349.228 * 4, // F
  391.995 * 4, // G
  440.000 * 4, // A
  493.883 * 4  // B
};

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
//    println("Frequency: " + distance);   
    
    if (distance < 3000 && distance > 0) {
      float note = 0;
      
      for (int i = 0; i < cMajorKey.length; i++) {
        if (i + 1 >= cMajorKey.length) break;
        if (distance < cMajorKey[i] && distance < cMajorKey[i + 1]) {
          note = cMajorKey[i];
          println("Note: " + note);
          break;
        }
      }
      
      SineWave sine = new SineWave(note, 1, 44100);
      sine.setPan(-0.50);
      
      SineWave sineOctave = new SineWave(note / 2, 0.95, 44100);
      sineOctave.setPan(0.50);
      
      SquareWave square = new SquareWave(note * 2, 0.15, 44100);
      
      out.clearSignals();
      out.addSignal(sine);
      out.addSignal(sineOctave);
      out.addSignal(square);
    } else if (distance > 3000 || distance < 0) {
      out.clearSignals();
    }
  }
}
