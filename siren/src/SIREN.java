// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIREN.java

import processing.core.*;
import org.jfugue.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.filechooser.*;
import java.io.*;

public class SIREN extends JFrame implements ComponentListener, ActionListener, WindowListener {
  // Graphics (processing) area
  public SIRENPApplet siren_app;
  public SIRENProgressBar siren_progress_bar;
  
  // JFugue (MIDI) stuff
  public Player player;
  public Pattern pattern = new Pattern("");
  
  // Controls
  public JButton pause;
  public JButton play;
  public JButton stop;
  public JButton save_as_midi;
  public JButton render_graphics;
  public JButton exit;
  public JButton about;
  public JPanel control_panel;
  public JPanel progress_and_controls;
  
  public ImageIcon pause_icon;
  public ImageIcon play_icon;
  public ImageIcon stop_icon;
  public ImageIcon save_icon;
  public ImageIcon graphics_icon;
  public ImageIcon exit_icon;
  public ImageIcon about_icon;
   
  public boolean buttons_enabled = false;
  //public boolean statechanged = false;
  
  // File watcher
  public SIRENFileDaemon siren_file_daemon;
  
  // Translator
  public SIRENTranslator siren_translator;
  
  public SIREN() {
    super("siren - the silica rendering engine");
    
    // load icons
    pause_icon = new ImageIcon("data/pause.png");
    play_icon = new ImageIcon("data/play.png");
    stop_icon = new ImageIcon("data/stop.png");
    save_icon = new ImageIcon("data/save.png");
    graphics_icon = new ImageIcon("data/graphics.png");
    exit_icon = new ImageIcon("data/exit.png");
    about_icon = new ImageIcon("data/about.png");

    addComponentListener(this);
    
    setLayout(new BorderLayout());
    
    siren_app = new SIRENPApplet();
    siren_progress_bar = new SIRENProgressBar();
    
    control_panel = new JPanel();
    
    play = new JButton(play_icon);
    play.setEnabled(false);
    play.setActionCommand("Play");
    play.setToolTipText("Play");
    play.addActionListener(this);
    
    pause = new JButton(pause_icon);
    pause.setEnabled(false);
    pause.setActionCommand("Pause");
    pause.setToolTipText("Pause");
    pause.addActionListener(this);
    
    stop = new JButton(stop_icon);
    stop.setEnabled(false);
    stop.setActionCommand("Stop");
    stop.setToolTipText("Stop");
    stop.addActionListener(this);
    
    save_as_midi = new JButton(save_icon);
    save_as_midi.setEnabled(false);
    save_as_midi.setActionCommand("MIDI");
    save_as_midi.setToolTipText("Save as MIDI file");
    save_as_midi.addActionListener(this);
    
    render_graphics = new JButton(graphics_icon);
    render_graphics.setEnabled(false);
    render_graphics.setActionCommand("Graphics");
    render_graphics.setToolTipText("Render graphical output");
    render_graphics.addActionListener(this);
    
    exit = new JButton(exit_icon);
    exit.setEnabled(true);
    exit.setActionCommand("Exit");
    exit.setToolTipText("Exit siren");
    exit.addActionListener(this);
    
    about = new JButton(about_icon);
    about.setEnabled(true);
    about.setActionCommand("About");
    about.setToolTipText("About siren and silica");
    about.addActionListener(this);
    
    control_panel.add(play);
    control_panel.add(pause);
    control_panel.add(stop);
    control_panel.add(save_as_midi);
    control_panel.add(render_graphics);
    control_panel.add(about);
    control_panel.add(exit);
    
    progress_and_controls = new JPanel(new BorderLayout());
    progress_and_controls.add(control_panel, BorderLayout.SOUTH);
    progress_and_controls.add(siren_progress_bar, BorderLayout.CENTER);
    
    
    add(siren_app, BorderLayout.CENTER);
    add(progress_and_controls, BorderLayout.SOUTH);
    setResizable(true);
    setSize(650,650);
    
    addWindowListener(this);
    
    player = new Player();
    
    siren_file_daemon = SIRENFileDaemon.getInstance(this);
    siren_file_daemon.run();
    
    siren_translator = SIRENTranslator.getInstance();
    
    siren_app.init();
    siren_progress_bar.init();
    watchProgressBar();
  }
  
  public void sendUpdateEvent() {
    this.updateButtons();
    siren_progress_bar.redraw();
    siren_app.sendUpdateEvent();
  }
  
  public static void main(String[] args) {
    try {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } catch (Exception ex) {}
    
    SwingUtilities.invokeLater(new Runnable() {
      public void run() {
        createAndShowGUI();
      }
    });
  }
  
  public static void createAndShowGUI() {
    SIREN siren = new SIREN();
    siren.setLocationRelativeTo(null);
    siren.setVisible(true);
    //siren.watchButtons();
    siren.sendUpdateEvent();
  }
  
  public void updateButtons() { updateButtons(false); }
  public void updateButtons(boolean replay) {
    //System.out.println("Updating buttons. " + replay);
    if(player.isPlaying() || replay) {
      pause.setEnabled(true);
      play.setEnabled(false);
      stop.setEnabled(true);
    } else if(player.isPaused()) {
      pause.setEnabled(false);
      play.setEnabled(true);
      stop.setEnabled(false);
    } else {
      if(buttons_enabled) {
        play.setEnabled(true);
        pause.setEnabled(false);
        stop.setEnabled(false);
      } else {
        play.setEnabled(false);
        pause.setEnabled(false);
        stop.setEnabled(false);
      }
    }
  }
  
