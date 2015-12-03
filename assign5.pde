final int GAME_START = 0, GAME_RUN = 1, GAME_OVER =2;
PImage bg1,bg2,enemy,fighter,hp,treasure,start2,start1,end1,end2;
int enemyCount = 8;

int type;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];

int bgX,treasureX,treasureY;
int blood;
int gameState;
final int TOTAL_LIFE = 100;
int life;

int fighterX,fighterY;
float speedX = 4;
float speedY = 4;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
boolean isPlaying = false;

PImage[] flame= new PImage [5];
int timer = 0;
int flamenum=0;
int flameX = 700;
int flameY = 700;

int []shootX = new int [5];
int []shootY = new int [5];
PImage shoot;
int shootNum;
boolean [] shootLimit = new boolean[5];

int score;
PFont scoreFont;

void setup () {
	size(640, 480) ;
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  enemy = loadImage("img/enemy.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  start2 = loadImage("img/start2.png");
  start1 = loadImage("img/start1.png");
  end2 = loadImage("img/end2.png");
  end1 = loadImage("img/end1.png");
  shoot = loadImage("img/shoot.png");
  

  bgX = 0;
  fighterX = 580;
  fighterY = 240;
  treasureX = floor(random(20,590));
  treasureY = floor(random(40,440));
  blood = 40;
  life = 20;
  gameState = GAME_START;
  score = 0;
  scoreFont = createFont("Arial", 32);  
  
  for(int j=0; j<5; j++){
    flame[j]= loadImage("img/flame"+(j+1)+".png");
  }   
  for(int i=0; i<shootLimit.length; i++){
    shootLimit[i] = false;
  }  
  type = 0;
  addEnemy(type);
}

void draw()
{
 /* switch(gameState){
    case GAME_START:
    image(start2,0,0);
    if(mouseX > 205 && mouseX <455 && mouseY >380 && mouseY < 410){
      image(start1,0,0);
      if(mousePressed){
        gameState = GAME_RUN;
      }
    }
    break;
    
    case GAME_RUN:*/
    bg();
    fighter();
    blood();
    drawEnemy();
    shoot();
    score();
    
    //treasure detection
    image(treasure,treasureX,treasureY);
    if(isHit(fighterX, fighterY, fighter.width, fighter.height, treasureX, treasureY, treasure.width, treasure.height) == true){
        life += 10;
        treasureX = floor(random(20,590));
        treasureY = floor(random(40,440));
        if(life >= 100){
          life = 100;
        }
     }    
     
     //enemy detection
    for (int i = 0; i < enemyCount; ++i) { 
          if(isHit(fighterX, fighterY, fighter.width, fighter.height, enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
            life -= 20;
            flame();
            flameX = enemyX[i];
            flameY = enemyY[i];
            flamenum=0;
            enemyX[i] = 700;
          }
    }    
    
    //shoot detection
        for (int i = 0; i < enemyCount; ++i) { 
          for (int j=0; j < 5; j++){
          if(isHit(shootX[j], shootY[j], shoot.width, shoot.height, enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
            score += 10;
            flame();
            flameX = enemyX[i];
            flameY = enemyY[i];
            flamenum=0;
            enemyX[i] = 700;
            shootX[j] = 1000;
          }
       }
    }    

   /* case GAME_OVER:
    image(end2,0,0);
    if(mouseX > 200 && mouseX <440 && mouseY >300 && mouseY < 360){
      if(mousePressed){
        gameState = GAME_RUN;
        life = 20;
        fighterX = 580;
        fighterY = 240;
        score = 0;
      }else{
        image(end1,0,0);
      }
    break;
    }
}*/
}

void drawEnemy(){
  boolean outOfScreen = true;
  for (int i = 0; i < enemyCount; ++i) {
    if (enemyX[i] != -1 || enemyY[i] != -1) {
      image(enemy, enemyX[i], enemyY[i]);
      enemyX[i]+=5;
      if (enemyX[i] <= 640){
        outOfScreen = false;
      }
    }
  }

  // change enemy type
  if (outOfScreen == true) {
    type++;
    if (type > 2)
      type = 0;
    addEnemy(type);
  }
}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{
	for (int i = 0; i < enemyCount; ++i) {
		enemyX[i] = -1;
		enemyY[i] = -1;
	}
	switch (type) {
		case 0:
			addStraightEnemy();
			break;
		case 1:
			addSlopeEnemy();
			break;
		case 2:
			addDiamondEnemy();
			break;
	}
}

void addStraightEnemy()
{
	float t = random(height - enemy.height);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h;
	}
}
void addSlopeEnemy()
{
	float t = random(height - enemy.height * 5);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h + i * 40;
	}
}
void addDiamondEnemy()
{
	float t = random( enemy.height * 3 ,height - enemy.height * 3);
	int h = int(t);
	int x_axis = 1;
	for (int i = 0; i < 8; ++i) {
		if (i == 0 || i == 7) {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h;
			x_axis++;
		}
		else if (i == 1 || i == 5){
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 1 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 1 * 40;
			i++;
			x_axis++;
			
		}
		else {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 2 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 2 * 40;
			i++;
			x_axis++;
		}
	}
}
void bg(){
    image(bg1,bgX,0);
    image(bg2,bgX-bg1.width,0);
    image(bg1,bgX-bg1.width-bg2.width,0);
    bgX++;
    bgX%=(bg1.width+bg2.width);
}

void fighter(){
   image(fighter,fighterX,fighterY);
       if (upPressed) {
        fighterY -= speedY;
      }
      if (downPressed) {
        fighterY += speedY;
      }
      if (leftPressed) {
        fighterX -= speedX;
      }
      if (rightPressed) {
        fighterX += speedX;
      }
      
      if(fighterX > 590){
        fighterX = 590;
      }
      if(fighterX < 0){
        fighterX = 0;
      }
      if(fighterY > 430){
        fighterY = 430;
      }
      if(fighterY < 0){
        fighterY = 0;
      }
}
void blood(){
    fill(255,0,0);
    rect(30,24,blood,20);
    blood = 2*life;
    image(hp,20,20);
}
void score(){
  fill(255);
  textFont(scoreFont);
  text("Score: " + score, 10, 450);
}
void flame(){

     image(flame[flamenum],flameX,flameY);
     timer++;
     if(timer % (60/10) == 0){
       flamenum++;
       timer = 0;
     }
     if(flamenum>=flame.length){
       flameX=700;
       flameY=700;
       flamenum=0;
     }
}
void shoot(){
      for(int i=0; i<5; i++){
        if(shootLimit[i] == true){
          image(shoot, shootX[i], shootY[i]);
          shootX[i] -= 3;
        }
        if(shootX[i] < -shoot.width){
          shootLimit[i] = false;
        }
      }
}

boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh){
  if(ay + ah >= by && by + bh >= ay && ax + aw >= bx && bx + bh >= ax){
    return true;
  }else{
    return false;
  }
}


void keyPressed(){
  if (key == CODED) { 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
  if (key == ENTER){
      if(gameState ==  1){
        if(shootLimit[shootNum] == false ) {
          shootLimit[shootNum] = true;
          shootX[shootNum] = fighterX - 10;
          shootY[shootNum] = fighterY + fighter.height/2;
          shootNum++;
        }   
        if(shootNum > 4) {
          shootNum = 0;
        }
      }
   }   
}


void keyReleased(){
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  } 
}
