#ifndef _Line_follow_h
#define _Line_follow_h

//Number of readings to take for calibration
//const int NUM_CALIBRATIONS = ????;

/* 
 *  Class to represent a single line sensor
 */
class LineSensor
{
  public:
    int bias;

    // Required function, class Constructor: 
    // Saves the pin passed in as argument and sets to input
    LineSensor(int line_pin) {
      pin = line_pin;
      pinMode(pin, INPUT);
    }

    // Suggested functions.
    void calibrate();       //Calibrate
    int readRaw();         //Return the uncalibrated value from the sensor
    int readCalibrated();  //Return the calibrated value from the sensor

    // You may wish to add other functions!
    // ...
    
  private:
  
    int pin;
    int l_val;
    int c_val;
    int r_val;
    /*
     * Add any variables needed for calibration here
     */
    
};




// Returns unmodified reading.
int LineSensor::readRaw()
{
  return analogRead(pin);
}

// Write this function to measure any
// systematic error in your sensor and
// set some bias values.
void LineSensor::calibrate()
{
  tone(6,525);
  delay(500);
  noTone(6);
  int i = 0;
  long acc = 0; //acumulator
  for (i; i<100; i++){
    acc = acc + analogRead(pin);
    delay(10);
  }
  bias = int(acc/i);
}


// Use the above bias values to return a
// compensated ("corrected") sensor reading.
int LineSensor::readCalibrated()
{
  int cali_val;
  cali_val = analogRead(pin) - bias;
  return cali_val; 
}


#endif
