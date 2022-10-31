/**
 * Koch Curve
 * by Daniel Shiffman.
 * 
 * Renders a simple fractal, the Koch snowflake. 
 * Each recursive level is drawn in sequence. 
 */
 

KochFractal k;

void setup() {
  size(640, 360);
  frameRate(1);
  k = new KochFractal();
}

void draw() {
  background(0);
  k.render();
  k.nextLevel();
  if (k.getCount() > 5) {
    k.restart();
  }
}
