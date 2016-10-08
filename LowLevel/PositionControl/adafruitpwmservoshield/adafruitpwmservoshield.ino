/***************************************************
  This is an example adapted for Adafruit 16-channel PWM & Servo driver
  Servo test - this will drive 16 servos, one after the other

  Pick one up today in the adafruit shop!
  ------> http://www.adafruit.com/products/815

  These displays use I2C to communicate, 2 pins are required to  
  interface. For Arduino UNOs, thats SCL -> Analog 5, SDA -> Analog 4

  Adafruit invests time and resources providing this open source code, 
  please support Adafruit and open-source hardware by purchasing 
  products from Adafruit!

  Adapted from Limor Fried/Ladyada for Adafruit Industries.  
  BSD license, all text above must be included in any redistribution
 
  Written by Joaquim Ribeiro for his Master thesis.
 ****************************************************/

#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

double servozero[12] = {0};
double servomin_pwm[12] = {0};
double servomax_pwm[12] = {0};
int servomin_deg[12] = {0};
int servomax_deg[12] = {0};
double pwm_ref[12] = {0};
double pwm_act[12] = {0};

int servonum = 0;
int aux_servonum = 0;
double aux_pwm = 0;
float aux_deg = 0.0;
int aux;

double aux_min_pwm = 0;
double aux_max_pwm = 0;
float aux_min_deg = 0.0;
float aux_max_deg = 0.0;

int init_state = 0;

int incomingByte = 0;

int gripperPin = 45;

unsigned long is_old_time;
unsigned long is_actual_time;

void setup(){
  while(!Serial);
  Serial.begin(9600);
  //Serial.println("Hyper-Redundant by Joaquim Ribeiro");

  pwm.begin();

  pwm.setPWMFreq(50);
//  Serial.println("Set min and max pulses.");
  while(set_min_max_pulses() != 1);
//  Serial.println("Set min and max degrees.");
  while(set_min_max_degrees() != 1);
//  Serial.println("Set zeros.");
  while(init_zeros() != 1);
//  Serial.println("Ready set GOOOOO.");
  init_state = 1;
}

void loop(){

  if (init_state != 0){
    if (init_state == 1){
//      Serial.println("All servos are going to move to their zero position.");
      is_old_time = millis();
      init_state = 2;
    }
    else if((init_state == 2) && ((is_actual_time - is_old_time) > 2000)){
//      Serial.println("We are going to open the gripper.");
      init_state = 3;
      is_old_time = millis();
    }
    else if((init_state == 3) && ((is_actual_time - is_old_time) > 2000)){
//      Serial.println("Finished the initialization procedure.");
      init_state = 0;
    }
  }
  else if(init_state == 0){
    if(Serial.available() > 0){
      incomingByte = Serial.read();
      switch(incomingByte){
        case 'c':
          aux_servonum = Serial.parseInt();
          if((aux_servonum < 0) || (aux_servonum > 11)){
//            Serial.println("Error choosing servo.");
            break;
          }
          servonum = aux_servonum;
//          Serial.print("New servo choosen is ");
//          Serial.println(servonum);
          break;
        case ':':
          while(read_string() != 1);

          break;
        case '.':
          while(read_position() != 1);
          break;
        case 'w':
          aux = Serial.parseInt();
          for(int i = 0; i < 12; i++)
            pwm_ref[i] = map(aux, 0, servomax_deg[i], servozero[i], servomax_pwm[i]);
            while(go_to_pos_2() != 1);
//            Serial.println("Done like a boss.");
            break;
        case 'z':
          for(int i = 0; i < 12; i++)
            pwm_ref[i] = map(0, 0, servomax_deg[i], servozero[i], servomax_pwm[i]);
          while(go_to_pos() != 1);
//          Serial.println("Return like a boss.");
          break;
        case 'i':
          pwm.setPWM(servonum,0,Serial.parseInt());
          break;
        case 'r':
//          Serial.println("We are reseting.");
          init_state = 1;
          break;
        case 'q':
          for(int q = 0; q < 12; q++){
            Serial.print(":");
            int zero_aux = servozero[q];
            if(pwm_act[q] > zero_aux){
              int max_aux = servomax_pwm[q];
              int max_aux_deg = servomax_deg[q];
              Serial.print(map(pwm_act[q],zero_aux, max_aux,0,max_aux_deg));
            }
            else if(pwm_act[q] <= zero_aux){
              int min_aux = servomin_pwm[q];
              int min_aux_deg = servomin_deg[q];
              Serial.print(map(pwm_act[q],min_aux,zero_aux,min_aux_deg,0));
            }
            Serial.print(" ");
          }
          Serial.print(";");
          break;        
        default:
//          Serial.println("Error.");
          break;
      }
/*
  // ------------- Instructions list ------------ //
  a -
  b -
  c - change the servomotor
  d -
  e -
  f -
  g -
  h -
  i - serial pwm command to control one servomotor
  j -
  k -
  l - 
  m -
  n -
  o - receiving serial command to open or close the gripper
  p - 
  q -
  r - reset to the initial precedure
  s -
  t -
  u -
  v -
  w -
  x -
  y -
  z - go to zero
  . - receive degree to one servo
  : - receive degree string

*/
    }
  }
  
  if(init_state == 2){
    for(int i = 0; i < 12; i++)
      pwm_ref[i] = servozero[i];
    while(go_to_pos_zero() != 1);
    is_actual_time = millis();
  }

  else if(init_state == 3){
    analogWrite(gripperPin, 246);
    is_actual_time = millis();
  }

}

