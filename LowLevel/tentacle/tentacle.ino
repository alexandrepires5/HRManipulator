

#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"

//init shields
Adafruit_MotorShield shieldTop(0x62); // 00010
Adafruit_MotorShield shieldMed(0x61); // 00001
Adafruit_MotorShield shieldBot(0x60); // 00000

//motor init
Adafruit_DCMotor *M1_top = shieldTop.getMotor(1);
Adafruit_DCMotor *M2_top = shieldTop.getMotor(2);
Adafruit_DCMotor *M3_top = shieldTop.getMotor(3);
Adafruit_DCMotor *M4_top = shieldTop.getMotor(4);

Adafruit_DCMotor *M1_med = shieldMed.getMotor(1);
Adafruit_DCMotor *M2_med = shieldMed.getMotor(2);
Adafruit_DCMotor *M3_med = shieldMed.getMotor(3);
Adafruit_DCMotor *M4_med = shieldMed.getMotor(4);

Adafruit_DCMotor *M1_bot = shieldBot.getMotor(1);
Adafruit_DCMotor *M2_bot = shieldBot.getMotor(2);
Adafruit_DCMotor *M3_bot = shieldBot.getMotor(3);
Adafruit_DCMotor *M4_bot = shieldBot.getMotor(4);

int theta_act[12]={0};    // variable to read the value from the analog pin
int theta_ref[12]={0};
int theta_err[12]={0};
int de[12] = {0};
int sum[12] = {0};
int theta_olderr[12] = {0};
int sum_olderr[12] = {0};
int axis_motion[12] = {0};
int dt, KpJ2, TiJ2, TdJ2;
char incomingByte;

uint8_t move[12] = "FORWARD";

void setup(){
	while (!Serial);
	Serial.begin(9600);           // set up Serial library at 9600 bps
	Serial.println("MMMMotor party!");

	initialize_shields();

	initialize_motors();
}

void loop(){

	// ----- receiving ref angle ----- //
	if (Serial.available() > 0) {
	    // get incoming byte:
	    incomingByte = Serial.read();
	    if (incomingByte == ':') // incomingByte == initialChar
	    {
	    	for(int j = 0; j < 12; j++)
	    	{
	    		theta_ref[j] = Serial.parseInt(); //rever
	    	}
	    }
     //incomingByte de confirmação
	}

	// ----- reading actual angle ----- //
	for(int i = 0; i<12; i++){
    	theta_act[i] = map(analogRead(i), 0, 1023, 0, 180);	

    	// ----- Updating error ----- //
    	theta_err[i] = theta_ref[i] - theta_act[i]; //error update

    	// ----- Updating ID errors ----- //
		de[i] = (theta_err[i]-theta_olderr[i])/dt; // de - derivative ; dt - time constant 
		sum[i] = (sum_olderr[i] + theta_err[i])*dt; // sum - integral; dt - tieme constant
		

		// ----- Update Speed Motion ----- //
		axis_motion[i] = KpJ2 * theta_err[i] + TiJ2 * sum[i] + TdJ2 * de[i];
		if (axis_motion[i] > 0){
			move[i] = FORWARD;
		}
		else if (axis_motion[i] < 0){
			axis_motion[i] = - axis_motion[i];
			move[i] = BACKWARD;
		}
		else{
			move[i] = RELEASE;
		}
		theta_olderr[i] = theta_err[i];
		sum_olderr[i] += theta_err[i];
	}
	// ----- Generate Motion ----- //
	set_speed();
}


void set_speed(){

	M1_top->setSpeed(axis_motion[0]);
	M2_top->setSpeed(axis_motion[1]);
	M3_top->setSpeed(axis_motion[2]);
	M4_top->setSpeed(axis_motion[3]);

	M1_med->setSpeed(axis_motion[4]);
	M2_med->setSpeed(axis_motion[5]);
	M3_med->setSpeed(axis_motion[6]);
	M4_med->setSpeed(axis_motion[7]);

	M1_bot->setSpeed(axis_motion[8]);
	M2_bot->setSpeed(axis_motion[9]);
	M3_bot->setSpeed(axis_motion[10]);
	M4_bot->setSpeed(axis_motion[11]);

	M1_top->run(move[0]);
	M2_top->run(move[1]);
	M3_top->run(move[2]);
	M4_top->run(move[3]);

	M1_med->run(move[4]);
	M2_med->run(move[5]);
	M3_med->run(move[6]);
	M4_med->run(move[7]);

	M1_bot->run(move[8]);
	M2_bot->run(move[9]);
	M3_bot->run(move[10]);
	M4_bot->run(move[11]);

}



// ------- Initializations!!! ------- //

void initialize_shields(){

	shieldTop.begin();
	shieldMed.begin();
	shieldBot.begin();

}

void initialize_motors(){

	M1_top->setSpeed(250);
	M2_top->setSpeed(250);
	M3_top->setSpeed(250);
	M4_top->setSpeed(250);

	M1_med->setSpeed(250);
	M2_med->setSpeed(250);
	M3_med->setSpeed(250);
	M4_med->setSpeed(250);

	M1_bot->setSpeed(250);
	M2_bot->setSpeed(250);
	M3_bot->setSpeed(250);
	M4_bot->setSpeed(250);

	M1_top->run(RELEASE);
	M2_top->run(RELEASE);
	M3_top->run(RELEASE);
	M4_top->run(RELEASE);

	M1_med->run(RELEASE);
	M2_med->run(RELEASE);
	M3_med->run(RELEASE);
	M4_med->run(RELEASE);

	M1_bot->run(RELEASE);
	M2_bot->run(RELEASE);
	M3_bot->run(RELEASE);
	M4_bot->run(RELEASE);

}
