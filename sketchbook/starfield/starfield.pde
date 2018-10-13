import java.util.*;

HashSet<Star> stars = new HashSet();
int starIndex = 0;
int numStars = 0;
int acceleration = 1;
int starsToDraw = 100;

void setup() {
  size(1200, 800);
  fill(0);
  rect(0, 0, width, height);
}

class Star {
  float X;
  float Y;
  float SX;
  float SY;
  float W;
  float H;
  int age = 0;
  color C;
  boolean shouldRemove = false;

  public Star(int width, int height) {
    this.X = width / 2;
    this.Y = height / 2;

    this.SX = random(10) - 5;
    this.SY = random(10) - 5;

    int start = 0;

    if (width > height)
      start = width;
    else
      start = height;

    this.X += this.SX * start / 50;
    this.Y += this.SY * start / 50;

    this.W = 1;
    this.H = 1;

    this.C = #FFFFFF;
  }

  void draw() {
    this.X += this.SX;
    this.Y += this.SY;

    this.SX += this.SX / (100 / acceleration);
    this.SY += this.SY / (100 / acceleration);

    this.age++;

    if (this.age == Math.floor(50 / acceleration) ||
      this.age == Math.floor(150 / acceleration) ||
      this.age == Math.floor(300 / acceleration)) {
      this.W++;
      this.H++;
    }

    if (this.X + this.W < 0 || this.X > width ||
      this.Y + this.H < 0 || this.Y > height)
    {
      this.shouldRemove = true;
    }

    fill(this.C);
    rect(this.X, this.Y, this.W, this.H);
  }
}

void draw() {
  // Play with the "a" value to create streams...it's fun!
  fill(0, 0, 0, 200);
  rect(0, 0, width, height);

  for (int i = stars.size(); i < starsToDraw; i++) {
    stars.add(new Star(width, height));
  }

  for (Iterator<Star> i = stars.iterator(); i.hasNext();) {
    Star star = i.next();
    star.draw();
    if (star.shouldRemove) {
      i.remove();
    }
  }
}