int set_min_max_pulses(){
  // this is the degree for the 'minimum' pulse length count
  servomin_pwm[0] = 106;  // servo 0
  servomin_pwm[1] = 115;  // servo 1
  servomin_pwm[2] = 500;  // servo 2
  servomin_pwm[3] = 500;  // servo 3
  servomin_pwm[4] = 500;  // servo 4
  servomin_pwm[5] = 480;  // servo 5
  servomin_pwm[6] = 480;  // servo 6
  servomin_pwm[7] = 465;  // servo 7
  servomin_pwm[8] = 500;  // servo 8
  servomin_pwm[9] = 420;  // servo 9
  servomin_pwm[10] = 465; // servo 10
  servomin_pwm[11] = 440; // servo 11
  // this is the degree for the 'maximum' pulse length count
  servomax_pwm[0] = 459;  // servo 0
  servomax_pwm[1] = 460;  // servo 1
  servomax_pwm[2] = 120;  // servo 2
  servomax_pwm[3] = 120;  // servo 3
  servomax_pwm[4] = 120;  // servo 4
  servomax_pwm[5] = 110;  // servo 5
  servomax_pwm[6] = 110;  // servo 6
  servomax_pwm[7] = 105;  // servo 7
  servomax_pwm[8] = 100;  // servo 8
  servomax_pwm[9] = 180;  // servo 9
  servomax_pwm[10] = 115; // servo 10
  servomax_pwm[11] = 90;  // servo 11
  return 1;
}

int set_min_max_degrees(){
  servomin_deg[0] = -90;  // servo 0
  servomin_deg[1] = -60;  // servo 1
  servomin_deg[2] = -90;  // servo 2
  servomin_deg[3] = -90;  // servo 3
  servomin_deg[4] = -90;  // servo 4
  servomin_deg[5] = -90;  // servo 5
  servomin_deg[6] = -90;  // servo 6
  servomin_deg[7] = -90;  // servo 7
  servomin_deg[8] = -45;  // servo 8
  servomin_deg[9] = -45;  // servo 9
  servomin_deg[10] = -90; // servo 10
  servomin_deg[11] = -90; // servo 11

  servomax_deg[0] = 90;   // servo 0
  servomax_deg[1] = 90;   // servo 1
  servomax_deg[2] = 90;   // servo 2
  servomax_deg[3] = 90;   // servo 3
  servomax_deg[4] = 90;   // servo 4
  servomax_deg[5] = 90;   // servo 5
  servomax_deg[6] = 90;   // servo 6
  servomax_deg[7] = 90;   // servo 7
  servomax_deg[8] = 45;   // servo 8
  servomax_deg[9] = 45;   // servo 9
  servomax_deg[10] = 90;  // servo 10
  servomax_deg[11] = 90;  // servo 11
  return 1;
}

