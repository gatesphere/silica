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
    // stub
    return siren_string;
  }
}
