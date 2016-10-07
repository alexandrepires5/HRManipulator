
#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"

//init shields
Adafruit_MotorShield shieldTop(0x62); // 00010
Adafruit_MotorShield shieldMed(0x61); // 00001
Adafruit_MotorShield shieldBot(0x60); // 00000

//motor init
Adafruit_DCMotor *M1_top = shieldTop.getMotor(3);

int state = 0;
bool ch_speed_st = 0;
bool pot_reading = 0;

int incomingByte;     // variable to store the value coming from the serial monitor
int potPin = A15;    // select the input pin for the potentiometer
int posPin = 0;    // input pin for the position of the servomotor
int val = 0;       // variable to store the value coming from the sensor
int speed_s = 250;    // variable to store the value coming from the potentiometer
unsigned long result_time; //variable to store the time wich the motor needs to rotate
unsigned long act_time; // variable to store the actual time after rotating
unsigned long old_time; // variable to store the time before rotating



void setup() {
  while (!Serial);
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Doing for the HR family!");

  shieldTop.begin(); //initialize the shield
  M1_top->setSpeed(speed_s); // base value for the speed of the dc motor
    
  M1_top->run(RELEASE); //stop the dc motor
}

void loop() {
 
    if (Serial.available() > 0) {
    // get incoming byte:
      incomingByte = Serial.read();

    switch(incomingByte){
      case 'a': // initiate test scheme
        state = 1; old_time = millis(); Serial.println("Starting");
        break;
      case 'x': // emergency stop
        M1_top->run(RELEASE); Serial.println("Emergency Stop"); state = 0;
        break;
      case 'b': // move backward
        M1_top->run(BACKWARD); Serial.println("Moving Backward");
        break;
      case 'f': // move forward
        M1_top->run(FORWARD); Serial.println("Moving Forward");
        break;
      case 'r': // potentiometer reading
        pot_reading = !pot_reading;
        break;
      case 's': // change speed;
        ch_speed_st = !ch_speed_st;M1_top->run(RELEASE);
        break;
      case ':': // read string with value to rotate
        while(read_position) != 1);
        break;
      default: 
      Serial.println("Fuck!"); break;
    }}

//--------- Anal Reading ------------//
speed_s = map(analogRead(potPin), 0, 1023, 0, 250);    // read the value from the sensor
val = analogRead(posPin);
                  

//---------- States --------//
  if(1 == state){
    M1_top->run(FORWARD);
    
  }
  else if (2 == state){
    M1_top->run(RELEASE);

  }
  else if (3 == state){
    M1_top->run(BACKWARD);
  }
  else if (4 == state){
    result_time = act_time - old_time;
    Serial.println(result_time,DEC);
    M1_top->run(RELEASE);
    state = 0;
  }

  //------ Speed Change ------//
  if (1 == ch_speed_st){
    Serial.println(speed_s,DEC);
    M1_top->setSpeed(speed_s);
  }
  //------ Potentiometer Reading ------//
  if (1 == pot_reading){
    Serial.println(map(val,0,1024,-20,200),DEC);
    //Serial.println(val,DEC);
  }

//-------- Conditions for States ------------//
  if((1 == state) && (1021 < val)) {
    state = 2;
    act_time = millis();
    Serial.println("Stopped");
  }
    
  if((2 == state) && (2000 < (millis() - act_time))){
    //delay(2000);
    state = 3;
    Serial.println("Reseting");
  }

  if((3 == state) && (3 > val)) 
    state = 4;


}

int read_position(){
  pos_ref = Serial.parseFloat();
  pos_actual = analogRead(
}

int go_to_pos(){

  pos_act = analogRead(potPin);
  pos_error = pos_ref - pos_act;

  if(pos_error > dist_b_error){
    M1_top->setSpeed(speed_f);
    M1_top->run(FORWARD); 
  }
  else if(pos_error < -dist_b_error){
    M1_top->setSpeed(speed_f);
    M1_top->run(BACKWARD)
  }
  else if((pos_error > dist_s_error) || (pos_error < -dist_s_error){
    M1_top->setSpeed(speed_l);
  }
  else if((pos_error < dist_error) || (pos_error > -dist_error){
    M1_top->run(RELEASE);
    return 1;
  }  
}


