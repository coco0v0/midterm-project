// Gold, diamonds, stones, bombs

class Gold {
  PVector pos;
  float size;
  int shape, score;
  float speed, angle;

  Gold(PVector pos, int shape) {
    this.pos=pos;
    this.shape=shape;
    if (shape!=7)
      size=objs[shape].width;
    else
      size=objs[shape].width/3;  // The size of the large nugget picture is larger
    setupScore();
  }


  // Initialization score
  void setupScore() {
    if (shape==0) {
      score=10;
    } else if (shape==1) {
      score=20;
    } else if (shape==2) {
      score=50;
    } else if (shape==3) {
      score=100;
    } else if (shape==4) {
      score=250;
    } else if (shape==5) {
      score=500;
    } else if (shape==6) {
      score=600;
    } else if (shape==7) {
      score=1000;
    }
  }

  void move() {
    pos.x+=speed*sin(angle);
    pos.y-=speed*cos(angle);
  }

  void show() {
    move();
    image(objs[shape], pos.x, pos.y, size, size);
  }
}
