float cellSize = 50;
Node[] nodes;
int xRes, yRes;
 
float currentHue = 0.0;
 
void setup()
{
  size(940, 540);
  colorMode(HSB, 100);
  background(0);
  ellipseMode(CENTER);
  rectMode(CENTER);
  createNodes();
}
 
void draw()
{
  background(0);
  currentHue += 0.01;
  currentHue = currentHue%100;
  updateNodes();
}
 
void createNodes()
{
  xRes = ceil(width/cellSize) + 2;
  yRes = ceil(height/cellSize) + 2;
  nodes = new Node[(xRes)*(yRes)];
 
  for (int i=0; i<yRes; i++)
  {
    for (int j=0; j<xRes; j++)
    {
      float cx = j*cellSize + cellSize/2;
      float cy = i*cellSize + cellSize/2;
      cx -= cellSize;
      cy -= cellSize;
      Node node = new Node(cx, cy);
      nodes[i*xRes+j] = node;
    }
  }
}
 
void updateNodes()
{
  float noiseScale = 0.01;
  for (int i=0; i<yRes; i++)
  {
    for (int j=0; j<xRes; j++)
    {
      Node node = nodes[i*xRes+j];
      node.setEnergy(noise(i*noiseScale, j*noiseScale, frameCount*0.0008));
      node.update();
    }
  }
}
 
class Node
{
  float x, y, energy, ve;
  float size = 300;
  float rotation;
 
  Node(float _x, float _y)
  {
    x = _x;
    y = _y;
    energy = 0.5;
    ve = 0.0;
    rotation = PI / 4;
  }
 
  void update()
  {
    float edgeSoftness = 50;
    noStroke();
    fill(energy*400%100, 100, 100, 30);
    pushMatrix();
    translate(x, y);
    rotate(energy*TWO_PI*4);
    rect(0, 0, cellSize*2, cellSize*2);
    popMatrix();
  }
 
  void setEnergy(float e)
  {
    float de = e - energy;
    ve += de * 0.001;
    ve *= 0.95;
    energy += ve;
  }
}
