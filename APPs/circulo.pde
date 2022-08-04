//Creo la clase circulo con todas sus propiedades
class circulo {
    float xspeed, yspeed;
    int x,y,xdirection, ydirection, rad;
    
    //Constructor del objeto circulo
    circulo(int _x, int _y, int _rad) {
        x = _x; y = _y; rad = _rad;
        xspeed = 2.2; yspeed = 2.8;
        xdirection = 1; ydirection = 1;
    }

    //Función de movimiento
    void move() {
        x+= xspeed*xdirection;
        y+= yspeed*ydirection;
    }
}

//Creo la clase rectangulo con todas sus propiedades
class rectangulo {
    int x,y,xspeed,w,h;
    
    //Constructor del objeto rectangulo
    rectangulo(int _x, int _y, int _w, int _h) {
        x = _x; y = _y; w = _w; h = _h;
    }
    
    //Función de movimiento
    void move() {x += xspeed;}

}

rectangulo Re; //declaro el objeto rectangulo (Re);
circulo Ci; //declaro el objeto circulo (Ci);
boolean left,right;

void setup() {
    
    size(700,400);
    noStroke();
    frameRate(60);
    ellipseMode(RADIUS);
    
    //Instancio el circulo con sus caracteristicas.
    Ci = new circulo(width/2,height/2,60);
    Re = new rectangulo(225,300,250,100);
    left = false;
    right = false;
    
}

void draw() {
    
    Re.move(); //Movimiento del rectangulo;
    Ci.move(); //Movimiento del circulo;
    
    Re.xspeed = (int(right) - int(left)) * 10;
    
    //colision del rectangulo.
    if (Re.x < 0) Re.x = 0;
    if ((Re.x + Re.w) > width) Re.x = width - Re.w;
    if (collision(Re.x+Re.xspeed,Re.y,Ci.x,Ci.y)) Re.xspeed = 0;
    
    //rebote del circulo.
    if (Ci.x+Ci.xspeed*Ci.xdirection > width-Ci.rad || Ci.x+Ci.xspeed*Ci.xdirection < Ci.rad || collision(Re.x,Re.y,int(Ci.x+Ci.xspeed*Ci.xdirection),Ci.y)) Ci.xdirection *= -1;
    if (Ci.y+Ci.yspeed*Ci.ydirection > height-Ci.rad || Ci.y+Ci.yspeed*Ci.ydirection < Ci.rad || collision(Re.x,Re.y,Ci.x,int(Ci.y+Ci.yspeed*Ci.ydirection))) Ci.ydirection *= -1;
    
    
    //Dibujar
    background(125);
    ellipse(Ci.x, Ci.y, Ci.rad, Ci.rad);
    rect(Re.x,Re.y, Re.w, Re.h);

}

void keyPressed() {
    if (key == 'a') left = true;
    if (key == 'd') right = true;
}

void keyReleased() {
    if (key == 'a') left = false;
    if (key == 'd') right = false;
}

//Función de detección de colisiones.
boolean collision(int rx,int ry,int cx,int cy) {
    var px = cx; // En principio son iguales
    if ( px < rx ) px = rx;
    if ( px > rx + Re.w ) px = rx + Re.w;
    
    var py = cy;
    if ( py < ry ) py = ry;
    if ( py > ry + Re.h ) py = ry + Re.h;
    
    var distancia = sqrt( (cx - px)*(cx - px) + (cy - py)*(cy - py) );
    if ( distancia < Ci.rad ) {
        return true;
    } else return false;
}