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
  
  public String getMusicString(String siren_string) {
    String[] voices = new String[16];
    for(int i = 0; i < 16; i++) {
      voices[i] = "V" + i;
    }
    
    Scanner sc = new Scanner(siren_string);
    int currentRegister = 5;
    int currentVoice = 0;
    float currentTime = 0;
    
    while(sc.hasNext()) {
      String token = sc.next();
      if(token.startsWith("!")) {
        // tempo... put it at the head of V0, regardless of anything else.
        String tempo = token.substring(1);
        voices[0] = "T" + tempo + voices[0];
        continue;
      } else if(token.startsWith("@")) {
        // instrument
        String inst = token.substring(1);
        voices[currentVoice] = voices[currentVoice] + " I[" + inst + "]";
        continue;
      } else if(token.startsWith("$")) {
        // volume
      } else if(token.startsWith("{") || token.startsWith("}")) {
        // command grouping
      } else if(token.startsWith("[")) {
        // push voice
      } else if(token.startsWith("]")) {
        // pop voice
      } else if(token.startsWith("/")) {
        // raise pitch
        token = token.substring(1);
        currentRegister = currentRegister + token.length();
        if(currentRegister > 9) currentRegister = 9;
        continue;
      } else if(token.startsWith("\\")) {
        // lower pitch
        token = token.substring(1);
        currentRegister = currentRegister - token.length();
        if(currentRegister < 0) currentRegister = 0;
        continue;
      } else {
        // a note
        String noteName = token.substring(0,1);
        noteName = noteName.replace("V", "C#");
        noteName = noteName.replace("W", "D#");
        noteName = noteName.replace("X", "F#");
        noteName = noteName.replace("Y", "G#");
        noteName = noteName.replace("Z", "A#");
        
        float duration = Float.parseFloat(token.substring(1));
        currentTime = currentTime + (duration / 4.0f);
        String outNote = noteName;
        
        // not quite right
        if(noteName.equals("A") || noteName.equals("A#") || noteName.equals("B"))
          outNote = outNote + (currentRegister - 1);
        else 
          outNote = outNote + currentRegister;
        outNote = outNote + "/" + (duration / 4.0f);
        voices[currentVoice] = voices[currentVoice] + " " + outNote;
        continue;
      }
    }
    
    String music_string = "";
    for(int i = 0; i < 16; i++) {
      music_string = music_string + " " + voices[i];
    }
    System.out.println(music_string);
    return music_string.trim();
  }
}
