import peasy.*;

PeasyCam cam;
PShape wand;
public void settings() {
  size(800, 800, P3D);
}

public void setup() {
  cam = new PeasyCam(this, 400, 400, 0, 800);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);

  wand = loadShape("./resource/magic_wand.obj");
}

public void draw() {

  background(0);
  
  pushMatrix();
  translate(400, 600, 0);
  rotateX(PI/2);
  lights();
  shapeMode(CENTER);
  scale(100,100,100);
  shape(wand,0,0);
  translate(-100, -100, 0);
  popMatrix();

}
