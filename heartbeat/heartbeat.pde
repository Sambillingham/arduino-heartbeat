import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int lightSensor = 7;   // Sensor connected to pin 7
int BPM;
int saveTime;
float elapsedTime;
boolean beatingNow = false;
int [] beats = new int[5];
int last5Average;

void setup() {
  // println(Arduino.list()); // use to find arduino
  size(200,200);

  arduino = new Arduino(this, "COM6", 57600);   //  Input correct serial port
  arduino.pinMode(lightSensor, Arduino.INPUT);      // sets the digital pin 7 as input
}

void draw() {
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
              if( i == beats.length){
                beats[i] = BPM;
              }
            }
            println("BPM: "+(last5Average/5));
            last5Average = 0;
            saveTime = millis();
            beatingNow = true;
       }
    }
    if(beatingNow == true){
      if (arduino.digitalRead(lightSensor) ==  Arduino.LOW ){ // if LED is off
          beatingNow = false;
      }
    }   
}


