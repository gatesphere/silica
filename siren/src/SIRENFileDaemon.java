// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIRENFileDaemon.java

import java.nio.file.*;
import static java.nio.file.StandardWatchEventKinds.*;
import static java.nio.file.LinkOption.*;
import java.nio.file.attribute.*;
import java.io.*;
import java.util.*;

public class SIRENFileDaemon {
  private static SIRENFileDaemon instance = null;
  private static WatchService watcher;
  private static WatchKey watchkey;
  private static String separator = System.getProperty("file.separator");
  private SIREN parent;
  public Path indir = Paths.get("siren_in");
  public Path outdir = Paths.get("siren_out");
  public Path mididir = Paths.get("midi");
  private boolean running = true;
  
  @SuppressWarnings("unchecked")
  static <T> WatchEvent<T> castEvent(WatchEvent<?> event) {
    return (WatchEvent<T>)event;
  }
  
  public static SIRENFileDaemon getInstance(SIREN parent) {
    if(instance == null) instance = new SIRENFileDaemon(parent);
    else instance.parent = parent;
    return instance;
  }
  
  private SIRENFileDaemon(SIREN parent) {
    this.parent = parent;
    if(!indir.toFile().exists()) {
      indir.toFile().mkdirs();
    }
    if(!outdir.toFile().exists()) {
      outdir.toFile().mkdirs();
    }
    if(!mididir.toFile().exists()) {
      mididir.toFile().mkdirs();
    }
    try {
      watcher = FileSystems.getDefault().newWatchService();
      watchkey = indir.register(watcher, ENTRY_CREATE);
    } catch (IOException ex) {
      System.out.println("Couldn't initialize SIREFileDaemon: ");
      ex.printStackTrace();
    }
  }
  
  public void stop() {
    running = false;
  }
  
  public void run() {
    new Thread(new Runnable() {
      public void run() {
        while(running) {
          try {
            watchkey = watcher.take();
          } catch (InterruptedException ex) {
            ex.printStackTrace();
          }
          for (WatchEvent<?> event: watchkey.pollEvents()) {
            WatchEvent<Path> watchEvent = castEvent(event);
            // events here
            String filename = indir.resolve(watchEvent.context()).toString();
            System.out.println("Filename: " + filename);
            
            // get contents
            boolean success = false;
            String contents = "";
            Scanner sc = null;
            do {
              try {
                sc = new Scanner(new File(filename));
              } catch (FileNotFoundException ex) {
                continue; // try again.
              }
              //sc.reset(); // prevent crash (weird Java 1.7.0-ea bug?)
              while (sc.hasNext()) {
                contents = contents + " " + sc.next();
                success = true;
              }
            } while (!success);
            if(sc != null) sc.close();
            
            sc = new Scanner(contents);
            //System.out.println(contents);
            String modeLine = sc.next();
            String rest = "";
            while(sc.hasNext()) {
              //System.out.println("building rest...");
              rest = rest + " " + sc.next();
            }
            //System.out.println(rest);
            
            if(modeLine.equalsIgnoreCase("render-sonic"))            
              parent.renderSonic(rest);
            else if(modeLine.equalsIgnoreCase("render-midi"))
              parent.renderMidi(rest);
            else if(modeLine.equalsIgnoreCase("render-graphics"))
              parent.renderGraphics(rest);
            
            //ignore anything that isn't one of those three modes
            
            // reset watcher
            watchkey.reset();
          }
        }
      }
    }).start();
  }

}
