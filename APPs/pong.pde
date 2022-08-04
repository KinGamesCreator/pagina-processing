
class circulo {
    float xspeed, yspeed; float x,y,xdirection, ydirection, rad;
    circulo(float _x, float _y, float _rad) {
        x = _x; y = _y; rad = _rad;
        xspeed = 3; yspeed = 2.8;
        xdirection = 1; ydirection = 1;
    } void move() { x+= xspeed*xdirection; y+= yspeed*ydirection; }
}

class rectangulo {
    float x,y,yspeed,w,h;
    rectangulo(int _x, int _y, int _w, int _h) {
        x = _x; y = _y; w = _w; h = _h;
    } void move() {y += yspeed;}
}

rectangulo Re1; rectangulo Re2; circulo Ci;
boolean p1_up, p1_down, p2_up, p2_down, gameStart;
int counter = 10;

void setup() {
    size(700,400); noStroke(); frameRate(60); ellipseMode(RADIUS);
    Ci = new circulo(width/2,height/2,20); Re1 = new rectangulo(0,200,30,100); Re2 = new rectangulo(670,200,30,100);
    p1_up = false; p1_down = false; p2_up = false; p2_down = false; gameStart = false;
}

void draw() {
    
    step();

    //Dibujar
    background(125);
    ellipse(Ci.x, Ci.y, Ci.rad, Ci.rad);
    rect(Re1.x,Re1.y, Re1.w, Re1.h);
    rect(Re2.x,Re2.y, Re2.w, Re2.h);

}

void step() {
    Re1.move(); Re2.move(); Ci.move();
    
    Re1.yspeed = (float(p1_down) - float(p1_up)) * 10;
    Re2.yspeed = (float(p2_down) - float(p2_up)) * 10;
    
    if (Re1.y < 0) Re1.y = 0; if ((Re1.y + Re1.h) > height) Re1.y = height - Re1.h;
    if (Re2.y < 0) Re2.y = 0; if ((Re2.y + Re2.h) > height) Re2.y = height - Re2.h;
    
    if (collision(Re1.x,Re1.y+Re1.yspeed,Ci.x,Ci.y,Re1)) Re1.yspeed = 0;
    if (collision(Re2.x,Re2.y+Re2.yspeed,Ci.x,Ci.y,Re2)) Re2.yspeed = 0;

    if (b_collision_x()) Ci.xdirection *= -1;
    if (b_collision_y()) Ci.ydirection *= -1;
}

void keyPressed() {
    if (key == 'w' || key == 'W') p1_up = true;
    if (key == 's' || key == 'S') p1_down = true;
    if (key == 'i' || key == 'I') p2_up = true;
    if (key == 'k' || key == 'K') p2_down = true;
}

void keyReleased() {
    if (key == 'w' || key == 'W') p1_up = false;
    if (key == 's' || key == 'S') p1_down = false;
    if (key == 'i' || key == 'I') p2_up = false;
    if (key == 'k' || key == 'K') p2_down = false;
}

boolean collision(float rx,float ry,float cx,float cy,rectangulo Rec) {    
    var px = cx; if ( px < rx ) px = rx; if ( px > rx + Rec.w ) px = rx + Rec.w;
    var py = cy; if ( py < ry ) py = ry; if ( py > ry + Rec.h ) py = ry + Rec.h;
    var distancia = sqrt( (cx - px)*(cx - px) + (cy - py)*(cy - py) );
    if ( distancia < Ci.rad ) { return true; } else return false;
}

boolean b_collision_x() {
    if (Ci.x + Ci.xspeed * Ci.xdirection > width - Ci.rad) return true;
    if (Ci.x+Ci.xspeed*Ci.xdirection < Ci.rad) return true;
    if (collision(Re1.x,Re1.y,float(Ci.x+Ci.xspeed*Ci.xdirection),Ci.y,Re1)) return true;
    if (collision(Re2.x,Re2.y,float(Ci.x+Ci.xspeed*Ci.xdirection),Ci.y,Re2)) return true;
    return false;
}

boolean b_collision_y() {
    if (Ci.y+Ci.yspeed*Ci.ydirection > height-Ci.rad) return true;
    if (Ci.y+Ci.yspeed*Ci.ydirection < Ci.rad) return true;
    if (collision(Re1.x,Re1.y,Ci.x,float(Ci.y+Ci.yspeed*Ci.ydirection),Re1)) return true;
    if (collision(Re2.x,Re2.y,Ci.x,float(Ci.y+Ci.yspeed*Ci.ydirection),Re2)) return true;
    return false;
}
