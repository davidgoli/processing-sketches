PImage juliaImg;
PImage cloudImg;

void setup() {
  size(1200, 900);
  juliaImg = createImage(width, height, ARGB);
  cloudImg = createImage(width, height, ARGB);
  frameRate(20);
}

//float cX = -0.7;
//float cY = 0.27015;
float cX = -1;
float cY = 0.0001;
float zx, zy;
float maxIter = 100;

void draw() {
  println("Mouse: " + mouseX + "," + mouseY);
  background(0);
  //loadPixels();
  PImage j = julia();
  PImage c = clouds();

  image(j, 0, 0);
  //blur();
  blend(c, 0, 0, width, height, 0, 0, width, height, MULTIPLY);
  updatePixels();

}

PImage julia() {
  PImage img = juliaImg;
  img.loadPixels();

  cX = -0.7 + 0.1 * sin(mouseX * 0.005);
  cY = 0.35 + 0.01 * sin(mouseY * 0.001);

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      zx = 1.5 * (x - width / 2) / (0.5 * width);
      zy = (y - height / 2) / (0.5 * height);
      float i = maxIter;
      while (zx * zx + zy * zy < 4 && i > 0) {
        float tmp = zx * zx - zy * zy + cX;
        zy = 2.0 * zx * zy + cY;
        zx = tmp;
        i -= 1;
      }
      color c = hsv2rgb((100 + ((i / maxIter) * 360)) % 360, 0.5, i > 1 ? 1 : 0);
      img.set(x, y, c);
    }
  }
  
  img.updatePixels();
  return img;
}

color hsv2rgb(float h, float s, float v) {
  float c = v * s;
  float x = c * (1 - abs(((h/60) % 2) - 1));
  float m = v - c;

  float r, g, b;
  if (h < 60) {
    r = c;
    g = x;
    b = 0;
  } else if (h < 120) {
    r = x;
    g = c;
    b = 0;
  } else if (h < 180) {
    r = 0;
    g = c;
    b = x;
  } else if (h < 240) {
    r = 0;
    g = x;
    b = c;
  } else if (h < 300) {
    r = x;
    g = 0;
    b = c;
  } else {
    r = c;
    g = 0;
    b = x;
  }

  int ri = round((r + m) * 255);
  int gi = round((g + m) * 255);
  int bi = round((b + m) * 255);

  return color(ri, gi, bi);
}

float v = 4.0 / 9.0;
float[][] kernel = {{ v, v, v }, 
                    { v, v, v }, 
                    { v, v, v }};


void blur() {
  loadPixels();

  // Create an opaque image of the same size as the original
  PImage edgeImg = createImage(width, height, ARGB);

  // Loop through every pixel in the image
  for (int y = 1; y < height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < width-1; x++) {  // Skip left and right edges
      float sum = 0; // Kernel sum for this pixel
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*width + (x + kx);
          // Image is grayscale, red/green/blue are identical
          float val = red(pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+1][kx+1] * val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      edgeImg.pixels[y*width + x] = color(sum);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();

  image(edgeImg, 0, 0); // Draw the new image
}

float xstart = 0.0;
float ystart = 0.0;

PImage clouds() {
  PImage img = cloudImg;
  img.loadPixels();

  float xoff = xstart;
  for (int x = 0; x < width; x++) {
    float yoff = ystart;

    for (int y = 0; y < height; y++) {
      float bright = map(noise(xoff, yoff), 0, 1, 0, 255);
      img.pixels[x+y*width] = color(bright, bright);
      yoff += 0.01;
    }
    xoff += 0.01;
  }

  xstart += 0.01;
  ystart += 0.01;
  img.updatePixels();
  return img;
}
