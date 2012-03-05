// silica project
// sire - the silica rendering engine
// Jacob M. Peck
// SIRE.java

import processing.core.*;
import org.jfugue.*;
import java.awt.*;
import java.awt.event.*;

public class SIRE extends Frame implements ComponentListener, ActionListener {
  // Graphics (processing) area
  public SIREPApplet sire_app;
  
  // JFugue (MIDI) stuff
  public Player player;
  public Pattern pattern = new Pattern("");
  
  // Controls
  public Button pause_play;
  public Button stop;
  
  // File watcher
  public SIREFileDaemon sire_file_daemon;
  
  public SIRE() {
    super("sire - the silica rendering engine");
    
    addComponentListener(this);
    
    setLayout(new BorderLayout());
    
    sire_app = new SIREPApplet();
    
    Panel control_panel = new Panel();
    pause_play = new Button("Pause");
    pause_play.setEnabled(false);
    pause_play.setActionCommand("Pause");
    stop = new Button("Stop");
    stop.setEnabled(false);
    stop.setActionCommand("Stop");
    
    control_panel.add(pause_play);
    control_panel.add(stop);
    
    
    add(sire_app, BorderLayout.CENTER);
    add(control_panel, BorderLayout.SOUTH);
    setResizable(true);
    setSize(500,500);
    
    addWindowListener(new WindowAdapter(){
      public void windowClosing(WindowEvent we){
        ((SIRE)we.getWindow()).player.close();
        ((SIRE)we.getWindow()).sire_file_daemon.stop();
        System.exit(0);
      }
    });    
    
    player = new Player();
    
    sire_file_daemon = new SIREFileDaemon(this);
    sire_file_daemon.run();
    
    sire_app.init();
  }
  
  public void sendUpdateEvent() {
    sire_app.sendUpdateEvent();
  }
  
  public static void main(String[] args) {
    SIRE sire = new SIRE();
    sire.setLocationRelativeTo(null);
    sire.setVisible(true);
    
    
    //for(;;) {
    //  try{Thread.sleep(500);} catch(Exception ex) {}
    //  sire.sendUpdateEvent();
    //}
    
    //Player player = new Player();
    //player.play(new Pattern("C D E D C"));
  }
  
  
  
  // action listener
  public void actionPerformed(ActionEvent ae) {
    String s = ae.getActionCommand(); 
    if (s.equals("Pause")) { 
      this.player.pause();
    } 
    else if (s.equals("Resume")) { 
      this.player.resume(); 
    } 
    else if (s.equals("Stop")) { 
      this.player.stop();
    }
  } 
  
  
  // component listener
  public void componentHidden(ComponentEvent e) {}
  public void componentMoved(ComponentEvent e) {}
  public void componentResized(ComponentEvent e) {
    ((SIRE)e.getComponent()).sendUpdateEvent();
  }
  public void componentShown(ComponentEvent e) {}
}
