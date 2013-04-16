/*

this is play||jazz. 
for the vancouver international jazz festival. 

hybridity media 2012
designed by matt marshall

*/

// load some libraries - GL
import processing.opengl.*;
import codeanticode.glgraphics.*;





// load the syphon libraries and set up the environment. 
import javax.media.opengl.*;
import jsyphon.*; // Syphon
JSyphonServer mySyphon;
PGraphicsOpenGL pgl;
GL gl;
int[] texID;

// load some libraries - TUIO
import TUIO.*;
TuioProcessing tuioClient;

// load some libraries - minim (sound)
import ddf.minim.*;
Minim minim;

// the controller
import controlP5.*;
ControlP5 cp5;

// screen size. Some might think to change this to just shift with the window, but this size also determines the SYPHON output. 
int scrWidth = 1280; 
int scrHeight = 800;
float motionThreshold = 100; 
int timePerShift = 600;

float theZone = 0.8; 

// increase my java magic. we're not actually sure this does anything useful. 
public static final int maxProxies = (int)Math.pow(2, 256);
public static final int maxPairs = maxProxies * 80;

// how many particle layers? 
ParticleSystem[] particleLayer = new ParticleSystem[4]; // how many particle layers? 
int[] blendOrder = {0,0,0,0}; // based on layerFilter array in preloadGL(), need an int for every particle layer. 0 = Colour Dodge. 

GLTexture[] texArray = new GLTexture[24]; // # of particle textures
int[] texArraySize = new int[texArray.length]; 

// GL Environment Varialbes
GLTextureFilter[] layerFilter = new GLTextureFilter[7];
GLTexture[] layerArray = new GLTexture[particleLayer.length];
GLTexture outputImage = new GLTexture(); 
GLTexture backgroundImage = new GLTexture();
GLGraphicsOffScreen[] offscreen = new GLGraphicsOffScreen[particleLayer.length];
Slideshow backgroundSlideshow;

// music environment variables
int theSeed = 342352632; // different seeds will produce different sound sequences. 
Noiser noiser;
Noiser sequenceNoiser;
int globalBuffer = 2048; // may be deprecated now that we've switched to Snippets. 
float globalBpm = 120; // doesn't have a huge impact here, but helpful for sequencing sound events in terms of BEATS, not FRAMES. 

// instruments
Instrument notes;
AudioPlayer rain;
AudioPlayer[] keys = new AudioPlayer[2]; // we use audio players for long/loopy sounds. 
AudioPlayer[] beats = new AudioPlayer[2]; // we use audio players for long/loopy sounds. 
Instrument trumpet;
Instrument flute; 
Instrument joFlute; 
PresetTimer presetTimer;

void setup() {
  // basic environment settings
  size(scrWidth, scrHeight, GLConstants.GLGRAPHICS);
  frameRate(30);
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("motionThreshold")
     .setPosition(100,305)
     .setSize(200,20)
     .setRange(0,2000)
     .setValue(100)
     ;
     
  cp5.addSlider("timePerShift")
     .setPosition(100,335)
     .setSize(200,20)
     .setRange(10,500)
     .setValue(2000)
     ;
     
  cp5.addSlider("theZone")
     .setPosition(100,365)
     .setSize(200,20)
     .setRange(0.3,1.0)
     .setValue(1.0)
     ; 
  
  // shows a loading screen with specified image (String)
  displayLoading("data/img/loading.jpg");
  
  // init syphon
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
  initSyphon(gl,"Syphon Output");
    
  // sets up the GL environment with specified background image (String)   
  preloadGL("data/img/background3.jpg");
  
  // loads the Slideshow/OtherFrames
  // (this, Frames per Image, Set, How many in Set)
  backgroundSlideshow = new Slideshow(this, 10, "final", 6);
  //foregroundSlideshow = new Slideshow(this, 20, "otherframes", 200);  
  
  // sets up the sound environment
  preloadAudio();
  
    // load the sound files
    // ****** TODO: Set path separately, combine when loading so we don't have to type it all out every time. 
  String[] notesFiles = {"data/music/note1.mp3", "data/music/note2.mp3", "data/music/note3.mp3", "data/music/note4.mp3", "data/music/note5.mp3", "data/music/note6.mp3", "data/music/note7.mp3"};
  String[] trumpetFiles = {"data/music/trumpet_01.mp3","data/music/trumpet_02.mp3","data/music/trumpet_03.mp3","data/music/trumpet_04.mp3","data/music/trumpet_05.mp3","data/music/trumpet_06.mp3","data/music/trumpet_07.mp3",};
  String[] fluteFiles = {"data/music/flute_01.mp3","data/music/flute_02.mp3","data/music/flute_03.mp3","data/music/flute_04.mp3","data/music/flute_05.mp3","data/music/flute_06.mp3","data/music/flute_07.mp3","data/music/flute_08.mp3","data/music/flute_09.mp3","data/music/flute_10.mp3","data/music/flute_11.mp3","data/music/flute_12.mp3"};
  String[] joFluteFiles = {"data/music/joflute_01.mp3", "data/music/joflute_02.mp3", "data/music/joflute_03.mp3", "data/music/joflute_04.mp3", "data/music/joflute_05.mp3"};
  
  // Initialize our instruments with their sample array
  notes = new Instrument(notesFiles);
  joFlute = new Instrument(joFluteFiles);
  trumpet = new Instrument(trumpetFiles); 
  flute = new Instrument(fluteFiles);
  rain = minim.loadFile("data/music/rainloop.mp3");
  keys[0] = minim.loadFile("data/music/keys2_section1.mp3");
  keys[1] = minim.loadFile("data/music/keys2_section2.mp3");
  beats[0] = minim.loadFile("data/music/beats.mp3");
  beats[1] = minim.loadFile("data/music/beats2.mp3");
  
  
  // the Noiser relates to the SEQUENCING of sounds, not the sounds themselves. 
  // Creates a constantly shifting perlin noise scheme to allow for music complexity to dynamically shift over time.   
  noiser = new Noiser();
  sequenceNoiser = new Noiser();
 
  
  // load the textures. Make sure the array is big enough.
  // ****** TODO: Change to ArrayList system, so it's not as stiff. Or maybe not, for speed and memory? 
  loadTexture(0, "data/img/bokeh_512.png", 512);
  loadTexture(1, "data/img/bokeh_256n.png", 256);
  loadTexture(2, "data/img/bokeh_512.png", 128);
  loadTexture(3, "data/img/forest_01.png", 512);
  loadTexture(4, "data/img/forest_02.png", 512); //REPLACE THIS WITH OLD FOREST PARTICLE
  loadTexture(5, "data/img/future1.png", 512);
  loadTexture(6, "data/img/future2.png", 512);
  loadTexture(7, "data/img/future3.png", 512);
  loadTexture(8, "data/img/forest_03.png", 512);
  loadTexture(9, "data/img/forest_04.png", 1024);
  loadTexture(10, "data/img/ny_04.png", 1024);
  loadTexture(11, "data/img/ny_01.png", 512);
  loadTexture(12, "data/img/ny_02.png", 512);
  loadTexture(13, "data/img/ny_03.png", 512);
  loadTexture(14, "data/img/sp_01.png", 512);
  loadTexture(15, "data/img/sp_02.png", 512);
  loadTexture(16, "data/img/sp_03.png", 512);
  loadTexture(17, "data/img/sp_04.png", 512);
  loadTexture(18, "data/img/sp_05.png", 1024);
  loadTexture(19, "data/img/istanbul.png", 1024);
  loadTexture(20, "data/img/ny_05.png", 1024);
  loadTexture(21, "data/img/bokeh_512.png", 64);
  loadTexture(22, "data/img/bokeh_256n.png", 128);
  loadTexture(23, "data/img/bokeh_512.png", 64);

  // start particle systems
  for (int i = 0; i < particleLayer.length; i++) {
    particleLayer[i] = new ParticleSystem();  
  }

  // we create an instance of the TuioProcessing client
  tuioClient = new TuioProcessing(this);
  
  // start a timer object to cycle through presets automatically 
  int[] theOrder = {1,2,4,1,3,5};
  presetTimer = new PresetTimer(timePerShift, 5, theOrder); // seconds per preset, cooldown period in seconds, array for the preset order. 
  
  // start a background rain loop. 
  rain.loop();

}

