// Ropes and hooks

class Rope {
  PVector pos;
  float angle, da;
  float speed;
  int state;
  ArrayList<PVector> vertexs;

  Rope() {
    pos=new PVector(0, 15);
    state=0;  // The rope swing
    speed=4;
    da=0.025;
    vertexs=new ArrayList<PVector>();
  }

  // swing
  void shake() {
    if (state==0)
      angle+=da;

    if (angle>PI/2.5) {
      angle=PI/2.5;
      da=-da;
    } else if (angle<-PI/2.5) {
      angle=-PI/2.5;
      da=-da;
    }
  }

  // scaling
  void extend() {
    if (state==1)
      pos.y+=speed;
    else if (state==2) {
      pos.y-=speed;
      if (pos.y<=15) {
        miner.setFrameSequence(0, 3, 0);
        state=0;
        pos.y=15;
        rope.speed=4;
      }
    }
  }

  void show() {
    shake();  //  swing
    extend();  // scaling
    pushMatrix();  
    translate(width/2-5, 80);
    rotate(angle);
    noStroke();
    beginShape(QUADS);
    texture(object3);  // The rope stickers
    vertex(-3, 0, 0, 0);
    vertex(3, 0, object3.width, 0);
    vertex(3, pos.y, object3.width, object3.height);
    vertex(-3, pos.y, 0, object3.height);
    endShape();
    image(object2, 0, pos.y, 20, 20);  // hook
    popMatrix();
  }
}
