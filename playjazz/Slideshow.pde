// A moving image layer, handled by an array

class Slideshow {
  int framesPerChange;
  GLTexture[] textureArray;  
  int currentImage =  0; 
  int imageTotal; 
  
  Slideshow(PApplet parent, int newRate, String pathName, int howMany) {
    framesPerChange = newRate;
    textureArray = new GLTexture[howMany];
    imageTotal = howMany; 
    
    for (int i=0; i < textureArray.length; i++) {
      textureArray[i] = new GLTexture(parent,"data/frames/" + pathName + "/" + pathName + "-" + (i+1) + ".jpg");  
      println("Loaded Texture: " + i);
    }
  }
 
  void rateChange(int newRate) {
    framesPerChange = newRate;  
  }
  
  void speed(float newspeed) {
    framesPerChange = int(newspeed);  
  }
  
  void changeImage(int to) {
    currentImage = to;   
  }

  void update() {
    if ( frameCount%framesPerChange==0 ) currentImage += 1;
    
    if (currentImage >= textureArray.length) currentImage = 0; 
  } 
 
  GLTexture getCurrentTexture() {
    return textureArray[currentImage];  
  }
  
}
