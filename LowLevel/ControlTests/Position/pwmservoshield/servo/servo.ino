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

// called this way, it uses the default address 0x40
Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

// ------------- PULSE ---------------- //
#define SERVOMIN_HT_Z  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_HT_Z  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_HT_Y  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_HT_Y  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_MT_MG_Z  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_MT_MG_Z  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_MT_MG_Y  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_MT_MG_Y  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_MT_HK_Z  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_MT_HK_Z  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_MT_HK_Y  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_MT_HK_Y  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_LT_HD_Z  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_LT_HD_Z  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_LT_HD_Y  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_LT_HD_Y  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_LT_TSS_Z  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_LT_TSS_Z  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_LT_TSS_Y  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_LT_TSS_Y  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_LT_MAX_Z  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_LT_MAX_Z  600 // this is the 'maximum' pulse length count (out of 4096)

#define SERVOMIN_LT_MAX_Y  150 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX_LT_MAX_Y  600 // this is the 'maximum' pulse length count (out of 4096)

// ------------------------------------------------------------------------------------ //


// ------------- DEGREES ---------------- //
#define DEG_SERVOMIN_HT_Z  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_HT_Z  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_HT_Y  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_HT_Y  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_MT_MG_Z  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_MT_MG_Z  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_MT_MG_Y  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_MT_MG_Y  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_MT_HK_Z  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_MT_HK_Z  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_MT_HK_Y  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_MT_HK_Y  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_LT_HD_Z  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_LT_HD_Z  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_LT_HD_Y  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_LT_HD_Y  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_LT_TSS_Z  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_LT_TSS_Z  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_LT_TSS_Y  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_LT_TSS_Y  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_LT_MAX_Z  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_LT_MAX_Z  600 // this is the degree for the 'maximum' pulse length count 

#define DEG_SERVOMIN_LT_MAX_Y  150 // this is the degree for the 'minimum' pulse length count 
#define DEG_SERVOMAX_LT_MAX_Y  600 // this is the degree for the 'maximum' pulse length count 

// ------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------ //


uint8_t servonum = 0;
uint16_t len = 0;

float float_gripper = 0;

int incomingByte = 0;
int servo_new = 0;
int state = 0;
int potPin = A15;
int gripper = A14;
int s_stop = 0;
int random_iterator = 0;
int ch_gripper=0;
int r_gripper = 45;
int potGripper = 0;
int com_gripper = 0;
int control_servo = 0;
int keep_alive = 0;
int receive_string = 0;

int servomin[11] = {0};
int servomax[11] = {0};
int servomin_deg[11] = {0};
int servomax_deg[11] = {0};
int servo_hz[11] = {0};
int theta_ref[11] = {0};

unsigned long act_time;
unsigned long old_time;

void setup() {
  while (!Serial);
  Serial.begin(9600);
  Serial.println("HR first test!");

  pwm.begin();
  
  pwm.setPWMFreq(50);  // Analog servos run at ~60 Hz updates

  //initialize minimum and maximum values for the shaft motion
  set_min_max_pulses();
  //initialize minimum and maximum degrees values for the shaft motion
  set_min_max_degrees();
  //zero position
  set_zero_position();
  //hz definition
  set_servo_hz();
}



