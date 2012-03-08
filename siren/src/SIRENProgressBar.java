// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIRENProgressBar.java
  
import processing.core.*;
import org.jfugue.*;
import java.text.SimpleDateFormat;
import java.util.Date;
  
public class SIRENProgressBar extends PApplet {
  private long value = 1;
  private long maxValue = 1;
  
  public void setup() {
    size(20,20); // trick BorderLayout into sticking it in the right place
    PFont deja_vu_serif_12 = loadFont("DejaVuSerif-12.vlw");
    textFont(deja_vu_serif_12);
    noStroke();
    redraw();
    noLoop();
  }
  
  public void draw() {
    size(this.getParent().getWidth(), 20);   
    long done = getValue();
    long max = getMaxValue();
    float delta = max - (max - done);
    
    float percent = delta / (float)max;
    //System.out.println(percent);
    int done_x = (int)((float)width * percent);    
    //System.out.println(done_x);
    
    // white background
    fill(color(255));
    rect(0, 0, width, height);
    
    // blue bar
    fill(0, 102, 153);
    rect(0, 0, done_x, height);
    
    // text
    textAlign(CENTER, CENTER);
    fill(color(0));
    text(milisToTime(done) + " / " + milisToTime(max), width/2, height/2);
  }
  
  public String milisToTime(long milis) {
    String format = String.format("%%0%dd", 2);  
    milis = milis / 1000; // to seconds
    long minutes_val = milis / 60;
    long seconds_val = milis % 60;
    String seconds = String.format(format, seconds_val);  
    String minutes = String.format(format, minutes_val);   
    String time = minutes + ":" + seconds;  
    return time;  
  }
  
  public long getMaxValue() {
    return maxValue;
  }
  
  public long getValue() {
    return value;
  }
  
  public void setMaxValue(long maxValue) {
    this.maxValue = maxValue;
    redraw();
  }
  
  public void setValue(long value) {
    this.value = value;
    redraw();
  }
}
