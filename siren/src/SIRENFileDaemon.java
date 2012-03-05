// silica project
// sire - the silica rendering engine
// Jacob M. Peck
// SIRENFileDaemon.java

import java.nio.file.*;
import static java.nio.file.StandardWatchEventKinds.*;
import static java.nio.file.LinkOption.*;
import java.nio.file.attribute.*;
import java.io.*;
import java.util.*;

public class SIRENFileDaemon {
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
  
  public SIRENFileDaemon(SIREN parent) {
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
              if (sc.hasNextLine()) {
                contents = sc.nextLine();
                success = true;
              }
            } while (!success);
            if(sc != null) sc.close();
            System.out.println("Contents: " + contents);
            
            // JFugue magic
            /*
            player.play(contents);
            filename = "output" + separator + 
                       filename.split(java.util.regex.Pattern.quote(separator))[1].trim() + ".midi";
            player.saveMidi(contents, new File(filename));
            System.out.println("File saved as: " + filename);
            */
            
            // reset watcher
            watchkey.reset();
          }
        }
      }
    }).start();
  }

}