void loop() {
  // Drive each servo one at a time
  if (Serial.available() > 0) {
      // get incoming byte:
      incomingByte = Serial.read();
      switch(incomingByte){
        case 'a': //go to servo min
          pwm.setPWM(servonum, 0, servomin[servonum]);
          Serial.println("Going to minimum.");
          break;
        case 'b': //go to servo max
          pwm.setPWM(servonum, 0, servomax[servonum]);
          Serial.println("Going to maximum.");
          break;
        case 'c': //update servo min
          servomin[servonum] = Serial.parseInt();
          Serial.print("Minimum pulse width updated to ");
          Serial.println(servomin[servonum], DEC);
          break;
        case 'd': //update servo max
          servomax[servonum] = Serial.parseInt();
          Serial.print("Maximum pulse width updated to ");
          Serial.println(servomax[servonum], DEC);
          break;
        case 'f': //update degrees servo min
          servomin_deg[servonum] = Serial.parseInt();
          Serial.print("Minimum degrees updated to ");
          Serial.println(servomin[servonum], DEC);
          break;
        case 'g': //update degrees servo max
          servomax_deg[servonum] = Serial.parseInt();
          Serial.print("Maximum degrees updated to ");
          Serial.println(servomax_deg[servonum], DEC);
          break;
        case 'e': //change servo
          servo_new = Serial.parseInt();
          if((servo_new > 11) || (servo_new < 0)){
            Serial.println("Error choosing the servo");
            break;
          }
          servonum = servo_new;
//          ch_servo = 1;
          Serial.print("The new servo chosen is ");
          Serial.println(servonum, DEC);
          break;
        case 'i': //serial control of one servo
          control_servo = Serial.parseInt();
          pwm.setPWM(servonum,0,control_servo);
          Serial.println(control_servo,DEC);
          break;
        case 'h': //free control of the servo
          old_time = millis();
          state = 1;
          Serial.println("Let the games begin.");
          break;
        case 'r': //rotating all the joints like random
          random_iterator = 1;
          Serial.println("Let the random begin.");
          break;
        case 'x': //stop
          s_stop = 1;
          Serial.println("Let the games end.");
          break;
        case 'm': //opening and closing the gripper
          Serial.println("Just open it.");
          ch_gripper = 1; break;
        case 'n': //stopping manual intervention to the gripper
          Serial.println("No more handjobs.");
          ch_gripper = 0; break;
        case 'o': //receiving command to open or close the gripper
          com_gripper = Serial.parseInt();
          Serial.println("Serial command to open or close the gripper.");
          if(com_gripper == 1) analogWrite(r_gripper, 90);
          else if(com_gripper == 0) analogWrite(r_gripper, 246);
          else Serial.println("Fail, try again.");
          break;
        case 'k': //receiving the percentage to open the gripper
          float_gripper = Serial.parseFloat();
          if((float_gripper > 100)||(float_gripper < 0)){
            Serial.println("Fail, try again.");
            break;
          }
          analogWrite(r_gripper,map(float_gripper,0,90,100,240));
          Serial.println("Serial command to control the percentage of opening the gripper.");
          break;
        case 'q': //change pwm frequency
          pwm.setPWMFreq(Serial.parseInt());
          Serial.println("Changed pwm frequency.");
          break;
        case 's': //set pwm frequency
          pwm.setPWMFreq(servo_hz[servonum]);
          Serial.print("Set the pwm frequency to ");
          Serial.println(servo_hz[servonum]);
          break; 
        case 'z': //reset to initial positions
          keep_alive = 1;
          Serial.println("Reset to confortable positions.");
          break;
        case ':': //receive string with 11 positions
          receive_string = 1;
          Serial.println("string string string.");
          break;
      default:
        Serial.println("Fuck!"); break;
      }
  }

  if(receive_string == 1){
    for(int j = 0; j < 12; j++)
    {
      theta_ref[j] = Serial.parseInt(); //rever
    }
    if(Serial.read() == ';'){
      receive_string = 0;
      Serial.println("Finished.");
      for(int h = 0; h < 12; h++) Serial.println(theta_ref[h], DEC);
    }
    
  for(int n = 0; n < 12; n++)  pwm.setPWM(n,0,theta_ref[n]);
  }
  
  if(keep_alive == 1){
    keep_alive = 0;
    pwm.setPWM(0,0,300);
    pwm.setPWM(1,0,125);
    pwm.setPWM(2,0,294);
    pwm.setPWM(3,0,262);
    pwm.setPWM(4,0,262);
    pwm.setPWM(5,0,262);
    pwm.setPWM(6,0,264);
    pwm.setPWM(7,0,216);
    pwm.setPWM(8,0,216);
    pwm.setPWM(9,0,295);
    pwm.setPWM(10,0,274);
    pwm.setPWM(11,0,444);
  }

  // ---------------- Opening and Closing the Gripper -------------//
  if(ch_gripper){
    //pwm.setPWM(15,0,map(analogRead(gripper),0,1023,0,700));
    potGripper = map(analogRead(gripper),0,1023,0,255);
    analogWrite(r_gripper, potGripper);
    Serial.println(potGripper, DEC);
  }

    // ---------------- Reset to rotating the joints -------------//
  if(s_stop == 1){
    state = 0;
    s_stop = 0;
    random_iterator = 0;
    
  }
  
  // ---------------- Rotating one joint a time -------------//
  if(state == 1){
    //receiving data from the potentiometer and rotating the servo likewise
    act_time = millis();
    len = map(analogRead(potPin),0,1023,0,700);
    if(act_time - old_time > 5000){
      Serial.println(len, DEC);
      old_time = millis();
    }
    pwm.setPWM(servonum, 0, len);
  }

  // ---------------- Rotating all joints "RANDOM" -------------//
  if(random_iterator == 1){
    len = map(analogRead(potPin),0,1023,0,700);
    for(int i=0; i<12; i++){
      pwm.setPWM(i, 0, len);
    }
  }

//  if(ch_servo == 1){
//    ch_servo = 0;
//    if((servonum == 8)||(servonum == 9)){
//      pwm.setPWMFreq(300);
//    }
//    
//    
//  }

}


