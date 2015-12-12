final int GAME_START=0, GAME_RUN=1, GAME_WIN=2, GAME_OVER=3;
final int ENEMY_0=0, ENEMY_1=1, ENEMY_2=2;
PImage bg1,bg2,enemy,fighter,hp,treasure,start2,start1,end1,end2;
int enemyCount = 8;
int gameState;
int enemyType=0;

int c=0;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
int hpy=40;
float treasureX,treasureY;
int shipx,shipy;
int speed=4;
int score=0;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

PImage[] shoot = new PImage[6];
boolean [] bulletlimit = new boolean[5];
int [] bullet_x=new int[5];
int [] bullet_y=new int[5];
int bulletSpeed=3;
int space;
int bulletnumber=0;
int closeEnemy;

void setup () {
  size(640, 480) ;
  enemy=loadImage("img/enemy.png");
  bg1=loadImage("img/bg1.png");
  bg2=loadImage("img/bg2.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  
  treasureX = floor(random(20,590));
  treasureY = floor(random(40,440));
   shipx = width-50;
   shipy = height/2;

  for(int i =0; i<shoot.length;i++){
      shoot[i]=loadImage("img/shoot.png"); 
    }
  for(int i=0;i<=4;i++){
    bullet_x[i]=-300;
    bullet_y[i]=-300;
  }
}

void draw(){
  switch(gameState){
    case GAME_START:
      image(start2,0,0);
      if(mouseX > 205 && mouseX <455){
        if(mouseY >380 && mouseY <415){
          image(start1,0,0);
            if(mousePressed)
              gameState = GAME_RUN;
              enemyType=0;
              reset();
        }
      }
      break;
    case GAME_RUN:
      drawBg();
      drawBlood();
      drawScore();
      
      image(fighter,shipx,shipy);
      image(treasure,treasureX,treasureY);

      bullet_number();

      //closesttoEnemy
      for(int i = 0; i < 5;i++){
        closestEnemy(bullet_x[i],bullet_y[i]);
        if(enemyX[0]>0){
          if(closeEnemy != -1 && enemyX[closeEnemy] < bullet_x[i]){
            if(enemyY[closeEnemy]>0){
              if(enemyY[closeEnemy] > bullet_y[i]){
                bullet_y[i] += 3;
               }else if(enemyY[closeEnemy] < bullet_y[i]){
                bullet_y[i] -= 3;
               }  
            }  
            }
          }
      }
      
      if (isHit(shipx, shipy ,fighter.width, fighter.height,treasureX,treasureY, treasure.width, treasure.height) == true){
          if(hpy<200)
            hpy=hpy+20;
          treasureX = random(600);
          treasureY = random(440);
      }
        switch(enemyType){
            
            case ENEMY_0:
                drawEnemy();
                if(enemyX[1]>1000){
                  addEnemy(1);
                  enemyType=1;
                }
                for(int i =0;i<enemyX.length;i++){
                  if (isHit(shipx, shipy ,fighter.width, fighter.height,enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
                      enemyY[i] = -1000;
                      hpy=hpy-20;
                  }
                  for(int j=0;j<bullet_x.length;j++){
                      if (isHit(bullet_x[j], bullet_y[j] ,shoot[j].width, shoot[j].height,enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
                          enemyY[i] = -1000;
                          bullet_y[j]=-300;
                          bullet_x[j]=-300;
                          scoreChange(20);
                      }
                   }
                }
                if(hpy<=0){
                   gameState=3;
                }
            break;
            
            case ENEMY_1:
                drawEnemy();
                if(enemyX[2]>1000){
                  addEnemy(2);
                  enemyType=2;
                }
                for(int i =0;i<enemyX.length;i++){
                  if (isHit(shipx, shipy ,fighter.width, fighter.height,enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
                      enemyY[i] = -1000;
                      hpy=hpy-20;
                  }
                  for(int j=0;j<bullet_x.length;j++){
                      if (isHit(bullet_x[j], bullet_y[j] ,shoot[j].width, shoot[j].height,enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
                          enemyY[i] = -1000;
                          bullet_y[j]=-300;
                          bullet_x[j]=-300;
                          scoreChange(20);
                      }
                   }
                }
                if(hpy<=0){
                   gameState=3;
                }
            break;
             
            case ENEMY_2:
                drawEnemy();
                if(enemyX[3]>1000){
                  addEnemy(0);
                  enemyType=0;
                }
                for(int i =0;i<enemyX.length;i++){
                  if (isHit(shipx, shipy ,fighter.width, fighter.height,enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
                      enemyY[i] = -1000;
                      hpy=hpy-20;
                  }
                  for(int j=0;j<bullet_x.length;j++){
                      if (isHit(bullet_x[j], bullet_y[j] ,shoot[j].width, shoot[j].height,enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
                          enemyY[i] = -1000;
                          bullet_y[j]=-300;
                          bullet_x[j]=-300;
                          scoreChange(20);
                      }
                   }
                }
                if(hpy<=0){
                   gameState=3;
                }
              break;
            }
            drawFighter();
      
      break;
    case GAME_OVER:
      image(end2,0,0);
        if(mouseX > 205 && mouseX <440){
          if(mouseY >305 && mouseY <350){
            image(end1,0,0);
              if(mousePressed){
                gameState = GAME_RUN;
                reset();
              }
           }
        }
      break;
    }
}

void reset(){
  hpy=40;
  score=0;
  shipx = width-50;
  shipy = height/2;
  addEnemy(0);
  for(int i=0;i<5;i++){
    bullet_x[i]=-300;
    bullet_y[i]=-300;
  }
}

int closestEnemy(int bullet_x,int bullet_y){
  float enemyDistance = 1000;
  if (enemyX[7] > width || (enemyX [5] == -1 && enemyX[4] > width)){
    closeEnemy = -1;
  }else{    
    for( int i= 0; i < 8; i++ ){
      if(enemyY[i]>0){
      if ( enemyX[i] != -1 ) {
        if( dist(bullet_x, bullet_y, enemyX[i], enemyY[i]) < enemyDistance){
          enemyDistance = dist(bullet_x,bullet_y, enemyX[i], enemyY[i]);
          closeEnemy = i;
        }
      }
      }
    }  
  }  
  return closeEnemy;
}
void drawEnemy(){
  for (int i = 0; i < enemyCount; ++i) {
    if (enemyX[i] != -1 || enemyY[i] != -1) {
      image(enemy, enemyX[i], enemyY[i]);
      enemyX[i]+=5;
    }
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
void drawFighter(){
   image(fighter,shipx,shipy);
      if(upPressed){
        shipy -= speed;
      }
      if(downPressed){
        shipy += speed;
      }
      if(leftPressed){
        shipx -= speed;
      }
      if(rightPressed){
        shipx += speed;
      }
      if(shipx>=width-50){
        shipx = width-50;
      }
      if(shipx<=0){
        shipx = 0;
      }
      if(shipy>=height-50){
        shipy = height-50;
      }
      if(shipy<=0){
        shipy = 0;
      }
}
void drawBg(){
   image(bg2,c,0);
   image(bg1,c-640,0);
   image(bg2,c-1280,0);
   c++;
   c=c%1280;
}
void drawBlood(){
   fill(255,0,0);
   rect(18, 13, hpy, 20);
   image(hp,10,10);   
}
void drawScore(){
   fill(255);
   textSize(32);
   text("score:"+score, 20, 450); 
}

void keyPressed(){
  if(key == CODED){
    switch(keyCode){
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
  if(key==' '){
    if(gameState==1){
      
          if(bulletlimit[bulletnumber]==false){
            bulletlimit[bulletnumber]=true;
            bullet_x[bulletnumber]=shipx-10;
            bullet_y[bulletnumber]=shipy+10;
            bulletnumber++;
          }
          if(bulletnumber>4)
            bulletnumber = 0;
       }
    } 
}
void keyReleased(){
  if(key == CODED){
    switch(keyCode){
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
void scoreChange(int value){
    score =score+value;
}

boolean isHit(float ax,float ay,float aw,float ah,float bx,float by,float bw,float bh){
  if (ax >= bx - aw && ax <= bx + bw && ay >= by - ah && ay <= by + bh){
  return true;
  }
  return false;  
}

//bulletlimit
void bullet_number(){
  for(int i=0;i<5;i++){
    if(bulletlimit[i]==true){
      image(shoot[i],bullet_x[i],bullet_y[i]);
      bullet_x[i]=bullet_x[i]-bulletSpeed;
    }
    if(bullet_x[i]< -shoot[i].width){
      bulletlimit[i]=false;
      bullet_x[i]=-300;
      bullet_y[i]=-300;
    }
  }
}
