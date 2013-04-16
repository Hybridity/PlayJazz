// Contains classes and methods related to the generative music

// converts # of bars to # of frames, based on global BPM. 
float bars(float b) { // 'b' is how many bars we want to convert
  float bars = (((globalBpm/4)/15)*b)*30;
  return bars; 
}

Boolean barsEvery(float b) { // 'b' - how many bars have passed
  Boolean play;
  if (frameCount%bars(b)==0) {
    play = true; 
  } else {
    play = false;
  }
  
  return play;
}

void randSequencer(Instrument i, float b, float p, String mode, Noiser n) {
  if ( mode == "positive" ) {
    if ( barsEvery(b) ) {
       //if ((n.get() + (random(0,1)*p)) > 1) i.play(); // old algoritim
      if ( p > 1.0 ) {
         i.play();
      } else {
        if (  (random(0,1)< p) && (random(0,1) < n.get())  ) i.play(); // different algorithim 
      }
    }
  } else if ( mode == "negative" ) {
    if ( barsEvery(b) ) {
       //if ((1 + n.get() - (random(0,1)*p)) < 1) i.play(); // old algorithim 
      if ( p > 1.0 ) {
        i.play();
      } else {
        if (  (random(0,1)< p) && (random(0,1) > n.get())  ) i.play(); // different algorithim 
      }
    }
  }  
}

// A class to describe a group of samples, which we will call an Instrument
// An ArrayList of Samples

class Instrument {
  
  ArrayList samples;  // an arraylist of samples
  
  // Construct an instrument with an array of files
  Instrument(String[] filelist) {
    samples = new ArrayList(); 
    for ( int i = 0; i < filelist.length; i++ ) {
      samples.add(new Sample(filelist[i],globalBuffer));  
    }
  }
  
  // updates internal object timers for looping
  void update() {
    for ( int i = 0; i < samples.size(); i++ ) {
      Sample s = (Sample) samples.get(i);
      s.update();
    }    
  }

  // add a sample to the array
  void addSample(String f, int b) { 
    samples.add(new Sample(f,b));
  }  
  
  // play a designated sample
  void play(int i) {
    Sample s = (Sample) samples.get(i);
    s.play();
  }
  
  // play a random note from the array like a good drunkard.
  void play() {
    int i = int(random(0,samples.size()));
    Sample s = (Sample) samples.get(i);
    s.play();
  }
  
  // loop a designated sample
  void playLoop(int i, float lp) {
    lp = bars(lp);
    Sample s = (Sample) samples.get(i);
    s.playLoop(lp);
  }
  
  // loop a random sample, like a good perpetual drunkard
  void playLoop(float lp) {
    lp = bars(lp);
    int i = int(random(0,samples.size()));
    Sample s = (Sample) samples.get(i);
    s.playLoop(lp);
  }
  
  // get the size of the array, helpful for generating random values
  int getSize() {
    return samples.size();  
  }
  
  Boolean isPlaying() {
    Boolean playing = false; 
    for ( int i = 0; i < samples.size(); i++ ) {
        Sample s = (Sample) samples.get(i);
        if ( s.isPlaying() == true ) {
           playing = true;   
        } 
      }
    return playing; 
  }
  // stops the instrument when the program ends. 
  void kill() {
    // println("Attempting kill"); // debug
    for (int i = samples.size()-1; i >= 0; i--) {
      Sample s = (Sample) samples.get(i);
      s.kill();
      samples.remove(i);
    }
  }
}

class Noiser {
 float x;
 float y;

  Noiser() {
    x = 0;
    y = random(0,100);
  }
  
  Noiser(float a, float b) {
    x = a;
    y = b;  
  } 
  
  
// moves the noise coordinates to shape how the song progresses.
void move(float b, float a, float p) { // 'b', how many bars per move 'a' is how much it moves on the x axis, 'y' is the probability that it will jump up in the 'y' axis
  if (frameCount%bars(b)==0) {
    x = x + a; 
    if (random(0,1) < p) {
      y = y + (random(0,10)); // randomized chance of shifting on Y axis
    }
  }
}

// returns a perlin noise value based on current position
float get() {
  float pos = noise(x,y);
  //println(pos);
  return pos; 
}

// returns a perlin noise value converted to a value we can use to scale probabilities
float getScaler() {
  float n = get() + 0.5;
  //println(n);
  return n;  
}
  
}

// A class to describe one Sample within an instrument

class Sample {
  String file;
  int buffer; 
  int timer; 
  Boolean loopSample;
  float loopPoint;

  AudioSnippet sample;
  
  Sample(String f, int b) {
    file = f;
    buffer = b; 
    timer = 0; 
    loopSample = false;
    loopPoint = 0;
    sample = minim.loadSnippet(file);
  }
  
  // triggers the sample
  void play() {   
    sample.play(); 
    println("Sample Play"); 
    
    // ----------------------
    // this is a test. 
    //globalBrightness += 40;
    // ---------------------- 
  }
  
  void playLoop(float lp) {
    loopPoint = lp;
    loopSample = true;
    play();  
  }
    
  void update() {
    timer = timer + ((frameCount/frameCount));
    loopThis();
    
    if (sample.isPlaying() == false) {
      sample.rewind();   
    }
    
  }
  
  Boolean isPlaying() {
    return sample.isPlaying();   
  }
  
  void rewind() {
     sample.rewind();  
  }
  
  void loopThis() {
    if ((loopSample == true) && (timer >= loopPoint)) {
      play();
      timer = 0; // reset the timer 
    }  
  }

  void loopChange(float lp) {
    loopPoint = lp;
  }
  
  void kill() { 
    sample.close();   
  }
  
  void change(String f, int b) {
    file = f;
    buffer = b;
    sample = minim.loadSnippet(file);
      // what happens if changed mid playback? should be close the sample and re-init from within the class? 
  }
  
  void destroy() { 
    sample.close(); 
    // println("I AM DEAD"); // debug
  }
  
}

// TODO: Build some sort of randomized instrument section builder. 
class Section {
  float value;
  Instrument instrument;
  
  // initialize the section, give it a value (usually randomized) to "scale" the frequency of triggers
  Section(float v, Instrument i) {
    instrument = i;
    value = v; 
  }
  
  void play() {
      
  }
  
}
