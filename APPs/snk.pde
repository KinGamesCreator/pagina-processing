PImage snk_head;
PImage snk_tail;
PImage snk_apple;
PImage snk_bg;
PImage snk_restart;
PImage snk_buttons;

class position {
  int x;
  int y;
  position(int _x,int _y) {
    x = _x;
    y = _y;
  }
}

position[] snake;
position apple;
String ant_direction = "";
String direction = "";
int gWidth = 20;
int gHeight =  20;

void load_level(){
  snake = new position[1];
  snake[0] = new position(round(gWidth/2),round(gHeight/2));
  apple = new position(gHeight-2,snake[0].y);
}

float pSize;
void setup(){ //SETUP
  
  snk_head = loadImage("./APPs/sprites/snake/snake_head.png");
  snk_tail = loadImage("./APPs/sprites/snake/snake_tail.png");
  snk_apple = loadImage("./APPs/sprites/snake/snake_apple.png");
  snk_bg = loadImage("./APPs/sprites/snake/background.png");
  snk_restart = loadImage("./APPs/sprites/snake/restart.png");
  snk_buttons = loadImage("./APPs/sprites/snake/buttons.png");
  
  size(600,600);
  load_level();
  pSize = 600/20;
}

int timeout = 0;

void draw(){ //DRAW

  if (millis() < timeout+150) return;
  timeout = millis();

  step();
  
  image(snk_bg,0,0,pSize*20,pSize*20);
  image(snk_apple,apple.x*pSize,apple.y*pSize,pSize,pSize);
  image(snk_head,snake[0].x*pSize,snake[0].y*pSize,pSize,pSize);
  for(var i = 1; i < snake.length;i++) {
    image(snk_tail,snake[i].x*pSize,snake[i].y*pSize,pSize,pSize);
  }
  
  if (gameEnd) image(snk_restart,0,0,width,height);
  if (direction == "") image(snk_buttons,0,0,width,height);
  
}

boolean gameEnd = false;

void step(){ //STEP
  if (direction == "") return;
  if (gameEnd) {
    gameEnd = false;
    load_level();
  }
  
  var pPos = new position(snake[0].x,snake[0].y);
  
  switch(direction) {
    case "UP":
      pPos.y--;
    break;
    case "DOWN":
      pPos.y++;
    break;
    case "RIGHT":
      pPos.x++;
    break;
    case "LEFT":
      pPos.x--;
    break;
  }

  ant_direction = direction;
  
  if (pPos.x < 0 || pPos.x >= gWidth || pPos.y < 0 || pPos.y >= gHeight) { direction = ""; gameEnd= true; return; }
  
  for(var i = 1; i < snake.length; i++) {
    if (pPos.x == snake[i].x && pPos.y == snake[i].y) { direction = ""; gameEnd= true; return; }
  }
  
  if (pPos.x == apple.x && pPos.y == apple.y) {
    increase_snake();
    snake[snake.length-1] = new position(snake[snake.length-2].x,snake[snake.length-2].y);
    apple.x = floor(random(gWidth));
    apple.y = floor(random(gHeight));
  }
  
  for (var i = snake.length-1; i > 0; i--) {
    snake[i] = snake[i-1];
  }
  
  snake[0] = pPos;
  
  appleCollision();
  
}

//Funciones

void increase_snake() {
  var _aux = new position[snake.length+1];
  arrayCopy(snake,_aux);
  snake = _aux;
}

void keyPressed() {
  if (key == 'w' && ant_direction != "DOWN") direction = "UP";
  if (key == 'a' && ant_direction != "RIGHT") direction = "LEFT";
  if (key == 's' && ant_direction != "UP") direction = "DOWN";
  if (key == 'd' && ant_direction != "LEFT") direction = "RIGHT";
}

void appleCollision() {
  var collision = true;
  while(collision) {
    collision = false;
    for(var i = 0; i < snake.length; i++) {
      if (apple.x == snake[i].x && apple.y == snake[i].y) collision = true;
    }
    if (!collision) return;
    
    apple.x++;
    if (apple.x >= gWidth) {
      apple.x = 0; apple.y++;
      if (apple.y >= gHeight) {
        apple.y = 0;
      }
    }
    
  }
}
