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
         token.startsWith("T") || token.startsWith("I")) {
        continue;
      } else { // note
        float length = Float.parseFloat(token.substring(token.indexOf("/") + 1));
        currentLength += length;
      }
    }
    return currentLength;
  }
  
  public String getMusicString(String siren_string) {
    String[] voices = new String[16];
    for(int i = 0; i < 16; i++) {
      voices[i] = "V" + i + " R/0.25";
    }
    
    Scanner sc = new Scanner(siren_string);
    int currentRegister = 5;
    int currentVoice = 0;
    float currentTime = 0.25f;
    float currentTimeAlt = 0.25f;
    
    while(sc.hasNext()) {
      String token = sc.next();
      if(token.startsWith("!")) {
        // tempo... put it at the head of V0, regardless of anything else.
        String tempo = token.substring(1);
        voices[0] = "T" + tempo + " " + voices[0];
        continue;
      } else if(token.startsWith("@")) {
        // instrument
        String inst = token.substring(1);
        voices[currentVoice] = voices[currentVoice] + " I[" + inst + "]";
        continue;
      } else if(token.startsWith("$")) {
        // volume
        String vol = token.substring(1);
        voices[currentVoice] = voices[currentVoice] + " X[Volume]=" + vol;
        continue;
      } else if(token.startsWith("{") || token.startsWith("}")) {
        // command grouping
        continue;
      } else if(token.startsWith("[") || token.startsWith("||")) {
        // push voice
        currentVoice++;
        if(currentVoice > 15) currentVoice = 15;
        float length = getLengthOfVoice(voices[currentVoice]);
        if(length < currentTime) {
          float delta = currentTime - length;
          System.out.println("voice: " + currentVoice + " delta: " + delta);
          voices[currentVoice] = voices[currentVoice] + " R/" + delta;
        }
        continue;
      } else if(token.startsWith("]")) {
        // pop voice
        currentVoice = 0;
        float delta = currentTimeAlt - currentTime;
        if(delta > 0) voices[currentVoice] = voices[currentVoice] + " R/" + delta;
        continue;
      } else {
        // a note
        token = token.replace("V", "C#");
        token = token.replace("W", "D#");
        token = token.replace("X", "F#");
        token = token.replace("Y", "G#");
        token = token.replace("Z", "A#");
        
        voices[currentVoice] = voices[currentVoice] + " " + token;
        if(getLengthOfVoice(voices[currentVoice]) > currentTimeAlt) currentTimeAlt = getLengthOfVoice(voices[currentVoice]);
        if(currentVoice == 0) currentTime = getLengthOfVoice(voices[currentVoice]);
        continue;
      }
    }
    
    String music_string = "";
    for(int i = 0; i < 16; i++) {
      music_string = music_string + " " + voices[i] + " R/0.25\n";
    }
    System.out.println(music_string);
    return music_string.trim();
  }
}
