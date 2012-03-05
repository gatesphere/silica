// silica project
// siren - the silica rendering engine
// Jacob M. Peck
// SIRENTranslator.java
  
import org.jfugue.*;  
  
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
      if(token.startsWith("!") {
        // tempo... put it at the head of V0, regardless of anything else.
        String tempo = token.substring(1);
        voices[0] = "T" + tempo + voices[0];
      } else if(token.startsWith("@") {
        // instrument
        String inst = token.substring(1);
        voices[currentVoice] = voices[currentVoice] + " I[" + inst + "]";
      } else if(token.startsWith("$") {
        // volume
      } else if(token.startsWith("{") || token.startsWith("}")) {
        // command grouping
      } else if(token.startsWith("[")) {
        // push voice
      } else if(token.startsWith("]")) {
        // pop voice
      )
      } else if(token.startsWith("/") {
        token = token.substring(1);
        currentRegister = currentRegister + token.length();
        if(currentRegister > 9) currentRegister = 9;
        // raise pitch
      } else if(token.startsWith("\\") {
        // lower pitch
        token = token.substring(1);
        currentRegister = currentRegister - token.length();
        if(currentRegister < 0) currentRegister = 0;
      } else {
        // a note
        token = token.replace("V", "C#");
        token = token.replace("W", "D#");
        token = token.replace("X", "F#");
        token = token.replace("Y", "G#");
        token = token.replace("Z", "A#");
        
        String noteName = token.substring(0,1);
        int duration = Integer.parseInt(token.substring(1));
        currentTime = currentTime + (duration / 4.0f)
        String outNote = noteName + currentRegister + "/" + (duration / 4.0f);
        voices[currentVoice] = voices[currentVoice] + " " + outNote;
      }
    }
    
    String music_string = "";
    for(int i = 0; i < 16; i++) {
      music_string = music_string + " " + voices[i]
    }
    return music_string.trim();
  }
}
