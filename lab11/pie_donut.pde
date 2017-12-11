// Lab 3
class Pie{
  float start_angle;
  float stop_angle;
  color c;
  
  boolean is_highlighted;
  
  Pie(float start, float stop){
    start_angle = start;
    stop_angle = stop;
    is_highlighted = false;
    c = color(255,255,255);
  }
  
  void drawPie(){
     fill(c);
     ellipseMode(CENTER);
     arc(width/ 2, height /2, width / 2, height /2, start_angle, stop_angle);
     float x = 300 * cos(stop_angle);
     float y = 300 * sin(stop_angle);
     line(width/2, height/2, x, y);
  }
  
  boolean mouseInside(){
    float x = mouseX - width/2;
    float y = -1 * (mouseY - height/2);
    float angle =  atan(y/x);
    float len = sqrt((y*y) + (x*x));
    //println("X: " + x + "  Y:  " + y);
    //println("Angle: " + angle);
    
    int quad;
    
    if(x >= 0 && y >= 0)
      quad = 0;
    else if(x < 0 && y < 0)
      quad = 2;
    else if( x >= 0 && y < 0)
      quad = 1;
    else
      quad = 3;
      
    if(quad == 0){
       angle = 2 * PI - angle; 
    } else if(quad == 3){
       angle = PI + angle * (-1);
    }  else if(quad == 2){
       angle = PI - angle;
    } else{
       angle = (-1) * angle; 
    }
    //print("Quad: " + quad);
    if(angle >= start_angle && angle <= stop_angle && len <= (width/4)){
       c = color(60, 60 , 60);
       return true;
    }
    else {
       c = color(255, 255, 255);
       return false;
    }    
    
  }
}

class PieChart{
    String[] departments;
    int[] num_students;
    Pie[] pies;
    int total_students = 0;
    
    PieChart(String[] d, int[] n){
        departments = d;
        num_students = n;
        pies = new Pie[d.length];
        
        for(int i = 0; i < num_students.length; i++){
           total_students += num_students[i]; 
        }
    }
    
    void populatePies(){
       float start_angle = 0;
       for(int i = 0; i < pies.length; i++){
          float ratio = (float)num_students[i] / (float)total_students;
          Pie p = new Pie(start_angle, start_angle + (2 * PI * ratio));
          start_angle += 2 * PI * ratio;
          pies[i] = p;
       }
    }
    
    void drawPies(){
      for(int i = 0; i < pies.length; i++){
         pies[i].drawPie();
      }
    }
}

String [] lines;
String [] headers;
String [] departments;
int [] num_students;

PieChart chart;

void setup() {
   size(600,600);
   lines = loadStrings("./data.csv");
   headers = split(lines[0], ",");
   departments = new String[lines.length - 1];
   num_students = new int[lines.length - 1];
   
   for(int i = 1; i < lines.length; i++){
      String[] data = split(lines[i], ",");
      departments[i - 1] = data[0];
      num_students[i - 1] = int(data[1]);
   }
   //for(int i = 1; i < lines.length; i++){
   //   print(departments[i - 1] + "\n");
   //   print(num_students[i - 1] + "\n");
   //}
   chart = new PieChart(departments, num_students);
   chart.populatePies();
}


float origin_x;
float origin_y;

void draw() {
  background(220,220,220);
  origin_x = width / 2;
  origin_y = height / 2;
  chart.drawPies();
  fill(255,255,255);
  rect(0, 0, 350, 50);
  
  fill(0,0,0);
  text("Department: " + departments[current_index] + ",  Students: " + num_students[current_index], 15, 25);
}
int current_index;

void mouseMoved() {
  for(int i = 0; i < chart.pies.length; i++){
    //mouseInside
    if(chart.pies[i].mouseInside()){
       current_index = i; 
    }
  }
}