// ---------------- Initialization Pulses -------------//
void set_min_max_pulses(){
    //Servomin update
  servomin[0] = SERVOMIN_HT_Z;
  servomin[1] = SERVOMIN_HT_Y;
  servomin[2] = SERVOMIN_MT_MG_Z;
  servomin[3] = SERVOMIN_MT_MG_Y;
  servomin[4] = SERVOMIN_MT_HK_Z;
  servomin[5] = SERVOMIN_MT_HK_Y;
  servomin[6] = SERVOMIN_LT_HD_Z;
  servomin[7] = SERVOMIN_LT_HD_Y;
  servomin[8] = SERVOMIN_LT_TSS_Z;
  servomin[9] = SERVOMIN_LT_TSS_Y;
  servomin[10] = SERVOMIN_LT_MAX_Z;
  servomin[11] = SERVOMIN_LT_MAX_Y;

  //Servomax update
  servomax[0] = SERVOMAX_HT_Z;
  servomax[1] = SERVOMAX_HT_Y;
  servomax[2] = SERVOMAX_MT_MG_Z;
  servomax[3] = SERVOMAX_MT_MG_Y;
  servomax[4] = SERVOMAX_MT_HK_Z;
  servomax[5] = SERVOMAX_MT_HK_Y;
  servomax[6] = SERVOMAX_LT_HD_Z;;
  servomax[7] = SERVOMAX_LT_HD_Y;;
  servomax[8] = SERVOMAX_LT_TSS_Z;
  servomax[9] = SERVOMAX_LT_TSS_Y;
  servomax[10] = SERVOMAX_LT_MAX_Z;
  servomax[11] = SERVOMAX_LT_MAX_Y;
}

