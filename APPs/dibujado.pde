float dir = 0;
int dist = 400;
int[] c = {0,0,0};
int cdir = 1;
boolean b = false;

void setup() {
  size(640,360);
  strokeWeight(8);
}

void draw() {
  
  //background(255);
  
  dir++;
  if (dir > 360) dir-=360;
  
  float posx = sin(radians(dir))*dist;
  float posy = cos(radians(dir))*dist;
  
  if (!b) {
    if(c[0]<255) c[0]++;
    else if (c[1] < 255)c[1]++;
    else if (c[2] < 255)c[2]++;
    else b = true;
  } else {
    if(c[0]>0) c[0]--;
    else if (c[1] > 0)c[1]--;
    else if (c[2] > 0)c[2]--;
    else b = false;
  }
  
  stroke(c[0],c[1],c[2]);
  
  line(320,180,320-posx,180-posy);
  
}
