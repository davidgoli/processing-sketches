Part part;
Gradient g;
float count = 1;
int timeStep = 0;
 
float osc = 0;
float gridMod = 1.0;
 
boolean isPaused = false;
boolean autoPlay = true;
boolean bigLine = false;
 
void setup()
{
  size(940, 540);
  colorMode(HSB);
  background(255);
  rectMode(CENTER);
  init();
}
 
void init()
{
  if (random(10) > 5) bigLine = true;
  else bigLine = false;
 
  timeStep = 0;
  gridMod = random(0.4, 1.2);
  g = new Gradient();
  background(0);
  part = new Part(0, 0);
}
 
void mousePressed()
{
  init();
}
 
void draw()
{
  if (autoPlay) if (timeStep % 2000 == 0) init();
  if (!isPaused) update();
}
 
void update()
{
  timeStep++;
 
  osc += 0.01;
  float ratio = map(sin(osc), -1, 1, 0, 1);
 
  fill(g.getColorAtRatio(ratio));
  noStroke();
 
  int count = 0;
 
  float xRes = 15*gridMod;
  float yRes = 10*gridMod;
 
  float w = width * 2.0;
  float h = height * 2.0;
 
  for (int i=-width/2; i<=w+w/10; i+=w/xRes)
  {
    count++;
    for (int j=-height/2; j<=h+h/10; j+=h/yRes)
    {
      pushMatrix();
 
      float offset = 0;
      if (count % 2 == 0) offset = h/yRes/2;
 
      translate(floor(i), floor(j+offset));
 
      drawRect(part.x, part.y);
      drawRect(-part.x, part.y);
      drawRect(part.x, -part.y);
      drawRect(-part.x, -part.y);
 
//      renderRadial(part.x, part.y);
 
      popMatrix();
    }
  }
 
  part.update();
}
 
void renderRadial(float x, float y)
{
  int numAxis = 4;
  float step = 360 / numAxis;
  step = radians(step);
 
  for (int i=0; i<numAxis; i++)
  {
    drawRect(x, y);
    rotate(step);
  }
}
 
void drawRect(float _x, float _y)
{
  float x = _x % width;
  float y = _y % height;
 
  if (bigLine) rect(x, y, 20, 1);
  else rect(x, y, 1, 1);
}
 
void keyPressed()
{
  if (key == ' ') isPaused = !isPaused;
  if (key == 's') save();
  if (key == 'a') autoPlay = !autoPlay;
  if (key == 'l') bigLine = !bigLine;
}
 
class Gradient
{
  PGraphics pg;
  float w = 300;
  color[] allColorsNew;
  color[] allColorsCurrent;
 
  int trans = w;
 
  int brightnessFloor = 0;
 
  Gradient()
  {
    allColorsNew = new color[w];
    allColorsCurrent = new color[w];
 
    createPalette();
 
    for (int i=0; i<=w; i++)
    {
      allColorsCurrent[i] = allColorsNew[i];
    }
  }
 
  void update()
  {
    for (int i=0; i<5; i++)
    {
      if (trans <= w)
      {
        allColorsCurrent[trans] = allColorsNew[trans];
      }
      trans++;
    }
  }
 
  void changeColors()
  {
    trans = 0;
//    brightnessFloor = random(255);
    createPalette();
  }
 
  void createPalette()
  {
    pg = createGraphics(w, 1);
    pg.colorMode(HSB);
    pg.beginDraw();
 
    pg.noStroke();
 
    color baseColor = color(random(255), random(255, 255), random(255, 255));
    pg.background(baseColor);
 
    int numColors = 6;
    for (int i=0; i<numColors; i++)
    {
      addColor();
    }
 
    pg.endDraw();
 
    for (int i=0; i<w; i++)
    {
      allColorsNew[i] = pg.get(i, 0);
    }
  }
 
  void addColor()
  {
    color c = color(random(255), random(0, 255), random(brightnessFloor, 255));
    float pos = random(w);
    float size = w/4;
 
    for (int i=0; i<w; i++)
    {
      float ratio = 0;
      float d = abs(i-pos);
      if (d < size)
      {
        ratio = 1.0 - (d/size);
      }
      pg.fill(hue(c), saturation(c), brightness(c), (ratio)*255);
      pg.rect(i, 0, 1, 1);
    }
  }
 
  void draw()
  {
    image(pg, 0, height/2, width, 10);
  }
 
  color getColorAtRatio(float _ratio)
  {
    int index = floor(w * _ratio);
    return allColorsCurrent[index];
  }
}
 
class Part
{
  float x;
  float y;
  float dir = 0;
  int life = 0;
  int dirSwitch = 0;
 
  Part(float _x, float _y)
  {
    x = _x;
    y = _y;
    dir = floor(random(0, 3));
    changeDirections();
  }
 
  void update()
  {
    life++;
    checkDirection();
    move();
  }
 
  void checkDirection()
  { 
    if (life % dirSwitch == 0) 
    {
      changeDirections();
    }
  }
 
  void changeDirections()
  {
    life = 0;
    dirSwitch = ceil(random(0, 4)) * 10;
 
    float trigger = random(100);
 
    switch(dir)
    {
    case 0:
    case 1:
      if (trigger > 50) dir = 2;
      else dir = 3;
      break;
 
    case 2:
    case 3:
      if (trigger > 50) dir = 0;
      else dir = 1;
      break;
    }
  }
 
  void move()
  {
    switch(dir)
    {
    case 0:
      x++;
      break;
 
    case 1:
      x--;
      break;
 
    case 2:
      y++;
      break;
 
    case 3:
      y--;
      break;
    }
  }
 
  void wrap()
  {
    if (x > width) x = 0;
    if (x < 0) x = width;
    if (y > height) y = 0;
    if (y < 0) y = height;
  }
}
