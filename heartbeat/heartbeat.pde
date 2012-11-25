import pitaru.sonia_v2_9.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
Sample sample;

import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress myLocation;

// SAM
int lightSensor = 7;   // Sensor connected to pin 7
int BPM;
int saveTime;
float elapsedTime;
boolean beatingNow = false;
int [] beats = new int[5];
int last5Average;

int heartRate;
int sampleRate;
// SAM

void setup() {

  Sonia.start(this);

  sample = new Sample("aif_16.aif");

  int sampleRate = sample.getRate();

  size(100, 100);

  frameRate(25);

  // Set up Arduino
  arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);   //  Input correct serial port
  arduino.pinMode(lightSensor, Arduino.INPUT);      // sets the digital pin 7 as input

  // local port
  osc = new OscP5(this, 12000);

  // remote port
  myLocation = new NetAddress("127.0.0.1", 12000);

  println("The sample rate is: " + sampleRate);

  sample.repeat();

}

void draw() {

  background(32,32,32);

  setSampleRate();

  //getTestData();

}


void setSampleRate() {

  // int r = int(random(60, 90));

  // float rate = (height - mouseY) * 88200 / (height);

  // float rate = r * 735;

  // sample.setRate(rate);

  if (beatingNow == false){

       if (arduino.digitalRead(lightSensor) ==  Arduino.HIGH ){ // if LED is on

           // println("Start: " + savedTime + "  Stop: " + millis());
            elapsedTime = millis() - saveTime;
            elapsedTime = round((60/(elapsedTime/1000)));

            BPM = int(elapsedTime);

            for (int i = 0; i < beats.length; i++){

              if ( i < (beats.length)-1){
                beats [i] = beats[i+1];
              }

              //println(beats[i]);
              last5Average = last5Average + beats[i];

              if( i == beats.length -1 ){
                beats[i] = BPM;
              }

              println(beats[i]);

            }

            heartRate = last5Average / 5;

            println("BPM: " + heartRate);

            last5Average = 0;
            saveTime = millis();
            beatingNow = true;
       }

    }

    if (beatingNow == true) {

      if (arduino.digitalRead(lightSensor) ==  Arduino.LOW ){ // if LED is off

          beatingNow = false;

      }

    }

    sampleRate = heartRate * 735;

    println("Sample rate" + sampleRate);

    sample.setRate(sampleRate);

}

void getTestData() {

  OscMessage myMessage = new OscMessage("/bio/heart");

  int rate = int(random(60, 90));

  // Message to pass
  myMessage.add(rate);

  osc.send(myMessage, myLocation);

}

void oscEvent(OscMessage receivedMessage) {

  // Print OSC Message
  println("address: " + receivedMessage.addrPattern());
  println(receivedMessage.get(0).intValue());

}

public void stop() {

  Sonia.stop();
  sample.stop(1);
  super.stop();

}
