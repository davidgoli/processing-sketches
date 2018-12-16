Box[] allBoxes;
int numBoxes = 100;
 
float currentHue;
float hueStep = 0.5;
float xOffset;
 
void setup()
{
  size(940, 540);
 
  colorMode(HSB, 360, 1.0, 1.0, 1.0);
  background(360);
  currentHue = random(360.0);
  allBoxes = new Box[numBoxes];
  createBoxes();
  noStroke();
 
  xOffset = 0.0;
}
 
void draw()
{
  //  background(360);
 
  //  xOffset = (mouseX - width/2) * 0.002;
  xOffset = 0;
 
  for (int i=0; i<allBoxes.length; i++)
  {
    allBoxes[i].update();
  }
}
 
void createBoxes()
{
  for (int i=0; i<numBoxes; i++)
  {
    Box box = new Box();
    allBoxes[i] = box;
  }
}
 
float getNewHue()
{
  currentHue += hueStep;
  if (currentHue >= 360.0) currentHue = 0.0;
  return currentHue;
}
 
class Box
{
  float x, y, ww, hh;
  float h, s, v;
  float speed;
  float size = 400;
 
  Box()
  {
    reset();
    y = random(height);
  }
 
  void update()
  {
    y -= speed;
    x -= (xOffset*v);
    fill(h, s, v, 0.05);
    rect(x, y, ww, hh);
 
    wrap();
  }
 
  void wrap()
  {
    if (y+hh < 0)
    {
      reset();
    }
 
    if (x > width)
    {
      x = 0-ww;
    }
 
    if (x < 0-ww)
    {
      x = width;
    }
  }
 
  void reset()
  {    
    x = random(width+size)-size/2;
    y = height;
    ww = random(size);
    hh = random(size);
    h = getNewHue();
    s = random(1.0);
    v = random(1.0);
    speed = random(0.2, 1.0);
  }
}
