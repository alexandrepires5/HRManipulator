/*
Adafruit MotorShield
I2C address test
*/

#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"

//init shields
Adafruit_MotorShield shield(0x63); // 00011

//motor init
Adafruit_DCMotor *M1 = shield.getMotor(1);

char incomingByte;

void setup() {
    while (!Serial);
    Serial.begin(9600);           // set up Serial library at 9600 bps
    Serial.println("MMMMotor party!");

  	//Then, both shields must have begin called, before you use the motors connected
	shield.begin(); // Start the bottom shield
}

void loop() {
	M1->setSpeed(250);
	// receiving ref position
 	if (Serial.available() > 0) {
	    // get incoming byte:
	    incomingByte = seria.read();
	    if (incomingByte == 'A')
	    {
    		M1->run(FORWARD);
	    }
	    else if (incomingByte == 'B'){
			M1->run(BACKWARD);
	    }
	    else{
    		M1->run(RELEASE);
	    }
	}
}