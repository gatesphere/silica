// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIRENTranslator.java
  
import org.jfugue.*; 
import java.util.*; 
  
public class SIRENTranslator {
  private static SIRENTranslator instance = null;
  
  private SIRENTranslator() {}
  
  public static SIRENTranslator getInstance() {
    if(instance == null) instance = new SIRENTranslator();
    return instance;
  }
  
  public float getLengthOfVoice(String voice) {
    Scanner sc = new Scanner(voice);
    float currentLength = 0;
    while(sc.hasNext()) {
      String token = sc.next();
      if(token.startsWith("X") || token.startsWith("V") || 
         token.startsWith("T") || token.startsWith("I") ||
         token.startsWith("L")) {
        continue;
      } else { // note
        float length = Float.parseFloat(token.substring(token.indexOf("/") + 1));
        currentLength += length;
      }
    }
    return currentLength;
  }
  
  public String getMusicString(String siren_string) {
    String[][] voices = new String[16][16];
    for(int i = 0; i < 16; i++) {
      for(int j = 0; j < 16; j++) {
        voices[i][j] = "V" + i + " L" + j + " R/0.25";
      }
    }
    
    Scanner sc = new Scanner(siren_string);
    int currentRegister = 5;
    int currentVoice = 0;
    int currentLayer = 0;
    float currentTime = 0.25f;
    boolean concurrent = false;
    String tempo = "T120";
    
    while(sc.hasNext()) {
      String token = sc.next();
      if(token.startsWith("!")) {
        // tempo
        String temp = token.substring(1);
        tempo = "T" + temp;
        continue;
      } else if(token.startsWith("@")) {
        // instrument
        String inst = token.substring(1);
        voices[currentVoice][currentLayer] = voices[currentVoice][currentLayer] + " I[" + inst + "]";
        continue;
      } else if(token.startsWith("$")) {
        // volume
        String vol = token.substring(1);
        voices[currentVoice][currentLayer] = voices[currentVoice][currentLayer] + " X[Volume]=" + vol;
        continue;
      } else if(token.startsWith("{") || token.startsWith("}")) {
        // command grouping
        continue;
      } else if(token.startsWith("[")) {
        concurrent = true;
        continue;
      } else if(token.startsWith("||")) {
        // push voice
        currentVoice++;
        if(currentVoice == 9) currentVoice = 10;
        if(currentVoice == 16) {
          currentVoice = 0;
          currentLayer++;
          if(currentLayer == 16) currentLayer = 15;
        }
        /*
        currentLayer++;
        if(currentLayer == 16) {
          currentLayer = 0;
          currentVoice++;
          if(currentVoice == 9) currentVoice = 10;
          if(currentVoice > 15) currentVoice = 15;
        }
        */
        float length = getLengthOfVoice(voices[currentVoice][currentLayer]);
        if(length < currentTime) {
          float delta = currentTime - length;
          //System.out.println("voice: " + currentVoice + " delta: " + delta);
          voices[currentVoice][currentLayer] = voices[currentVoice][currentLayer] + " R/" + delta;
        }
        continue;
      } else if(token.startsWith("]")) {
        // pop voice
        currentVoice = 0;
        currentLayer = 0;
        concurrent = false;
        continue;
      } else {
        // a note
        token = token.replace("V", "C#");
        token = token.replace("W", "D#");
        token = token.replace("X", "F#");
        token = token.replace("Y", "G#");
        token = token.replace("Z", "A#");
        
        voices[currentVoice][currentLayer] = voices[currentVoice][currentLayer] + " " + token;
        if(currentVoice == 0 && !concurrent) currentTime = getLengthOfVoice(voices[currentVoice][currentLayer]);
        continue;
      }
    }
    
    boolean hasLength = false;
    
    A: for(int i = 0; i < 16; i++) {
      for(int j = 0; j < 16; j++) {
        if(getLengthOfVoice(voices[i][j]) > 0.25f) {
          hasLength = true;
          break A;
        }
      }
    }
    
    if(hasLength) {    
      String music_string = tempo + "\n";
      for(int i = 0; i < 16; i++) {
        for(int j = 0; j < 16; j++) {
          music_string = music_string + " " + voices[i][j] + " R/0.25\n";
        }
      }
      System.out.println(music_string);
      return music_string.trim();
    } else return null;
  }
}
