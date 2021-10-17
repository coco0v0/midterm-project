// Level management

class LevelSystem {
  int targetScore, totalScore;
  int[] nums;  // The number of various Gold items
  ArrayList<Gold> golds;

  LevelSystem(int targetScore) {
    this.targetScore=targetScore;
    nums=new int[8];
    golds=new ArrayList<Gold>();
    if (level==1) {
      totalScore=(int)(targetScore*2);  // The relationship between actual total score and target score
    } else {
      totalScore=targetScore;
    }
    initLevelStart(totalScore);
    genGolds();
  }

  // New level, generating gold and so on
  void initLevelStart(int tS) {
    tS=scoring(tS, 7, 1000);
    tS=scoring(tS, 6, 600);
    tS=scoring(tS, 5, 500);
    tS=scoring(tS, 4, 250);
    tS=scoring(tS, 3, 100);
    tS=scoring(tS, 2, 50);
    tS=scoring(tS, 1, 20);
    tS=scoring(tS, 0, 10);

    if (tS>25) {
      initLevelStart(tS);  // Start the iteration
    }
  }

  // scores
  int scoring(int tS, int i, int score) {
    int num=(int)random(0.5*(tS-tS%score)/score, (tS-tS%score)/score);
    tS-=num*score;
    nums[i]+=num;
    return tS;
  }

  void genGolds() {
    genGold(7, nums[7]);
    genGold(6, nums[6]);
    genGold(5, nums[5]);
    genGold(4, nums[4]);
    genGold(3, nums[3]);
    genGold(2, nums[2]);
    genGold(1, nums[1]);
    genGold(0, nums[0]);
  }

  // Generate Gold
  void genGold(int i, int num) {
    for (int n=0; n<num; n++) {
      golds.add(new Gold(new PVector(random(width), random(200, height)), i));
    }
  }

  // Show lots of Gold
  void show() {
    // Write them separately to prevent flash screen
    for (int i=0; i<golds.size(); i++) {
      if (dist(golds.get(i).pos.x, golds.get(i).pos.y, width/2, 95) <golds.get(i).size/2) {
        yourScore+=golds.get(i).score;
        word="+"+golds.get(i).score+"!";
        miner.setFrameSequence(0, 3, 0);
        showText=true;
        golds.remove(i);  // Eliminate the Gold
      }
    }
    showText();
    for (int i=0; i<golds.size(); i++) {
      golds.get(i).show();
    }
  }

  void showText() {
    if (showText==true) {
      image(tB5, width/2-90, 45, 120, 80);
      textSize(25);
      text(word, width/2-90, 50);
      textRate+=0.3;
    }
    if (textRate>10) {
      showText=false;
      textRate=0;
    }
  }

  // Caught the Gold
  void catchGold() {
    for (int i=0; i<golds.size(); i++) {
      float x1=golds.get(i).pos.x;
      float y1=golds.get(i).pos.y;
      float x2=width/2-5-sin(rope.angle)*rope.pos.y;
      float y2=80+cos(rope.angle)*rope.pos.y;

      if (dist(x1, y1, x2, y2)<=golds.get(i).size/2) {
        if (golds.get(i).shape!=6) {
          rope.speed=4-golds.get(i).size/30;
        } else {
          rope.speed=3.5;
        }

        if (golds.get(i).shape==0||golds.get(i).shape==1) {
          file[4].play();
        } else if (golds.get(i).shape==6) {
          file[5].play();
        } else {
          file[3].play();
        }

        if (rope.state==1) {
          miner.setFrameSequence(0, 3, 0.6-rope.speed/10);
        }
        rope.state=2;
        golds.get(i).pos.x=width/2-5-sin(rope.angle)*(rope.pos.y+golds.get(i).size/3.5);
        golds.get(i).pos.y=80+cos(rope.angle)*(rope.pos.y+golds.get(i).size/3.5);
        golds.get(i).angle=rope.angle;
        golds.get(i).speed=rope.speed;
      } else if (x2<0||x2>width||y2>height) {
        rope.speed=5;
        showText=true;
        word="lonely…";
        if (rope.state==1) {
          miner.setFrameSequence(0, 3, 0.6-rope.speed/10);
        }
        rope.state=2;
      }
    }
  }
}