int init_zeros(){
  servozero[0] = 270; // servo 0
  servozero[1] = 250; // servo 1
  servozero[2] = 320; // servo 2
  servozero[3] = 320; // servo 3
  servozero[4] = 310; // servo 4
  servozero[5] = 280; // servo 5
  servozero[6] = 280; // servo 6
  servozero[7] = 270; // servo 7
  servozero[8] = 300; // servo 8
  servozero[9] = 320; // servo 9
  servozero[10] = 285; // servo 10
  servozero[11] = 255; // servo 11
  return 1;
}

int read_string(){
  for(int i = 0; i < 12; i++){
    aux_deg = Serial.parseFloat();
    if((aux_deg < servomin_deg[i]) || (aux_deg > servomax_deg[i])){
//      Serial.println("Degree exceeds the maximum or the minimum value.");
      return 1;
    }
    if(aux_deg <= 0){
      aux_min_deg = servomin_deg[i];
      aux_max_deg = 0;
      aux_min_pwm = servomin_pwm[i];
      aux_max_pwm = servozero[i];  
    }
    else if(aux_deg > 0){
      aux_min_deg = 0;
      aux_max_deg = servomax_deg[i];
      aux_min_pwm = servozero[i];
      aux_max_pwm = servomax_pwm[i];
      
    }
    aux_pwm = (double)map(aux_deg, aux_min_deg, aux_max_deg, aux_min_pwm, aux_max_pwm);
    pwm_ref[i] = aux_pwm;
//    Serial.println(pwm_ref[i]);
  }
  if(Serial.read() == ';'){
//    Serial.println("Finito");
    while(go_to_pos_2() != 1);
    return 1;
  }
  
  return 0;
}

int read_position(){
  aux_deg = Serial.parseFloat();
  if(aux_deg <= 0){
    pwm_ref[servonum] = (double)map(aux_deg, servomin_deg[servonum], 0, servomin_pwm[servonum], servozero[servonum]);
  }
  else if(aux_deg > 0){
    pwm_ref[servonum] = (double)map(aux_deg, 0, servomax_deg[servonum], servozero[servonum], servomax_pwm[servonum]);
  }
  //pwm_ref[servonum] = (double)map(Serial.parseFloat(), servomin_deg[servonum], servomax_deg[servonum], servomin_pwm[servonum], servomax_pwm[servonum]);
  incomingByte = Serial.read();
  if(incomingByte == ';'){
    while(go_to_pos() != 1);
//    Serial.print(servonum);
//    Serial.print(" - ");
//    Serial.print(pwm_ref[servonum],DEC);
//    Serial.print(" - ");
//    Serial.println(aux_deg);
    return 1;
  }
  return 0;
}

int go_to_pos_zero(){
  for(int i = 0; i < 12; i++){
    pwm.setPWM(i,0,pwm_ref[i]);
    pwm_act[i] = pwm_ref[i];
  }
  return 1;
}

int go_to_pos(){
  for(int i = 0; i < 12; i++){
    while(pwm_act[i] > pwm_ref[i]){
      pwm_act[i] --;
      pwm.setPWM(i,0,pwm_act[i]);
      delay(10);
    }
    while(pwm_act[i] < pwm_ref[i]){
      pwm_act[i] ++;
      pwm.setPWM(i,0,pwm_act[i]);
      delay(10);
    }
  }
  return 1;
}

int go_to_pos_1(){
  for(int i = 0; i < 12; i++){
    while(pwm_act[11-i] > pwm_ref[11-i]){
      pwm_act[11-i] --;
      pwm.setPWM(11-i,0,pwm_act[11-i]);
      delay(10);
    }
    while(pwm_act[11-i] < pwm_ref[11-i]){
      pwm_act[11-i] ++;
      pwm.setPWM(11-i,0,pwm_act[11-i]);
      delay(10);
    }
  }
  return 1;
}

int go_to_pos_2(){
  int error = 0;
  while(1){
    for(int i = 0; i < 12; i++){
      if(pwm_act[11-i] > pwm_ref[11-i]){
        pwm_act[11-i] --;
        pwm.setPWM(11-i,0,pwm_act[11-i]);
      }
      else if(pwm_act[11-i] < pwm_ref[11-i]){
        pwm_act[11-i] ++;
        pwm.setPWM(11-i,0,pwm_act[11-i]);
      }
      else error ++;
      delay(2);
    }
    if(error == 12)
      return 1;
    else error = 0;
    
  }
  return 0;
}




