PGraphics canvas;
PGraphics auxCanvas;
float fadeSpeed = 2.0;
Chain chain;
float startX;
float startY;
float osc = 0.0;
float oscSpeed = 0.005;
boolean isPaused = false;
boolean chainIsActive = true;
 
void setup()
{
  size(940, 540);
  canvas = createGraphics(width, height);
  auxCanvas = createGraphics(width, height);
  startX = random(width);
  startY = random(height);
  chain = new Chain();
 
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();
  auxCanvas.beginDraw();
  auxCanvas.background(0);
  auxCanvas.endDraw();
  canvas.colorMode(HSB, 255);
  auxCanvas.colorMode(HSB, 255);
  colorMode(HSB, 255);
 
  smooth();
  canvas.smooth();
  auxCanvas.smooth();
}
 
void draw() 
{
  if (!isPaused)
  {
    osc += oscSpeed;
    float ratio = sin(osc);
    float invRatio = cos(osc);
    float offsetX = cos(osc) * 0.1;
    float offsetY = sin(osc) * 0.1;
 
    canvas.beginDraw();
    canvas.image(auxCanvas, 0, 0, width, height);
    if (chainIsActive) chain.update();
    canvas.endDraw();
    image(canvas, 0, 0);
    auxCanvas.beginDraw();
    auxCanvas.image(canvas, -fadeSpeed*0.5, -fadeSpeed*0.5, width+fadeSpeed, height+fadeSpeed);
    auxCanvas.endDraw();
  }
}
 
 
void keyPressed()
{
  if (key == 'p') isPaused = !isPaused;
  if (key == 'c') chainIsActive = !chainIsActive;
}
 
class Chain
{
  int numParts = 500;
  Part[] parts;
  float hue = random(TWO_PI);
  float saturation = 125;
  float brightness = 125;
  float osc = random(TWO_PI);
  float x, y, vx, vy;
 
  Chain()
  {
    x = startX;
    y = startY;
    vx = 0;
    vy = 0;
    createParts();
  }
 
  void update()
  {
    canvas.noFill();
    updateHue();
 
    if (mouseX == pmouseX && mouseY == pmouseY)
    {
      vx += random(-1.0, 1.0) * 1.0;
      vy += random(-1.0, 1.0) * 1.0;
 
      vx *= 0.99;
      vy *= 0.99;
    }
    else
    {
      vx += (mouseX - x) * 0.01;
      vy += (mouseY - y) * 0.01;
 
      vx *= 0.9;
      vy *= 0.9;
    }
 
    x += vx;
    y += vy;
 
    if (x > width)
    { 
      x = width;
      vx *= -1;
    }
    if (x < 0)
    { 
      x = 0;
      vx *= -1;
    }
    if (y > height) 
    { 
      y = height;
      vy *= -1;
    }
    if (y < 0) 
    { 
      y = 0;
      vy *= -1;
    }
 
    updateParts();
  }
 
  void updateParts()
  {
    for (int i=0; i<numParts; i++)
    {
      parts[i].update();
    }
  }
 
  void createParts()
  {
    parts = new Part[numParts];
 
    for (int i=0; i<numParts; i++)
    {
      Part part = new Part();
      if (i > 0) part.leader = parts[i-1];
      part.hueOffset = i * (255/6/numParts);
      parts[i] = part;
    }
  }
 
  void updateHue()
  {
    osc += 0.003;
    hue += 0.1;
    hue = hue % 255;
    saturation = (sin(osc)/2 + 0.5) * 255;
    brightness = (sin(osc*0.3)/2 + 0.5) * 255;
  }
}
 
class Part
{
  float x, y, vx, vy;
  Part leader = null;
  float spring = 0.2;
  float friction = 0.56;
  float hueOffset = 0.0;
  float hue = 0.0;
 
  Part()
  {
    x = startX;
    y = startY;
    vx = 0.0;
    vy = 0.0;
  }
 
  void update()
  {
    if (leader == null)
    {
      vx += (chain.x - x) * spring;
      vy += (chain.y - y) * spring;
    }
    else
    {
      vx += (leader.x - x) * spring;
      vy += (leader.y - y) * spring;
    }
 
    vx *= friction;
    vy *= friction;
 
    x += vx;
    y += vy;
 
    if (leader != null)
    {
      hue = (chain.hue + hueOffset) % 255;
      canvas.stroke(hue, chain.saturation, chain.brightness, 255);
      canvas.line(x, y, leader.x, leader.y);
    }
  }
}
