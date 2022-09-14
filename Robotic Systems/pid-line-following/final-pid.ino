#include "encoders.h"
#include "lineSensors.h"
#include "kinematics.h"
#include "pid.h"



#define LINE_LEFT_PIN A4 //Pin for the left line sensor
#define LINE_CENTRE_PIN A3 //Pin for the centre line sensor
#define LINE_RIGHT_PIN A2 //Pin for the right line sensor



LineSensor line_left(LINE_LEFT_PIN); //Create a line sensor object for the left sensor
LineSensor line_centre(LINE_CENTRE_PIN); //Create a line sensor object for the centre sensor
LineSensor line_right(LINE_RIGHT_PIN); //Create a line sensor object for the right sensor

float Kp = 0.6; //Proportional gain for position controller
float Ki = 0.016; //Integral gain for position controller
PID left_PID(Kp, Ki); //Position controller for left wheel position
PID right_PID(Kp, Ki); //Position controller for right wheel position

Kinematics kine;

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////Initilize parameters and variables/////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
int state = 0;

unsigned bt; //back_time, it is used to let Romi continue to move for a little period of time after it is off the line
boolean flag_back = 0; //it is used to determine the time after Romi off the line

float y_pos; //it is used to determine the rotation direction in face_y()
boolean backhome_dir; //it is used to determine the rotation direction in face_x()

//this is for velocity
long VL_e0; //used to record the last left wheel encoder value
long VR_e1; ////used to record the last right wheel encoder value
unsigned long tt; //used to record the time of last velocity measurment
float velocityL;
float velocityR;

//PID parameters
float outputL;
float outputR;
int powerL;
int powerR;
float demandL;
float demandR;

// line sensors related value
int l_value; // left sensor
int c_value; // centre sensor
int r_value; // right sensor
int sum;
float l_prob;
float c_prob;
float r_prob;
float M;

// control the beeping time after reaching the end
unsigned long time_beep;

//rejoin value
float theta_rejoin;
float theta_dev;
int rejoin_state = 0;

float face_x_theta;
float straight_x_theta;
float straight_y_ypos;


///////////////////////////////////////////////////////////////////
///////////////////////Setup///////////////////////////////////////
///////////////////////////////////////////////////////////////////
void setupMotorPins() {
  motorsetup();
}

void setup() {
  setupEncoder0();
  setupEncoder1();

  Serial.begin( 9600 );
  delay(1000);
  Serial.println("***RESET***");
  line_left.calibrate();
  line_centre.calibrate();
  line_right.calibrate();

  //this is for velocity measurement initialize
  VL_e0 = 0;
  VR_e1 = 0;
  tt = micros();
}


///////////////////////////////////////////////////////////////////////////
///////////////////////////Main Loop///////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void loop() {
  velocity_measure(20000); // measure the velocity every 20000 micro-seconds

  kine.update(count_e0, count_e1);//update kinematics information

    switch (state) {
      case 0:    //join line
        pid_join_line();
        break;

      case 1:    //follow line (bangbang with probability)
        pid_follow_line();
        break;

      case 2:     //  determine if Romi is out of line
        //recheck_determine();
        rejoin();
        break;

      case 3:   //face to x direction
        face_x();
        break;

      case 4:     //straight line in -x direction
        straight_x();
        break;

      case 5:
        face_y();
        break;

      case 6:     //straight line in -x direction
        straight_y();
        break;
    }

    pid_power(); // use PID controller to control two motors
    
  if (millis() - time_beep > 500) noTone(6); // control the beeping time after reaching the end
}


/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////Functions///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
void pid_join_line() {
  demandL = -10;
  demandR = -10;
  l_value = line_left.readCalibrated();
  c_value = line_centre.readCalibrated();
  r_value = line_right.readCalibrated();
  sum = l_value + c_value + r_value;
  
  if (sum > 400) {    //switch to state 1
    state = 1;
  }
}

void pid_follow_line() {
  l_value = line_left.readCalibrated();
  c_value = line_centre.readCalibrated();
  r_value = line_right.readCalibrated();
  sum = l_value + c_value + r_value;
  
  if (sum < 100) {   // swich to state 2
    state = 2;
    left_PID.reset();
    right_PID.reset();
    theta_rejoin = kine.get_theta();
  }
  
  l_prob = (float)l_value / sum;
  c_prob = (float)c_value / sum;
  r_prob = (float)r_value / sum;
  M = r_prob - l_prob;
  
  if ( c_prob >= 0.7 || abs(M) <= 0.3) {   ////straight line
    demandL = -7;
    demandR = -7;
  }
  else if ( M > 0.3 && c_prob < 0.7) {     //rotation clock
    demandL = -20 * M;
    demandR = 20 * M;
  }
  else if ( M < -0.3 && c_prob < 0.7) {    //rotation anti-clock
    demandL = -20 * M;
    demandR = 20 * M;
  }
}

