char incomingByte;

// ref and actual position
float ref_pos = 0, actual_pos = 0;

//state variables
int ch_pos = 0, ch_ref_pos = 0, control_eq = 0;

//PID parameters
int Kp = 0, Td = 0, Ti = 0;

// control variables
float error, de, sum, Volts, olderror, sumolderror, dt = 0.01;

void setup(){
	while (!Serial);
	Serial.begin(9600);           // set up Serial library at 9600 bps
	Serial.println("PID test!");
	
}

void loop(){

	// ----- receiving ref angle ----- //
	if (Serial.available() > 0) {
	    // get incoming byte:
	    incomingByte = Serial.read();
	    switch(incomingByte){
	    	case 'a':
	    		ch_pos = 1;
	    		break;
    		case 'b':
    			ch_ref_pos = 1;
    			break;
    		case 'c':
    			control_eq = 1;
    			break;
			default:
				Serial.println("Fuck!"); break;
    	}
  	}
}

// ---- Reading the actual position ----- //
if(ch_pos == 1)
	ch_pos = 0;
	actual_pos = map(analogRead(),0,1023,0,200);
	Serial.println(actual_pos);
}

// ---- Updating the reference position ---- //
if(ch_ref_pos == 1)
	ch_ref_pos = 0;
	ref_pos = Serial.parseFloat();
	Serial.println(ref_pos);
}

// ------ PID --------//
if(control_eq == 1){
	control_eq = 0;
	error = ref_pos - actual_pos;
	de := (error - olderror) / (dt);      //error - old error  / dt      dt -> 0.01
	sum := (sumolderror + error)*0.01;  // sum = sum of old error + error * dt
	Volts := Kp * error + Ti * sum + Td*de;
	olderror := error;
	sumolderror := sumolderror + olderror;
	Serial.println(Volts, DEC);

}