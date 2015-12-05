package View;

// Import the basic graphics classes.
import java.awt.*;
import java.awt.image.ImageObserver;
import java.net.URL;

import javax.swing.*;
/**
 * Simple program that loads, rotates and displays an image.
 * Uses the file Duke_Blocks.gif, which should be in
 * the same directory.
 * 
 * @author MAG
 * @version 20Feb2009
 */

public class RobotArmComponent extends JComponent implements ImageObserver{
	private static final long serialVersionUID = 1L;
	// Declare an Image object for us to use.
	private final String baseImgURL= "/resources/images/RobotArm";
	private final String ImgsExt= ".png";
	private final int numberOfImgs = 7;
    Image currentImage;
    Image images[];
    ImageObserver io;
    private double rotation = 0;
    // Create a constructor method
    public RobotArmComponent(){
       super();
       images = new Image[numberOfImgs];
       for (int i=0; i< numberOfImgs; i++){
    	   URL url = getClass().getResource(baseImgURL+i+ImgsExt);
    	   images[i] = Toolkit.getDefaultToolkit().getImage(url);
       }
       // Load an image to play with.
       currentImage = images[0];
    }
 
    public void rotate(double rotation){
    	this.rotation=rotation;
    }
    
    public void paintComponent(Graphics g){
    	Graphics2D g2d=(Graphics2D)g; // Create a Java2D version of g.
    	g2d.rotate(rotation,850,360+150);
        g2d.drawImage(currentImage, 850-(currentImage.getWidth(this)/2), 360-(currentImage.getHeight(this)/2),currentImage.getWidth(this), currentImage.getHeight(this), this);
        g2d.dispose();
    	g2d.drawImage(currentImage, 850-(currentImage.getWidth(this)/2), 360-(currentImage.getHeight(this)/2),currentImage.getWidth(this), currentImage.getHeight(this), this);
    }

	public void closePliers() {
		 for (int i=1; i< numberOfImgs; i++){
			 currentImage=images[i];
			 this.repaint();
			 try {
				Thread.sleep(30);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		 }
	}

	public void openPliers() {
		 for (int i=numberOfImgs-2; i>=0; i--){
			 currentImage=images[i];
			 this.repaint();
			 try {
				Thread.sleep(30);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		 }
	}

}