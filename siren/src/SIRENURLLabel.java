import java.awt.Color;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Graphics;
import java.awt.Insets;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.net.URI;
import javax.swing.JLabel;

public class SIRENURLLabel extends JLabel {
  public String url;
  public boolean clicked = false;

  public SIRENURLLabel() { this("",""); }
  public SIRENURLLabel(String label, String url, int align) {
    this(label, url);
    this.setHorizontalAlignment(align);
  }
  
  public SIRENURLLabel(String label, String url) {
    super(label);
    this.url = url;
    if(clicked) setForeground(Color.RED);
    else setForeground(Color.BLUE.darker());
    setCursor(new Cursor(Cursor.HAND_CURSOR));
    addMouseListener(new URLOpener());
  }

  public void paintComponent(Graphics g) {
    super.paintComponent(g);
    if(clicked) {
      g.setColor(Color.red);
      setForeground(Color.RED);
    } else {
      g.setColor(Color.blue);
      setForeground(Color.BLUE.darker());
    }
    Insets insets = getInsets();
    int left = insets.left;
    if (getIcon() != null) {
      left += getIcon().getIconWidth() + getIconTextGap();
    }
    g.drawLine(left, getHeight() - 1 - insets.bottom, 
      (int) getPreferredSize().getWidth()
      - insets.right, getHeight() - 1 - insets.bottom);
  }
}

class URLOpener extends MouseAdapter {
  public void mouseClicked(MouseEvent e) {
    if (Desktop.isDesktopSupported()) {
      try {
        SIRENURLLabel l = (SIRENURLLabel)e.getComponent();
        String url = l.url;
        Desktop.getDesktop().browse(new URI(url));
        l.clicked = true;
        l.repaint();
      } catch (Exception ex) {}
    }
  }
}
