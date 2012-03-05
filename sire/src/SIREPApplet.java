// silica project
// sire - the silica rendering engine
// Jacob M. Peck
// SIREPApplet.java
  
import processing.core.*;
import org.jfugue.*;  
  
public class SIREPApplet extends PApplet {
  public void setup() {
    PFont deja_vu_serif_16 = loadFont("DejaVuSerif-16.vlw");
    textFont(deja_vu_serif_16);
    noStroke();
    redraw();
    noLoop();
  }
  
  public void draw() {
    fill(color(255));
    rect(0, 0, width, height);
    fill(0, 102, 153);
    textAlign(CENTER, CENTER);
    text("Welcome to sire.", width/2, height/2);
  }
  
  public void sendUpdateEvent() {
    redraw();
  }
}
