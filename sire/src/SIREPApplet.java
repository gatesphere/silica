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
    fill(0, 102, 153);
    redraw();
    noLoop();
  }
  
  public void draw() {
    text("Welcome to sire.", 100, 100);
  }
  
  public void sendUpdateEvent() {
    redraw();
  }
}