void rejoin() {
  l_value = line_left.readCalibrated();
  c_value = line_centre.readCalibrated();
  r_value = line_right.readCalibrated();
  sum = l_value + c_value + r_value;
  theta_dev = kine.get_theta() - theta_rejoin;
  if (flag_back == 0) {   //initial the timestamp bt
    bt = millis();
    flag_back = 1;
  }
  
  if (flag_back == 1) {   //rotate like radar to find line
    if (millis() - bt > 100) {
      switch (rejoin_state) {
        case 0:
          demandL = 7; //anti-clockwise
          demandR = -7;
          if (theta_dev > 0.7) rejoin_state = 1;
          break;

        case 1:
          demandL = -7; //clockwise
          demandR = 7;
          if (theta_dev < -0.7) rejoin_state = 2;
          break;

        case 2:
          demandL = 7; //anti-clockwise
          demandR = -7;
          if (theta_dev > 0) rejoin_state = 3;
          break;

        case 3:   //switch to state 3
          motor_control_pid(0, 0);
          motor_control_pid(1, 0);
          tone(6, 1200);
          time_beep = millis();
          delay(200);

          y_pos = kine.get_ypos();
          if (kine.get_theta() > 0) backhome_dir = 0;
          else backhome_dir = 1;
          
          digitalWrite(LED_BUILTIN, HIGH);
          left_PID.reset();
          right_PID.reset();
          state = 3;
          break;
      }
    }
  }
  
  if (sum > 200) {    //if detect the line, back to follow-line
    state = 1;
    rejoin_state = 0;
    flag_back = 0;
  }
}

void face_x() {
  if (backhome_dir == 1) {
    demandL = 7; //anti-clockwise
    demandR = -7;
  }
  else {
    demandL = -7;  //clockwise
    demandR = 7;
  }
  face_x_theta = kine.get_theta();
  
  if ((face_x_theta > 0 && backhome_dir == 1) || (face_x_theta < 0 && backhome_dir == 0)) {     ///switch to state 4
    state = 4;
    motor_control_pid(0, 0);
    motor_control_pid(1, 0);
    left_PID.reset();
    right_PID.reset();
  }
}

void straight_x() {
  straight_x_theta = kine.get_theta();
  if (straight_x_theta < 0) {
    demandL = 10.2;
    demandR = 10;
  }
  else if (straight_x_theta > 0) {
    demandR = 10.2;
    demandL = 10;
  }
  
  if (kine.get_xpos() > 0) {     //swtich to state 5
    motor_control_pid(0, 0);
    motor_control_pid(1, 0);
    left_PID.reset();
    right_PID.reset();
    state = 5;
  }
}

void face_y() {
  if (y_pos <= 0) {
    demandL = 7;
    demandR = -7;
  }
  else {
    demandL = -7;
    demandR = 7;
  }
  if (abs(kine.get_theta()) > 3.14159 / 2) {   //switch to state 6
    state = 6;
    motor_control_pid(0, 0);
    motor_control_pid(1, 0);
    //delay(200);
    left_PID.reset();
    right_PID.reset();
  }
}

void straight_y() {
  demandL = 10;
  demandR = 10;
  straight_y_ypos = kine.get_ypos();
  
  if ((y_pos <= 0 && straight_y_ypos > 0) || (y_pos > 0 && straight_y_ypos < 0)) {  //end 
    motor_control_pid(0, 0);
    motor_control_pid(1, 0);
    left_PID.reset();
    right_PID.reset();
    delay(200);
    demandL = 0;
    demandR = 0;
  }
}

void pid_power() {
  outputL = left_PID.update(demandL, velocityL);
  outputR = right_PID.update(demandR, velocityR);
  powerL = (int)outputL * 3;
  powerR = (int)outputR * 3;
  motor_control_pid(0, powerL);
  motor_control_pid(1, powerR);
}

void motor_control_pid( boolean side, int power){
  byte PWN_PIN;
  byte DIR_PIN;
  if(side==0){
    PWN_PIN = 10;
    DIR_PIN = 16;
  }
  else{
    PWN_PIN = 9;
    DIR_PIN = 15;
  }
  if (power >= 0){
    digitalWrite( DIR_PIN, 1);
  }
  else{
    digitalWrite( DIR_PIN, 0);
  }
  //digitalWrite( DIR_PIN, dir);
  analogWrite ( PWN_PIN, abs(power));
}

void velocity_measure(int time_intervel) {
  if (micros() - tt > time_intervel) {
    velocityL = (float)15050 * (count_e0 - VL_e0) / (micros() - tt); //transfer the encoder count into velocity
    velocityR = (float)15050 * (count_e1 - VR_e1) / (micros() - tt);

    tt = micros();
    VL_e0 = count_e0;
    VR_e1 = count_e1;
  }
}

void motorsetup() {
    // Set our motor driver pins as outputs.
  pinMode( L_PWM_PIN, OUTPUT );
  pinMode( L_DIR_PIN, OUTPUT );
  pinMode( R_PWM_PIN, OUTPUT );
  pinMode( R_DIR_PIN, OUTPUT );

  // Set initial direction for l and r
  // Which of these is foward, or backward?
  digitalWrite( L_DIR_PIN, LOW  );
  digitalWrite( R_DIR_PIN, LOW );
}
