// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIREN.java

import processing.core.*;
import org.jfugue.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

public class SIREN extends Frame implements ComponentListener, ActionListener {
  // Graphics (processing) area
  public SIRENPApplet siren_app;
  
  // JFugue (MIDI) stuff
  public Player player;
  public Pattern pattern = new Pattern("");
  
  // Controls
  public Button pause_play;
  public Button stop;
  public Button save_as_midi;
  
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
    pause_play.addActionListener(this);
    stop = new Button("Stop");
    stop.setEnabled(false);
    stop.setActionCommand("Stop");
    stop.addActionListener(this);
    save_as_midi = new Button("Save as MIDI");
    save_as_midi.setEnabled(true);
    save_as_midi.setActionCommand("MIDI");
    save_as_midi.addActionListener(this);
    
    control_panel.add(pause_play);
    control_panel.add(stop);
    control_panel.add(save_as_midi);
    
    
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
  }
  
  public void renderSonic(String sonicString) {
    //System.out.println("Rendering sonically.");
    String str = siren_translator.getMusicString(sonicString);
    pattern = new Pattern(str);
    player.play(pattern);
  }
  
  public void renderMidi(String midiString) {
    String str = siren_translator.getMusicString(midiString);
    pattern = new Pattern(str);
    saveMidi();
  }
  
  public void saveMidi() {
    try {
      FileDialog save = new FileDialog(this, "Save file as...", FileDialog.SAVE);
      File saveFile;
      save.setDirectory(this.siren_file_daemon.mididir.toString());
      save.setVisible(true);
      String filename = save.getFile();
      if(filename != null) {
        saveFile = new File(filename);
        player.saveMidi(pattern, saveFile);
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }
  
  public void renderGraphics(String graphicString) {
    // blah
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
    else if (s.equals("MIDI")) {
      this.saveMidi();
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
