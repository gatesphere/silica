// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIRENProgressBar.java
  
import processing.core.*;
import org.jfugue.*;  
  
public class SIRENProgressBar extends PApplet {
  public void setup() {
    PFont deja_vu_serif_12 = loadFont("DejaVuSerif-12.vlw");
    textFont(deja_vu_serif_16);
    noStroke();
    redraw();
    noLoop();
  }
  
  public void draw() {
    fill(color(255));
    rect(0, 0, width, height);
        
    fill(0, 102, 153);
    
    // percent done
    // yada yada yada
    
    textAlign(CENTER, CENTER);
    fill(color(0))
    //text("X:XX / Y:YY"), width/2, height/2);
  }
  
  public void setMaxValue(int maxValue) {
    this.maxValue = maxValue;
    redraw();
  }
  
  public void setValue(int value) {
    this.value = value;
    redraw();
  }
}