  public void enableButtons() {
    if(!buttons_enabled) {
      pause.setEnabled(true);
      stop.setEnabled(true);
      save_as_midi.setEnabled(true);
      //render_graphics.setEnabled(true); // not yet available
      buttons_enabled = true;
      //statechanged = true;
    }
  }
  
  public void watchProgressBar() {
    final SIREN siren = this;
    new Thread(new Runnable() {
      public void run() {
        for(;;) {
          if(siren.player.isPlaying())
            siren.siren_progress_bar.setValue(siren.player.getSequencePosition() / 1000);
          else if(!siren.player.isPaused())
            if(siren.siren_progress_bar.getValue() != siren.siren_progress_bar.getMaxValue())
              siren.siren_progress_bar.setValue(siren.siren_progress_bar.getMaxValue());
          try{Thread.sleep(100);} catch (Exception ex) {ex.printStackTrace();}
        }
      }
    }).start();
  }
  
  public void renderSonic(String sonicString) {
    //System.out.println("Rendering sonically.");
    //statechanged = true;
    String str = siren_translator.getMusicString(sonicString);
    if(str == null) return;
    pattern = new Pattern(str);
    if(!buttons_enabled) enableButtons();
    siren_progress_bar.setMaxValue(player.getSequenceLength(player.getSequence(pattern)) / 1000);
    playInThread();
  }
  
  public void playInThread() {
    final Player player1 = this.player;
    final Pattern pattern1 = this.pattern;
    final SIREN siren = this;
    new Thread(new Runnable() {
      public void run() {
        player1.play(pattern1);
        siren.updateButtons();
      }
    }).start();
  }
  
  public void renderMidi(String midiString) {
    String str = siren_translator.getMusicString(midiString);
    if(str == null) return;
    pattern = new Pattern(str);
    if(!buttons_enabled) enableButtons();
    saveMidi();
  }
  
  public void saveMidi() {
    try {
      JFileChooser save = new JFileChooser();
      FileNameExtensionFilter filter = new FileNameExtensionFilter("MIDI files", "mid", "midi");
      save.setFileFilter(filter);
      File saveFile;
      save.setCurrentDirectory(new File(this.siren_file_daemon.mididir.toString()));
      int retval = save.showSaveDialog(this);
      if(retval == JFileChooser.APPROVE_OPTION) {
        saveFile = save.getSelectedFile();
        player.saveMidi(pattern, saveFile);
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }
  
  public void renderGraphics(String graphicString) {
    // blah
    //statechanged = true;
    String str = siren_translator.getMusicString(graphicString);
    if(str == null) return;
    pattern = new Pattern(str);
    if(!buttons_enabled) enableButtons();
    renderGraphicsHelper();
  }
  
  public void renderGraphicsHelper() {
    String str = pattern.getMusicString();
    // blah...
  }
  
  public void aboutDialog() {
    final JDialog d = new JDialog(this, "About siren", true);
    d.setLayout(new BorderLayout());
    JPanel infoPanel = new JPanel(new BorderLayout());
    JPanel controls = new JPanel();
    infoPanel.add(new JLabel("siren - the silica rendering engine", JLabel.CENTER), BorderLayout.NORTH);
    infoPanel.add(new JLabel("2012 Jacob Peck", JLabel.CENTER), BorderLayout.CENTER);
    infoPanel.add(new SIRENURLLabel("http://silica.suspended-chord.info", "http://silica.suspended-chord.info", JLabel.CENTER), BorderLayout.SOUTH);
    d.add(infoPanel, BorderLayout.CENTER);
    JButton ok = new JButton("Close");
    ok.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        d.setVisible(false);
      }
    });
    d.addWindowListener(new WindowAdapter() {
      public void windowClosing(WindowEvent e) {
        ((Dialog)e.getComponent()).setVisible(false);
      }
    });
    controls.add(ok);
    d.add(controls, BorderLayout.SOUTH);
    d.pack();
    d.setLocationRelativeTo(null);
    d.setVisible(true);
  }
  
  // action listener
  public void actionPerformed(ActionEvent ae) {
    String s = ae.getActionCommand(); 
    if (s.equals("Pause")) { 
      this.player.pause();
      this.updateButtons();
      //System.out.println("Pausing.");
    } 
    else if (s.equals("Play")) { 
      if(!this.player.isPaused()) {
        this.playInThread();
        this.updateButtons(true);
        //System.out.println("Playing.");
      }
      else {
        this.player.resume(); 
        this.updateButtons();
        //System.out.println("Resuming.");
      }
    } 
    else if (s.equals("Stop")) { 
      this.player.stop();
      this.updateButtons();
      //System.out.println("Stopping.");
    }
    else if (s.equals("MIDI")) {
      this.saveMidi();
    }
    else if (s.equals("Graphics")) {
      this.renderGraphicsHelper();
    }
    else if (s.equals("Exit")) {
      this.player.close();
      this.siren_file_daemon.stop();
      System.exit(0);
    }
    else if (s.equals("About")) {
      this.aboutDialog();
    }
  } 
  
  // component listener
  public void componentHidden(ComponentEvent e) {}
  public void componentMoved(ComponentEvent e) {}
  public void componentResized(ComponentEvent e) {
    try { Thread.sleep(100); } catch (Exception ex) {}
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
