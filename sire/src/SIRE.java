// silica project
// sire - the silica rendering engine
// Jacob M. Peck
// SIRE.java

import processing.core.*;
import org.jfugue.*;
import java.awt.*;
import java.awt.event.*;

public class SIRE extends Frame {
  public SIREPApplet sire_app;
  
  public SIRE() {
    super("sire - the silica rendering engine");
    
    setLayout(new BorderLayout());
    sire_app = new SIREPApplet();
    add(sire_app, BorderLayout.CENTER);
    setResizable(true);
    setSize(500,500);
    addWindowListener(new WindowAdapter(){
      public void windowClosing(WindowEvent we){
        System.exit(0);
      }
    });    
    
    sire_app.init();
  }
  
  public void sendUpdateEvent() {
    sire_app.sendUpdateEvent();
  }
  
  public static void main(String[] args) {
    SIRE sire = new SIRE();
    sire.setVisible(true);
    
    
    //for(;;) {
    //  try{Thread.sleep(500);} catch(Exception ex) {}
    //  sire.sendUpdateEvent();
    //}
    
    //Player player = new Player();
    //player.play(new Pattern("C D E D C"));
  }
}
