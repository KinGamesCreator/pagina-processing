
//CARGAR NIVEL

public int[][] c_content;
public int[][] c_view;

public void load_level(int bombs,int _width,int _height) {
  c_content = new int[_height][_width];
  c_view    = new int[_height][_width];
  
  for (var i = 0; i < c_content.length; i++) {
     for (var k = 0; k < c_content[i].length; k++) {
       c_content[i][k] = 0; c_view[i][k]    = 0;
     }
  }
  
  //colocar bombas
  while(bombs > 0) {
    int aux_x = floor(random(_width));
    int aux_y = floor(random(_height));
    if (c_content[aux_y][aux_x] != -1) { c_content[aux_y][aux_x] = -1; bombs--; }
  }
  
  //calcular números
  int aux_count;
  for (var i = 0; i < c_content.length; i++) {
     for (var k = 0; k < c_content[i].length; k++) {
       if (c_content[i][k] == -1) continue;
       aux_count = 0;
       //comprobaciones
       if (i != 0 && c_content[i-1][k] == -1) aux_count++;
       if (i != 0 && k != 0 && c_content[i-1][k-1] == -1) aux_count++;
       if (i != 0 && k != (c_content[i].length-1) && c_content[i-1][k+1] == -1) aux_count++;
       if (i != (c_content.length-1) && c_content[i+1][k] == -1) aux_count++;
       if (i != (c_content.length-1) && k != 0 && c_content[i+1][k-1] == -1) aux_count++;
       if (i != (c_content.length-1) && k != (c_content[i].length-1) && c_content[i+1][k+1] == -1) aux_count++;
       if (k != (c_content[i].length-1) && c_content[i][k+1] == -1) aux_count++;
       if (k != 0 && c_content[i][k-1] == -1) aux_count++;
       c_content[i][k] = aux_count;
     }
  }
  
}

//CARGA DE SPRITES

public PImage[] numbers;
public PImage[] blocks;

public void load_sprites() {
  PImage[] _aux = {
    loadImage("./APPs/sprites/minesweeper/numbers/-1.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/0.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/1.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/2.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/3.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/4.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/5.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/6.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/7.png"),
    loadImage("./APPs/sprites/minesweeper/numbers/8.png")
  };
  numbers = _aux;
  PImage[] _aux2 = {
    loadImage("./APPs/sprites/minesweeper/celdas/0.png"),
    loadImage("./APPs/sprites/minesweeper/celdas/1.png")
  };
  blocks = _aux2;
}

//POINT IN RECTANGLE
public boolean point_in_rectangle (int pX, int pY, int x1, int y1, int x2, int y2) {
  if (pX > x1 && pX < x2 && pY > y1 && pY < y2) return true;
  return false;
}

//Cuando se selecciona una casilla...
public void seleccionar(int _y,int _x) {
  c_view[_y][_x] = -1; //marcar como seleccionada.
  if (c_content[_y][_x] == -1) perder(); // si era una bomba
  if (c_content[_y][_x] == 0) { //si era un espacio en blanco, seleccionar todos los que estén junto a él.
    int[] _help = {-1,0,1};
    for (var i = 0; i < _help.length; i++) {
      for (var k = 0; k < _help.length; k++) {
        if (_y+_help[i] < 0) continue;
        if (_x+_help[k] < 0) continue;
        if (_y+_help[i] >= c_view[0].length) continue;
        if (_x+_help[k] >= c_view.length) continue;
        if ((c_view[_y+_help[i]][_x+_help[k]]) == -1) continue;
        seleccionar(_y+_help[i],_x+_help[k]);
      }
    }
  }
  
}

public boolean gameEnd = false;

public void perder () {
  gameEnd = true;
  for (var i = 0; i < c_content.length; i++) {
     for (var k = 0; k < c_content[i].length; k++) {
       if (c_content[i][k] == -1) c_view[i][k] = -1;
     }
  }
}

boolean click = false;
boolean hold = false;

void mousePressed() {
  if (hold == false) {
    hold = true;
    click = true;
  }
}
void mouseReleased() {
  click = false;
  if (hold == true) {
    hold = false;
  }
}

float spr_size;
void setup() {
  size(600,600);
  load_level(40,15,15);
  load_sprites();
  spr_size = width/c_content.length;
  fill(225,225,225,100);
}

public boolean change = false;
public int mX = -1; // Casilla en la que se
public int mY = -1; // encuentra el ratón.
void draw() {

  mX = int(floor(mouseX/spr_size));
  mY = int(floor(mouseY/spr_size));
  if (mX >= c_view[0].length || mY >= c_view.length) { mX = -1; mY = -1; }
  
  step();
  
  for (var i = 0; i < c_content.length; i++) { //DIBUJAR MAPA
    for (var k = 0; k < c_content[i].length; k++) {
      if (change) { image(numbers[c_content[i][k]+1],spr_size*k,spr_size*i,spr_size,spr_size); }
      if (c_view[i][k] != -1) image(blocks[c_view[i][k]],spr_size*k,spr_size*i,spr_size,spr_size);
    }
  }
  
  //DIBUJAR SELECCIÓN
  if (c_view[mY][mX] != -1) rect(mX*spr_size,mY*spr_size,spr_size-1,spr_size-1);
  change = false;

  click = false;
}

void step () {
  
  if (gameEnd && mouseButton == LEFT ) {
    if (click) {
      gameEnd = false; load_level(40,15,15);
    }; return;
  }
  
  if (mX != -1 && click && c_view[mY][mX] != -1) {
    if (mouseButton == LEFT && c_view[mY][mX] == 0) {
      seleccionar(mY,mX);
      change = true;
    } else if (mouseButton == RIGHT) {
      c_view[mY][mX] = int(!boolean(c_view[mY][mX]));
    }
  }
}

