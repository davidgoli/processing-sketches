float cellSize = 15;
Node[] nodes;
int xRes, yRes;

boolean showsFPS = false;
PFont font;

float lineSize = 10;
float perlinRes;
float mx, my;

void setup()
{
  size(940, 540);
  colorMode(HSB, 100);
  background(0);
  font = createFont("Helvetica", 24);
  createNodes();
}

void draw()
{
  background(0);
  noFill();
  stroke(100, 20);

  mx = mouseX;
  my = mouseY;
  
  if (mx == 0) mx = width/2;
  if (my == 0) my = height/2;

  lineSize = mx + 20;
  perlinRes = my/100000 + 0.003;
  
  updateNodes();
  
  if (showsFPS) displayFPS();
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
  float noiseScale = 0.0053;
  noiseScale = perlinRes;
  float noiseSpeed = 0.001;
  float a;
  PVector vector;

  for (int i=0; i<yRes; i++)
  {
    for (int j=0; j<xRes; j++)
    {
      Node node = nodes[i*xRes+j];
      //      node.setEnergy(noise(i*noiseScale, j*noiseScale, frameCount*0.0008));

      a = noise(i*noiseScale, j*noiseScale, frameCount*noiseSpeed)*TWO_PI*4;
      vector = new PVector(cos(a), sin(a));
      node.vector = vector;

      node.update();
    }
  }
}

void displayFPS()
{
  textFont(font, 18);
  fill(100);
  String output = "fps=";
  output += (int) frameRate;
  text(output, 10, 30);
}

void keyPressed()
{
  if (key == 'f') showsFPS = !showsFPS;
}

class Keys
{
  Keys()
  {
  }

  void update()
  {
  }

  void keyPressed()
  {
    println("keyPressed");
  }

  void keyReleased()
  {
    println("keyReleased");
  }
}

class Node
{
  float x, y, vx, vy;
  PVector vector;
  
  Node(float _x, float _y)
  {
    x = _x;
    y = _y;
    vx = 0.0;
    vy = 0.0;
  }

  void update()
  {
    vector.mult(lineSize);
    
//    beginShape();
//    stroke(0);
//    vertex(x, y);
//    stroke(100);
//    vertex(x+vector.x, y+vector.y);
//    endShape();
    
    line(x, y, x+vector.x, y+vector.y);
  }

}
