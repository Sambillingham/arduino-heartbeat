import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int ledPin = 13; // LED onboard in pin 13
int lightSensor = 7;   // Sensor connected to pin 7
int beats = 0;
int bpm = 0;
PFont font;

boolean beatingNow = false;
int savedTime;
int totalTime = 60000;

void setup() {
  size(300,200);
  background(0);
  
  // println(Arduino.list()); // use to find arduino
  arduino = new Arduino(this, "COM6", 57600); 
  arduino.pinMode(ledPin, Arduino.OUTPUT);      // sets the digital pin 13 as output
  arduino.pinMode(lightSensor, Arduino.INPUT);      // sets the digital pin 7 as input
    
  savedTime = millis();
}

void draw() {  
    int passedTime = millis() - savedTime;
  
    if (beatingNow == false){
      if (arduino.digitalRead(lightSensor) ==  Arduino.HIGH ){
                 beats++;
                 beatingNow = true; 
      }
    }    
      if (arduino.digitalRead(lightSensor) ==  Arduino.LOW ){               
                 beatingNow = false;                 
      }
    
      if (passedTime > totalTime) {
        bpm = (beats );
        println("beats per minute: " + bpm);        
        //println( " 15 seconds have passed! " );
        beats = 0;
        savedTime = millis(); // Save the current time to restart the timer!
      }
      
       text("BPM: " + bpm, 150,110);
}




