import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int ledPin = 13; // LED onboard in pin 13
int lightSensor = 7;   // Sensor connected to pin 7
int BPM;
int savedTime;
float passedTime;
boolean beatingNow = false;

void setup() {
  // println(Arduino.list()); // use to find arduino
  size(300,200);

  arduino = new Arduino(this, "COM6", 57600);   //  Input correct serial port
  arduino.pinMode(ledPin, Arduino.OUTPUT);      // sets the digital pin 13 as output
  arduino.pinMode(lightSensor, Arduino.INPUT);      // sets the digital pin 7 as input
}

void draw() {
     if (beatingNow == false){
       if (arduino.digitalRead(lightSensor) ==  Arduino.HIGH ){ // if LED is on
         
            println("Saved Time: " + savedTime);
            println("Current Time: " + millis());
            passedTime = millis() - savedTime;            
            passedTime = round((60/(passedTime/1000)));
            BPM = int(passedTime);
            println(BPM);
           
            savedTime = millis();
            beatingNow = true;
       }
    }
    if(beatingNow == true){
      if (arduino.digitalRead(lightSensor) ==  Arduino.LOW ){ // if LED is off
          beatingNow = false;
      }
    }   
}


