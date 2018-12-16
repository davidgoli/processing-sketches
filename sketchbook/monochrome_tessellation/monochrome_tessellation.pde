int tileCountX = 5;
int tileCountY = 5;
float tileWidth;
float tileHeight;
 
int lineCountX = 10;
int lineCountY = 10;
 
boolean doesOscilate = false;
boolean doesTrackMouse = true;
 
float lineHue = 1.0;
float lineSat = 0.0;
float lineBright = 0.0;
float bgHue = 1.0;
float bgSat = 0.0;
float bgBright = 1.0;
float lineSize = 1;
float centerOffset = 0.1;
 
boolean doesOffsetRows = true;
boolean doesInterlaceMouse = true;
 
void setup()
{
  size(940, 540);
  colorMode(HSB, 1.0, 1.0, 1.0, 1.0);
  background(1.0);
  strokeWeight(1);
}
 
void draw()
{
  background(bgHue, bgSat, bgBright);
 
  tileWidth = 940 / tileCountX;
  tileHeight = 540 / tileCountY;
 
  float HH = tileHeight/2;
  float HW = tileWidth/2;
 
  for (int gridY=0; gridY<=tileCountY; gridY++)
  {
    for (int gridX=0; gridX<=tileCountX; gridX++)
    {
      pushMatrix();
 
      float rowOffset = 0;
 
      if (doesOffsetRows)
      {
        rowOffset = gridY%2 * tileWidth/2;
      }
 
      translate(tileWidth*gridX + rowOffset, tileHeight*gridY);
 
      noFill();
      stroke(lineHue, lineSat, lineBright, 0.5);
 
      PVector center = new PVector(0, 0);
      float offsetMag = 20;
 
      float mouseOffsetX = map(mouseX, 0, width, -HW, HW);
      float mouseOffsetY = map(mouseY, 0, height, -HH, HH);
 
      if (doesInterlaceMouse)
      {
        if (rowOffset > 0)
        {
          mouseOffsetX *= - 1;
          mouseOffsetY *= -1;
        }
      }
 
      if (doesTrackMouse)
      {
        center.x += mouseOffsetX * 1;
        center.y += mouseOffsetY * 1;
      }
 
      if (doesOscilate)
      {
        center.x += sin(gridX+millis()*0.001)*offsetMag + cos(gridY+millis()*0.0015)*offsetMag;
        center.y += cos(gridX+millis()*0.0015)*offsetMag + sin(gridY+millis()*0.001)*offsetMag;
      }
 
      // draw vertical lines
      for (int i=0; i<=lineCountX; i++)
      {
        float ratioPos = (float)i / (float)lineCountX;
        float xPos = map(ratioPos, 0, 1, -HW, HW);
 
        PVector top = new PVector(xPos, HH);
        PVector bottom = new PVector(xPos, -HH);
 
        line(center.x, center.y, top.x, top.y);
        line(center.x, center.y, bottom.x, bottom.y);
      }
 
      // draw horizontal lines
      for (int i=0; i<=lineCountY; i++)
      {
        float ratioPos = (float)i / (float)lineCountY;
        float yPos = map(ratioPos, 0, 1, -HH, HH);
 
        PVector left = new PVector(-HW, yPos);
        PVector right = new PVector(HW, yPos);
 
        line(center.x, center.y, left.x, left.y);
        line(center.x, center.y, right.x, right.y);
      }
 
      popMatrix();
    }
  }
}
 
void keyPressed()
{
  if (key == 'o')
  {
    doesOscilate = !doesOscilate;
  }
 
  if (key == 'm')
  {
    doesTrackMouse = !doesTrackMouse;
  }
 
  if (key == 'c')
  {
    lineHue = random(0, 1);
    lineSat = random(0, 1);
    lineBright = random(0, 1);
    bgHue = random(0, 1);
    bgSat = random(0, 1);
    bgBright = random(0, 1);
  }
 
  if (key == 'r')
  {
    lineHue = 1.0;
    lineSat = 0.0;
    lineBright = 0.0;
    bgHue = 1.0;
    bgSat = 0.0;
    bgBright = 1.0;
  }
}
 
void mousePressed()
{
  lineCountX = (int)random(0, 7) * 2;
  lineCountY = (int)random(0, 7) * 2;
  tileCountX = (int)random(1, 10);
  tileCountY = (int)random(1, 10);
 
  doesOffsetRows = true;
  if (random(1) > 0.5) doesOffsetRows = false;
 
  doesInterlaceMouse = true;
  if (random(1) > 0.5) doesInterlaceMouse = false;
 
}