void draw() {  

  presetTimer.changeTime(timePerShift);
  
  // unload all the current OSC/TUIO points. 
 Vector tuioCursorList = tuioClient.getTuioCursors();
   for (int i=0;i<tuioCursorList.size();i++) {
     
      TuioCursor tcur = (TuioCursor)tuioCursorList.elementAt(i);
      
      float thisCursorX = norm(tcur.getScreenX(width), scrWidth - (scrWidth*theZone), scrWidth*theZone);
     // float thisCursorY = tcur.getScreenY(height);
      
      if (tcur.getScreenX(width) < scrWidth*theZone && tcur.getScreenX(width) >  scrWidth - scrWidth*theZone) {
      
        // send this through to makeJazz depending on what KCV sends your way. 
        float blobWidth = (tcur.getScreenX(width) - (norm(tcur.getMotionAccel(),0,640) *scrWidth)) * 2; 
        
        println("BLOB WIDTH: " +  tcur.getMotionAccel() ); 
        println("POSITION: " +  tcur.getScreenX(width) ); 
        println("CALCULATED WIDTH: " +  blobWidth); 
        
        if ( blobWidth >= motionThreshold ) { 
          println("MOTION TRIGGER!"); 
          makeJazz(thisCursorX*scrWidth, tcur.getScreenY(height) + 170, tcur.getMotionAccel(),presetTimer.getCurrentPreset(), true); 
        } else {
          makeJazz(thisCursorX*scrWidth, tcur.getScreenY(height) + 170, tcur.getMotionAccel(),presetTimer.getCurrentPreset(), false); 
        }
      }
   }
   
  // use mouse for debugging
  if (mousePressed) {
    if (keyPressed == true ) {
       makeJazzMouse(mouseX,mouseY,presetTimer.getCurrentPreset(),true); 
    } else {
       makeJazzMouse(mouseX,mouseY,presetTimer.getCurrentPreset(),false);  
    }
  } 
  
   // update the instruments and embedded counters 
   // **** TODO: Can I find a more elegant solution for this? Instruments in an array? 
  notes.update();
  flute.update();
  trumpet.update();
  joFlute.update();
  presetTimer.update();
  
  // update any slideshows
  //backgroundSlideshow.update(); 
  
  // shift the perlin noise
  noiser.move(0.5, 20.0, 0.9); // bars per move, move amount, probability of y shift 
  sequenceNoiser.move(8.0, 0.75, 0.75); 
  noiser.get(); // debug, prints the current noiser value. 
  
  // bars per move is how often the perlin noise values will shift
  // move amount - the greater it is, the less "smooth" change in sequence intensity will be
  // probability of y shift - a change in the y shift will sometimes create a sudden change in intensity
   
  // composite everything and display the final image, as well as Syphon output
  displayOutput();
  
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      presetTimer.nextPreset(); 
    } 
    if (keyCode == LEFT) {
      presetTimer.prevPreset(); 
    } 
  }
}
