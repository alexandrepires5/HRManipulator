/*
Adafruit MotorShield
I2C address test - testing 4 shields
*/

#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"

//init shields
Adafruit_MotorShield shieldTop(0x63); // 00011
Adafruit_MotorShield shieldMedT(0x62); // 00010
Adafruit_MotorShield shieldMedB(0x61); // 00001
Adafruit_MotorShield shieldBot(0x60); // 00000

//motor init
Adafruit_DCMotor *M1_top = shieldTop.getMotor(1);
Adafruit_DCMotor *M2_top = shieldTop.getMotor(2);
Adafruit_DCMotor *M3_top = shieldTop.getMotor(3);
Adafruit_DCMotor *M4_top = shieldTop.getMotor(4);

Adafruit_DCMotor *M1_medt = shieldMedT.getMotor(1);
Adafruit_DCMotor *M2_medt = shieldMedT.getMotor(2);
Adafruit_DCMotor *M3_medt = shieldMedT.getMotor(3);
Adafruit_DCMotor *M4_medt = shieldMedT.getMotor(4);

Adafruit_DCMotor *M1_medb = shieldMedB.getMotor(1);
Adafruit_DCMotor *M2_medb = shieldMedB.getMotor(2);
Adafruit_DCMotor *M3_medb = shieldMedB.getMotor(3);
Adafruit_DCMotor *M4_medb = shieldMedB.getMotor(4);

Adafruit_DCMotor *M1_bot = shieldBot.getMotor(1);
Adafruit_DCMotor *M2_bot = shieldBot.getMotor(2);
Adafruit_DCMotor *M3_bot = shieldBot.getMotor(3);
Adafruit_DCMotor *M4_bot = shieldBot.getMotor(4);

char incomingByte;

void setup() {
  while (!Serial);
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("MMMMotor party!");

  //Then, both shields must have begin called, before you use the motors connected
  shieldTop.begin();
  shieldMedT.begin();
  shieldMedB.begin();
  shieldBot.begin(); // Start the bottom shield
  
  M1_top->setSpeed(250);
  M2_top->setSpeed(250);
  M3_top->setSpeed(250);
  M4_top->setSpeed(250);

  M1_medt->setSpeed(250);
  M2_medt->setSpeed(250);
  M3_medt->setSpeed(250);
  M4_medt->setSpeed(250);
  
  M1_medb->setSpeed(250);
  M2_medb->setSpeed(250);
  M3_medb->setSpeed(250);
  M4_medb->setSpeed(250);
  
  M1_bot->setSpeed(250);
  M2_bot->setSpeed(250);
  M3_bot->setSpeed(250);
  M4_bot->setSpeed(250);
  

  M1_top->run(RELEASE);
  M2_top->run(RELEASE);
  M3_top->run(RELEASE);
  M4_top->run(RELEASE);

  M1_medt->run(RELEASE);
  M2_medt->run(RELEASE);
  M3_medt->run(RELEASE);
  M4_medt->run(RELEASE);
  
  M1_medb->run(RELEASE);
  M2_medb->run(RELEASE);
  M3_medb->run(RELEASE);
  M4_medb->run(RELEASE);
  
  M1_bot->run(RELEASE);
  M2_bot->run(RELEASE);
  M3_bot->run(RELEASE);
  M4_bot->run(RELEASE);
}

void loop() {


  // receiving ref position
  if (Serial.available() > 0) {
    // get incoming byte:
    incomingByte = Serial.read();
    switch(incomingByte){
    	case 'a':
    		M1_top->run(FORWARD);
  			M2_top->run(BACKWARD);
  			M3_top->run(FORWARD);
  			M4_top->run(BACKWARD);
    		break;
    	case 'b':
    		M1_medt->run(FORWARD);
			M2_medt->run(BACKWARD);
			M3_medt->run(FORWARD);
  			M4_medt->run(BACKWARD);
    		break;
    	case 'c':
    	  	M1_medb->run(FORWARD);
  			M2_medb->run(BACKWARD);
  			M3_medb->run(FORWARD);
  			M4_medb->run(BACKWARD);
    		break;
    	case 'd':
    	  	M1_bot->run(FORWARD);
  			M2_bot->run(BACKWARD);
  			M3_bot->run(FORWARD);
  			M4_bot->run(BACKWARD);    	
    		break;
    	case 's':
    	  	M1_top->run(RELEASE);
			M2_top->run(RELEASE);
			M3_top->run(RELEASE);
			M4_top->run(RELEASE);
			M1_medt->run(RELEASE);
			M2_medt->run(RELEASE);
			M3_medt->run(RELEASE);
			M4_medt->run(RELEASE);
			M1_medb->run(RELEASE);
			M2_medb->run(RELEASE);
			M3_medb->run(RELEASE);
			M4_medb->run(RELEASE);
			M1_bot->run(RELEASE);
			M2_bot->run(RELEASE);
			M3_bot->run(RELEASE);
			M4_bot->run(RELEASE);
    		break;
		default: 
			Serial.println("Fuck!"); break;
    }
  }
}