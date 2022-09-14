#ifndef _PID_h
#define _PID_h
#include <stdint.h>

/*Here, the definition of the PID class begins. This is indicated by the keyword: "class"
This is a general description of the data and functions that the class contains. 
To use a class, we must make a specific instance of the class by declaring it into the same way we declare a variable. 
For example, to create a version of the PID class, in our main file we might write:

PID LeftWheelPID;
PID RightWheelPID;

This will create two instances of the PID class; one for the left wheel and one for the right wheel. 
Each class will have a full copy of all the variables and functions defined for that particular class.
*/ 

class PID
{
  /* Public functions and variables are defined here. A public function / variable can be accessed from outside 
   * the class. 
   * For example, once we have made an instance of the PID class, we can call the update function by writing:
   * 
   * LeftWheelPID.update();
   * 
   * Note that this will only update the LeftWheelPID - RightWheelPID will not be updated unless we also call 
   * RightWheelPID.update()
   */
  public:

    PID(float P, float I);                 // This is the class constructor. It is called whenever we create an instance of the PID class 
    void setGains(float P, float I);      // This function updates the values of the gains
    void reset();                                   // This function resets any stored values used by the integral or derative terms
    float update(float demand, float measurement);  // This function calculates the PID control signal. It should be called in a loop
    
  /* Private functions and variables are defined here. These functions / variables cannot be accessed from outside the class.
   * For example, if we try to set the value of Kp in the file "Romi.h", we will get an error (Try it out!) 
   * You might want to move some into public space when you are debugging ;)
   */
  private:

    //Control gains
    float Kp; //Proportional
    float Ki; //Integral

    //We can use this to limit the output to a certain value
    float max_output; 

    //Output components
    //These are used for debugging purposes
    float Kp_output; 
    float Ki_output;
    float output_signal;

    //Values to store between updates().
    float last_demand;      //For storing the previous input
    float last_measurement; //For storing the last measurement
    float last_error;       //For calculating the derivative term
    float error_integral;   //For storing the integral of the error
    long last_millis;       //To track elapsed_time

    long integral_millis;
    
};

/*
 * Class constructor
 * This runs whenever we create an instance of the class
 */
 PID::PID(float P, float I)
{
  //Store the gains
  setGains(P, I);
  
  // Initialise key variables.
  Kp_output     = 0;
  Ki_output     = 0;
  output_signal = 0;

  max_output        = 255;
  last_demand       = 0;
  last_measurement  = 0;
  last_error        = 0;
  error_integral    = 0;
  last_millis       = millis();
  integral_millis = millis();
}


void PID::setGains(float P, float I) {
  Kp = P;
  Ki = I;
}

/*
 * This is the update function. 
 * This function should be called repeatedly. 
 * It takes a measurement of a particular variable (ex. Position, speed, heading) and a desired value for that quantity as input
 * It returns an output; this can be sent directly to the motors, 
 * combined with other control outputs
 * or sent as input to another controller
 */
float PID::update(float demand, float measurement) {
  //Calculate how much time (in milliseconds) has passed since the last update call
  long time_now = millis();
  int time_delta = time_now - last_millis;
  last_millis = time_now;

  /*
   * ================================
   * Your code goes implementation of a PID controller should go here
   * ================================
   */

  //This represents the error term
  // Decide what your error signal is (demand vs measurement)
  float error;
  error = demand - measurement;   
  

  if(millis()-integral_millis>2){
    error_integral = error_integral + error;
    integral_millis = millis();
  }

  //Attenuate above error components by gain values.
  Kp_output = Kp * error;
  Ki_output = Ki * error_integral;

  output_signal = Kp_output + Ki_output;

   
  //Update persistent variables.
  last_demand = demand;
  last_measurement = measurement;
  
  return output_signal;
}





void PID::reset() {
  
  last_error = 0;
  error_integral = 0;
  last_millis = millis();
  
}



#endif