// ---------------- Initialization degrees -------------//
void set_min_max_degrees(){
    //Servomin update
  servomin_deg[0] = DEG_SERVOMIN_HT_Z;
  servomin_deg[1] = DEG_SERVOMIN_HT_Y;
  servomin_deg[2] = DEG_SERVOMIN_MT_MG_Z;
  servomin_deg[3] = DEG_SERVOMIN_MT_MG_Y;
  servomin_deg[4] = DEG_SERVOMIN_MT_HK_Z;
  servomin_deg[5] = DEG_SERVOMIN_MT_HK_Y;
  servomin_deg[6] = DEG_SERVOMIN_LT_HD_Z;
  servomin_deg[7] = DEG_SERVOMIN_LT_HD_Y;
  servomin_deg[8] = DEG_SERVOMIN_LT_TSS_Z;
  servomin_deg[9] = DEG_SERVOMIN_LT_TSS_Y;
  servomin_deg[10] = DEG_SERVOMIN_LT_MAX_Z;
  servomin_deg[11] = DEG_SERVOMIN_LT_MAX_Y;

  //Servomax update
  servomax_deg[0] = DEG_SERVOMAX_HT_Z;
  servomax_deg[1] = DEG_SERVOMAX_HT_Y;
  servomax_deg[2] = DEG_SERVOMAX_MT_MG_Z;
  servomax_deg[3] = DEG_SERVOMAX_MT_MG_Y;
  servomax_deg[4] = DEG_SERVOMAX_MT_HK_Z;
  servomax_deg[5] = DEG_SERVOMAX_MT_HK_Y;
  servomax_deg[6] = DEG_SERVOMAX_LT_HD_Z;;
  servomax_deg[7] = DEG_SERVOMAX_LT_HD_Y;;
  servomax_deg[8] = DEG_SERVOMAX_LT_TSS_Z;
  servomax_deg[9] = DEG_SERVOMAX_LT_TSS_Y;
  servomax_deg[10] = DEG_SERVOMAX_LT_MAX_Z;
  servomax_deg[11] = DEG_SERVOMAX_LT_MAX_Y;
}

void set_servo_hz(){
  servo_hz[0] = 50;
  servo_hz[1] = 50;
  servo_hz[2] = 330;
  servo_hz[3] = 330;
  servo_hz[4] = 50;
  servo_hz[5] = 50;
  servo_hz[6] = 50;
  servo_hz[7] = 50;
  servo_hz[8] = 330;
  servo_hz[9] = 330;
  servo_hz[10] = 50;
  servo_hz[11] = 50;
}

void set_zero_position(){
//  pwm.setPWM(0, 0, len);
//  pwm.setPWM(1, 0, len);
//  pwm.setPWM(2, 0, len);
//  pwm.setPWM(3, 0, len);
//  pwm.setPWM(4, 0, len);
//  pwm.setPWM(5, 0, len);
  pwm.setPWM(6, 0, 392);
  pwm.setPWM(7, 0, 320);
  pwm.setPWM(8, 0, 309);
  pwm.setPWM(9, 0, 374);
  pwm.setPWM(10, 0, 349);
  pwm.setPWM(11, 0, 328);
  analogWrite(r_gripper, 246);  
}

// you can use this function if you'd like to set the pulse length in seconds
// e.g. setServoPulse(0, 0.001) is a ~1 millisecond pulse width. its not precise!
//void setServoPulse(uint8_t n, double pulse) {
//  double pulselength;
//  
//  pulselength = 1000000;   // 1,000,000 us per second
//  pulselength /= 60;   // 60 Hz
//  Serial.print(pulselength); Serial.println(" us per period"); 
//  pulselength /= 4096;  // 12 bits of resolution
//  Serial.print(pulselength); Serial.println(" us per bit"); 
//  pulse *= 1000;
//  pulse /= pulselength;
//  Serial.println(pulse);
//  pwm.setPWM(n, 0, pulse);
//}

//  Serial.println(servonum);
//  for (uint16_t pulselen = SERVOMIN; pulselen < SERVOMAX; pulselen++) {
//    pwm.setPWM(servonum, 0, pulselen);
//  }
//
//  delay(500);
//  for (uint16_t pulselen = SERVOMAX; pulselen > SERVOMIN; pulselen--) {
//    pwm.setPWM(servonum, 0, pulselen);
//  }
//
//  delay(500);
//
//  servonum ++;
//  if (servonum > 7) servonum = 0;
