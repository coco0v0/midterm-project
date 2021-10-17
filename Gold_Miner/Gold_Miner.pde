/*
 * Gold Miner
 * 
 *
 */

import sprites.*;
import sprites.maths.*;
import sprites.utils.*;
import processing.sound.*;

PImage pic1, pic2, pic3, pic4;
PImage button1, button2, button3, button4, button5;
PImage object1, object2, object3, object4, object5;
PImage tB1, tB2, tB3, tB4, tB5;
PImage[] objs;
SoundFile[] file;
int numsounds;
PFont font;
int condition; // Interface switch
Sprite miner;
StopWatch sw;
LevelSystem ls;
Rope rope;
int level, startTime, passTime1, passTime2, yourScore, timer;
String word;
float rate, textRate;
boolean skip, showText;

void setup() {
  size(800, 480, P2D);
  objs=new PImage[8];
  loading();
  textFont(font);
  yourScore=0;
  level=1;
  timer=60;
  skip=false;
  showText=false;

  // Creating a Game timer
  sw = new StopWatch();

  ls=new LevelSystem(300);
  rope=new Rope();
  file[0].play();
}

void reset() {
  yourScore=0;
  level=1;
  skip=false;
  textRate=0;
  showText=false;

  // Creating a Game timer
  sw = new StopWatch();

  ls=new LevelSystem(300);
  rope=new Rope();
}

// Game material loading
void loading() {
  pic1=loadImage("mainmenu.jpg");
  pic2=loadImage("map_day.jpg");
  pic3=loadImage("desertbackground.jpg");
  pic4=loadImage("winbackground.png");

  // Loading game music
  numsounds=10;
  file = new SoundFile[numsounds];
  for (int i = 0; i < numsounds; i++) {
    file[i] = new SoundFile(this, (i+1) + ".wav");
  }

  button1=loadImage("menuplaybutton.png");
  button2=loadImage("targetplaybutton.png");
  button3=loadImage("gameicon.png");
  button4=loadImage("humanbarrow.png");
  button5=loadImage("timeout.png");

  object1=loadImage("targetboard.png");
  object2=loadImage("claw.png");
  object3=loadImage("rope.png");
  object4=loadImage("youwin.png");
  object5=loadImage("theendtext.png");

  tB1=loadImage("targetbackground.png");
  tB2=loadImage("moneybackground.png");
  tB3=loadImage("levelbackground.png");
  tB4=loadImage("timebackground.png");
  tB5=loadImage("talkbackground.png");

  // Load gold, diamonds, etc
  objs[0]=loadImage("rock10.png");
  objs[1]=loadImage("rock20.png");
  objs[2]=loadImage("gold50.png");
  objs[3]=loadImage("gold100.png");
  objs[4]=loadImage("gold250.png");
  objs[5]=loadImage("gold500.png");
  objs[6]=loadImage("dinamond.png");
  objs[7]=loadImage("gold1000.png");

  font=createFont("luximb.ttf", 40);

  miner= new Sprite(this, "humanrolling.png", 4, 1, 0);
  miner.setXY(width/2, 80);
  miner.setVisible(true);
  miner.setFrameSequence(0, 3, 0);  // Set the miner's movements and speed

  registerMethod("pre", this);
}

void pre() {
  float elapsedTime = (float) sw.getElapsedTime();
  miner.update(elapsedTime);  // update
}

void draw() {
  if (condition==0) {  // Game initial interface
    image(pic1, 0, 0);
    image(button1, 600, 300);
  } else if (condition==1) {   // Start the game screen
    image(pic2, 0, 0);
    image(object1, width/2-object1.width/2, 0);
    image(button2, width/2-button2.width/2, 360);
    fill(#98295F);
    textSize(50);
    textAlign(LEFT);
    text(ls.targetScore, width/2-50, 300);
  } else if (condition==2) {  // The game interface
    // Time record
    passTime1= int((millis() - startTime)/1000) % 60;
    passTime2=int((millis() - startTime)/(60*1000)) % 60;
    imageMode(CORNER);
    background(pic2);
    image(tB1, 0, -5);
    fill(#98295F);
    textSize(20);
    textAlign(LEFT);
    text(ls.targetScore, 60, 35);
    image(tB2, 0, 40);
    text(yourScore, 60, 80);
    image(tB3, 660, 20, 60, 60);
    textAlign(CENTER);
    textSize(30);
    text(level, 690, 70);
    image(tB4, 730, 20, 60, 60);
    textSize(20);
    text(timer-passTime1-passTime2*60, 760, 60);

    // The default is imageMode(CENTER)
    miner.draw();
    ls.show();
    rope.show();
    if (rope.state==1) {
      ls.catchGold();
    }
    image(button5, 620, 50, 60, 60);
    upgrade();  // upgrade
  } else if (condition==3) {  // Game completion interface
    imageMode(CENTER);
    image(pic3, width/2, height/2);
    // Font enlargement effect
    if (textRate>=PI/2) {
      textRate=PI/2;
      image(button3, width/2, height/2+150, 100, 100);
    } else {
      textRate+=0.02;
    }
    image(object4, width/2, height/2-50, 650*sin(textRate), 154*sin(textRate));
    imageMode(CORNER);
  } else if (condition==4) {  // Game failure interface
    imageMode(CENTER);
    image(pic4, width/2, height/2);
    // Font enlargement effect
    if (textRate>=PI/2) {
      textRate=PI/2;
      image(button4, width/2, height/2+100);
    } else {
      textRate+=0.01;
    }
    image(object5, width/2, height/2-50, 480*cos(textRate), 260*cos(textRate));
    imageMode(CORNER);
  }
}

// To upgrade the customs clearance
void upgrade() {
  if ((timer-passTime1-passTime2*60<=0||skip==true)&&yourScore>=ls.targetScore) {
    file[7].play();
    condition=3;
    rope=new Rope();
    miner.setFrameSequence(0, 3, 0); 
    level+=1;
    skip=false;
    textRate=0;
  } else if ((timer-passTime1-passTime2*60<=0||skip==true)&&yourScore<ls.targetScore) {
    file[8].play();
    condition=4;
    miner.setFrameSequence(0, 3, 0);
    textRate=0;
  }
}

void mousePressed() {
  if (mouseButton == LEFT&&dist(665, 360, mouseX, mouseY)<50) {  // Switch to the start game screen
    condition=1;
    file[0].stop();
    file[1].play();
  } else if (mouseButton == LEFT&&dist(width/2, 420, mouseX, mouseY)<50&&condition==1) {  // 切换到游戏界面
    condition=2;
    file[2].play();
    startTime = millis();
  } else if (mouseButton == LEFT&&dist(620, 50, mouseX, mouseY)<=50&&condition==2) {
    file[6].play();
    skip=true;
  } else if (mouseButton == LEFT&&condition==2&&rope.state==0) {  // Press the left mouse button to release the hook
    rope.state=1;
    miner.setFrameSequence(0, 3, 0.2);
  } else if (mouseButton == LEFT&&dist(width/2, height/2+150, mouseX, mouseY)<50&&condition==3&&textRate==PI/2) {  // 按下鼠标左键，释放钩子
    file[9].play();
    condition=1;  // The next level begins
    textRate=0;
    ls=new LevelSystem((int)(ls.targetScore*1.5));
  } else if (mouseButton == LEFT&&dist(width/2, height/2+100, mouseX, mouseY)<100&&condition==4&&textRate==PI/2) {  // 按下鼠标左键，释放钩子
    file[9].play();
    condition=0;  // Home page
    file[0].play();
    reset();
  }
}
