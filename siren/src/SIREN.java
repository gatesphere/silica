// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIREN.java

import processing.core.*;
import org.jfugue.*;
import java.awt.*;
import java.awt.event.*;

public class SIREN extends Frame implements ComponentListener, ActionListener {
  // Graphics (processing) area
  public SIRENPApplet siren_app;
  
  // JFugue (MIDI) stuff
  public Player player;
  public Pattern pattern = new Pattern("");
  
  // Controls
  public Button pause_play;
  public Button stop;
  
  // File watcher
  public SIRENFileDaemon siren_file_daemon;
  
  // Translator
  public SIRENTranslator siren_translator;
  
  public SIREN() {
    super("siren - the silica rendering engine");
    
    addComponentListener(this);
    
    setLayout(new BorderLayout());
    
    siren_app = new SIRENPApplet();
    
    Panel control_panel = new Panel();
    pause_play = new Button("Pause");
    pause_play.setEnabled(false);
    pause_play.setActionCommand("Pause");
    stop = new Button("Stop");
    stop.setEnabled(false);
    stop.setActionCommand("Stop");
    
    control_panel.add(pause_play);
    control_panel.add(stop);
    
    
    add(siren_app, BorderLayout.CENTER);
    add(control_panel, BorderLayout.SOUTH);
    setResizable(true);
    setSize(500,500);
    
    addWindowListener(new WindowAdapter(){
      public void windowClosing(WindowEvent we){
        ((SIREN)we.getWindow()).player.close();
        ((SIREN)we.getWindow()).siren_file_daemon.stop();
        System.exit(0);
      }
    });    
    
    player = new Player();
    
    siren_file_daemon = SIRENFileDaemon.getInstance(this);
    siren_file_daemon.run();
    
    siren_translator = SIRENTranslator.getInstance();
    
    siren_app.init();
  }
  
  public void sendUpdateEvent() {
    siren_app.sendUpdateEvent();
  }
  
  public static void main(String[] args) {
    SIREN siren = new SIREN();
    siren.setLocationRelativeTo(null);
    siren.setVisible(true);
    
    
    //for(;;) {
    //  try{Thread.sleep(500);} catch(Exception ex) {}
    //  siren.sendUpdateEvent();
    //}
    
    //Player player = new Player();
    //player.play(new Pattern("C D E D C"));
  }
  
  public void found(String foundString) {
    String str = siren_translator.getMusicString(foundString);
    pattern = new Pattern(str);
    player.play(pattern);
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
    ((SIREN)e.getComponent()).sendUpdateEvent();
  }
  public void componentShown(ComponentEvent e) {}
}
