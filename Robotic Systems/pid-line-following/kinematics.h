#ifndef _Kinematics
#define _Kinematics_h

#define PI 3.1415926535897932384626433832795
#define L_PWM_PIN 10
#define L_DIR_PIN 16
#define R_PWM_PIN  9
#define R_DIR_PIN 15

//You may want to use some/all of these variables
const float WHEEL_DIAMETER              = 70.0f; // Diameter in mm.
const float WHEEL_RADIUS                = 35.0f; // Radius in mm.
const float WHEEL_SEPERATION            = 140.0f; // Distance between wheels.

const float GEAR_RATIO                  = 1.0f/120.0f; // Gearbox --- 1 : 120.
const float COUNTS_PER_SHAFT_REVOLUTION = 12.0f; // 1 Shaft Revolution = 12 counts
const float COUNTS_PER_WHEEL_REVOLUTION = 1440.0f; // 1 Wheel Revolution = 1440 counts.
const float COUNTS_PER_MM               = (1 / (WHEEL_DIAMETER * PI)) * COUNTS_PER_WHEEL_REVOLUTION; 


// Build up your Kinematics class.
class Kinematics
{
  public:
    
    Kinematics();   // Constructor, required.

    void update(long count_left, long count_right);  // should calucate an update to pose.
    float face_home();
    float home_distance();
    
    float get_theta();
    float get_xpos();
    float get_ypos();
    void reset_kine();
    void reset_theta();
    void motor_control( boolean side, boolean dir, byte power);
    void theta_straightline(float initial_theta, boolean dir, byte power);

    
  private:
    
    //Private variables and methods go here
    float xpos;
    float ypos;
    float theta;

    long old_count_left;
    long old_count_right;
    float old_theta;
    
};


// Required constructor. Initialise variables.
Kinematics::Kinematics() // works as the setup();
{
  xpos = 0;
  ypos = 0;
  theta = 0;

  old_count_left = 0;
  old_count_right = 0;
  old_theta = 0;
}



void Kinematics :: update(long count_left, long count_right) 
{
  // count the change of count of both wheels:
  long left_count_change = count_left - old_count_left;
  long right_count_change = count_right - old_count_right;

  // calculate the distance (mm) of two wheels:
  float left_distance = (float)left_count_change / COUNTS_PER_MM;
  float right_distance = (float)right_count_change / COUNTS_PER_MM;

  // use the mean change in encoder count between the two wheels.
  // avg_distance
  float d = (left_distance + right_distance) / 2.0f;

  theta = theta + (left_distance - right_distance) / WHEEL_SEPERATION;

  // from the view of the map: going right, x++; going down, y++;
  xpos = xpos + d * cos(theta);
  ypos = ypos + d * sin(theta); 

  // turn right --- theta ++ ; turn left --- theta -- ;
  //theta = theta + (left_distance - right_distance) / WHEEL_SEPERATION;

//  Serial.print( xpos );
//  Serial.print( ", " );
//  Serial.print( ypos );
//  Serial.print( ", " );
//  Serial.println( theta );

  old_count_left = count_left;
  old_count_right = count_right;
  
  return;
}


// This part is tricky.
float Kinematics :: face_home() 
{
  float angle = PI - theta ;   // unit: degree.
//  float angle = 180 - (theta / (2 * PI) * 360);   // unit: degree.
//  float pos_theta = atan2(-ypos,-xpos);
//  float angle;
//  if(pos_theta>=0){
//    angle = -(PI-pos_theta+theta);
//  }
//  else if(pos_theta<0){
//    angle = -(-PI-pos_theta+theta);
//  }
  return angle;
}


// Calculate the distance from pos to home.
float Kinematics :: home_distance() 
{
  float distance = sqrt(xpos * xpos + ypos * ypos);
  return distance;
}


void Kinematics :: reset_theta() 
{
  theta = 0;
}


float Kinematics :: get_theta() 
{
  return theta;
}

float Kinematics :: get_xpos() 
{
  return xpos;
}

float Kinematics :: get_ypos() 
{
  return ypos;
}

void Kinematics :: reset_kine()
{
  xpos = 0;
  ypos = 0;
  theta = 0;
}

//0-正向，1-反向
void Kinematics :: motor_control( boolean side, boolean dir, byte power){
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
  digitalWrite( DIR_PIN, dir);
  analogWrite ( PWN_PIN, power);
}


//dir=0正向  dir=1反向
void Kinematics :: theta_straightline( float initial_theta, boolean dir, byte power )
{
  float theta_error = theta - initial_theta;
  byte powerL = power;
  byte powerR = power;
  digitalWrite( 16, dir);
  digitalWrite( 9, dir);
  if (dir == 0){
    if (theta_error > 0){
      powerL = power+3;
    }
    else {
      powerR = power+3;
    }
  }
  else if(dir == 1){
     if (theta_error > 0){
      powerR = power+3;
    }
    else {
      powerL = power+3;
    } 
  }
  motor_control(0,dir,powerL);
  motor_control(1,dir,powerR);
}

#endif
