// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIREN.java

import processing.core.*;
import org.jfugue.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

public class SIREN extends Frame implements ComponentListener, ActionListener, WindowListener {
  // Graphics (processing) area
  public SIRENPApplet siren_app;
  
  // JFugue (MIDI) stuff
  public Player player;
  public Pattern pattern = new Pattern("");
  
  // Controls
  public Button pause_play;
  public Button stop;
  public Button save_as_midi;
  public Button render_graphics;
  public Panel control_panel;
  public boolean buttons_enabled = false;
  
  // File watcher
  public SIRENFileDaemon siren_file_daemon;
  
  // Translator
  public SIRENTranslator siren_translator;
  
  public SIREN() {
    super("siren - the silica rendering engine");
    
    addComponentListener(this);
    
    setLayout(new BorderLayout());
    
    siren_app = new SIRENPApplet();
    
    control_panel = new Panel();
    pause_play = new Button("Pause");
    pause_play.setEnabled(false);
    pause_play.setActionCommand("Pause");
    pause_play.addActionListener(this);
    stop = new Button("Stop");
    stop.setEnabled(false);
    stop.setActionCommand("Stop");
    stop.addActionListener(this);
    save_as_midi = new Button("Save as MIDI");
    save_as_midi.setEnabled(false);
    save_as_midi.setActionCommand("MIDI");
    save_as_midi.addActionListener(this);
    render_graphics = new Button("Render Graphics");
    render_graphics.setEnabled(false);
    render_graphics.setActionCommand("Graphics");
    render_graphics.addActionListener(this);
    
    
    control_panel.add(pause_play);
    control_panel.add(stop);
    control_panel.add(save_as_midi);
    control_panel.add(render_graphics);
    
    
    add(siren_app, BorderLayout.CENTER);
    add(control_panel, BorderLayout.SOUTH);
    setResizable(true);
    setSize(500,500);
    
    addWindowListener(this);
    
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
    siren.watchButtons();
  }
  
  public void watchButtons() {
    final SIREN siren = this;
    new Thread(new Runnable() {
      public void run() {
        for(;;) {
          if(siren.player.isPlaying()) {
            siren.pause_play.setLabel("Pause");
            siren.pause_play.setActionCommand("Pause");
            siren.stop.setEnabled(true);
            siren.control_panel.invalidate();
            siren.control_panel.validate();
          } else {
            if(!siren.player.isPaused())
              siren.pause_play.setLabel("Replay");
            else
              siren.pause_play.setLabel("Resume");
            siren.pause_play.setActionCommand("Play");
            siren.stop.setEnabled(false);
            siren.control_panel.invalidate();
            siren.control_panel.validate();
          }
        }
      }
    }).start();
  }
  
  public void enableButtons() {
    if(!buttons_enabled) {
      pause_play.setEnabled(true);
      stop.setEnabled(true);
      save_as_midi.setEnabled(true);
      render_graphics.setEnabled(true);
      buttons_enabled = true;
    }
  }
  
  public void renderSonic(String sonicString) {
    //System.out.println("Rendering sonically.");
    String str = siren_translator.getMusicString(sonicString);
    pattern = new Pattern(str);
    if(!buttons_enabled) enableButtons();
    playInThread();
  }
  
  public void playInThread() {
    final Player player1 = this.player;
    final Pattern pattern1 = this.pattern;
    new Thread(new Runnable() {
      public void run() {
        player1.play(pattern1);
      }
    }).start();
  }
  
  public void renderMidi(String midiString) {
    String str = siren_translator.getMusicString(midiString);
    pattern = new Pattern(str);
    if(!buttons_enabled) enableButtons();
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
        saveFile = new File(save.getDirectory(), filename);
        player.saveMidi(pattern, saveFile);
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }
  
  public void renderGraphics(String graphicString) {
    // blah
    String str = siren_translator.getMusicString(graphicString);
    pattern = new Pattern(str);
    if(!buttons_enabled) enableButtons();
    renderGraphicsHelper();
  }
  
  public void renderGraphicsHelper() {
    String str = pattern.getMusicString();
    // blah...
  }
  
  // action listener
  public void actionPerformed(ActionEvent ae) {
    String s = ae.getActionCommand(); 
    if (s.equals("Pause")) { 
      this.player.pause();
      //System.out.println("Pausing.");
    } 
    else if (s.equals("Play")) { 
      if(!this.player.isPaused()) {
        this.playInThread();
        //System.out.println("Playing.");
      }
      else {
        this.player.resume(); 
        //System.out.println("Resuming.");
      }
    } 
    else if (s.equals("Stop")) { 
      this.player.stop();
      //System.out.println("Stopping.");
    }
    else if (s.equals("MIDI")) {
      this.saveMidi();
    }
    else if (s.equals("Graphics")) {
      this.renderGraphicsHelper();
    }
  } 
  
  // component listener
  public void componentHidden(ComponentEvent e) {}
  public void componentMoved(ComponentEvent e) {}
  public void componentResized(ComponentEvent e) {
    ((SIREN)e.getComponent()).sendUpdateEvent();
  }
  public void componentShown(ComponentEvent e) {}
  
  // window listener
  public void windowActivated(WindowEvent e) {}
  public void windowClosed(WindowEvent e) {}
  public void windowClosing(WindowEvent e) {
    ((SIREN)e.getWindow()).player.close();
    ((SIREN)e.getWindow()).siren_file_daemon.stop();
    System.exit(0); 
  }
  public void windowDeactivated(WindowEvent e) {}
  public void windowDeiconified(WindowEvent e) {}
  public void windowIconified(WindowEvent e) {}
  public void windowOpened(WindowEvent e) {}
}
