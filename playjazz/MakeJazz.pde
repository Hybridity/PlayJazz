void makeJazzMouse(float x, float y, int sequence, Boolean motionMod) {
  if (motionMod == true) {
    makeJazz(x, y, 20.0, sequence, true);   
  } else {
    makeJazz(x, y, 0.1, sequence, false);
  }
}

void makeJazz(float x, float y, float motion, int sequence, Boolean motionMod) {
  switch(sequence) {
  case 1: // sequence one: BOKEH
    backgroundSlideshow.changeImage(0); 

    blendOrder[0] = 1;
    blendOrder[1] = 1;
    blendOrder[2] = 1;
    blendOrder[3] = 1;

    
    if ( motionMod == true) {
      //eventVisual(3, particleLayer[3], 18, 0.1, x+random(-520, 520), y+random(-520, 520), 4, false);
      eventVisual(50, particleLayer[3], 0, 0.2, x+random(-300, 300), y+random(-400, 300), 10, true);
      eventVisual(10, particleLayer[1], 1, 0.2, x+random(-300, 300), y+random(-400, 300), 10, true);
      eventVisual(21, particleLayer[2], 2, 0.2, x+random(-300, 300), y+random(-400, 300), 10, true);
      eventVisual(50, particleLayer[3], 0, 0, x+random(-150, 150), y+random(-250, 150), 6, true);
      eventVisual(10, particleLayer[1], 1, 0, x+random(-100, 100), y+random(-230, 150), 6, true);
      eventVisual(21, particleLayer[2], 2, 0, x+random(-100, 100), y+random(-230, 150), 6, true);    
      musicBox(sequence, motion, true); 
    } else {
      eventVisual(100, particleLayer[3], 21, 0, x+random(-50, 50), y+random(-200, 100), 6, true);
      eventVisual(10, particleLayer[1], 22, 0, x+random(-100, 100), y+random(-250, 200), 6, true);
      eventVisual(21, particleLayer[2], 23, 0, x+random(-100, 100), y+random(-250, 200), 6, true);  
      musicBox(sequence, motion, false); 
    }
    break;

  case 2: // sequence two: forest
    backgroundSlideshow.changeImage(1); 

    blendOrder[0] = 0;
    blendOrder[1] = 4;
    blendOrder[2] = 1;


    if ( motionMod ) {
     eventVisual(1, particleLayer[2], 8, 0, x+random(-250, 250), y+random(-250, 250), 10, false);
     musicBox(sequence, motion, true); 
    } else {
    eventVisual(7, particleLayer[0], 3, 0, x+random(-50, 50), y+random(-50, 50), 4, false);
    eventVisual(5, particleLayer[1], 4, 0, x+random(-100, 100), y+random(-100, 100), 4, false);
    eventVisual(8, particleLayer[2], 9, 0, x+random(-250, 250), y+random(-250, 250), 4, false);
    musicBox(sequence, motion, false); 
    }

    
    break; 

  case 3: // sequence three: future cities
    backgroundSlideshow.changeImage(2); 

    blendOrder[0] = 0;
    blendOrder[1] = 1;
    blendOrder[2] = 1;
    blendOrder[3] = 4;
    
    if ( motionMod == true ) {
        eventVisual(3, particleLayer[3], 19, 0.2, x+random(-200, 200), y+random(-400, 100), 6, false);
        eventVisual(10, particleLayer[1], 19, 0.2, x+random(-200, 200), y+random(-400, 100), 6, false);
        eventVisual(10, particleLayer[1], 6, 0.0, x+random(-200, 200), y+random(-400, 100), 4, false);
        eventVisual(10, particleLayer[2], 7, 0.0, x+random(-250, 250), y+random(-400, 100), 4, false);
        eventVisual(10, particleLayer[3], 5, 0.0, x+random(-250, 250), y+random(-400, 100), 4, false);
        musicBox(sequence, motion, true); 
    } else {
        eventVisual(10, particleLayer[1], 5, 0.0, x+random(-25, 25), y+random(-100, 20), 6, false);
        eventVisual(10, particleLayer[1], 6, 0.0, x+random(-25, 25), y+random(-200, 50), 6, false);
        eventVisual(10, particleLayer[2], 7, 0.0, x+random(-100, 100), y+random(-200, 50), 4, false);
        eventVisual(10, particleLayer[3], 5, 0.0, x+random(-100, 100), y+random(-200, 50), 6, false);
        musicBox(sequence, motion, false); 
    }
    break; 

  case 4: // sequence three: new york
    backgroundSlideshow.changeImage(4); 

    blendOrder[0] = 0;
    blendOrder[1] = 1;
    blendOrder[2] = 1;
    blendOrder[3] = 1;

    if ( motionMod == true) {
      eventVisual(3, particleLayer[3], 10, 0.0, x+random(-300, 300), y+random(-500, 100), 8, true);
      eventVisual(5, particleLayer[3], 20, 0.0, x+random(-300, 300), y+random(-500, 100), 8, false);
      eventVisual(2, particleLayer[1], 11, 0.0, x+random(-50, 50), y+random(-50, 50), 4, false);
      eventVisual(1, particleLayer[2], 12, 0.0, x+random(-100, 100), y+random(-100, 100), 4, false);
      eventVisual(3, particleLayer[3], 12, 0.0, x+random(-250, 250), y+random(-100, 100), 4, false);
musicBox(sequence, motion, true);
    } else {
      eventVisual(2, particleLayer[1], 11, 0.0, x+random(-50, 50), y+random(-150, 50), 4, false);
      eventVisual(1, particleLayer[2], 12, 0.0, x+random(-50, 50), y+random(-300, 50), 4, false);
      eventVisual(3, particleLayer[3], 12, 0.0, x+random(-50, 50), y+random(-300, 50), 4, false);
  musicBox(sequence, motion, false);  
  }
    
     
    break;         

  case 5: // sequence three: sao paolo
    backgroundSlideshow.changeImage(5); 

    blendOrder[0] = 0;
    blendOrder[1] = 1;
    blendOrder[2] = 1;
    blendOrder[3] = 1;
    
    if ( motionMod == true ) {
     eventVisual(2, particleLayer[3], 18, 0.0, x+random(-250, 250), y+random(-250, 250), 10, false);
     eventVisual(2, particleLayer[1], 18, 0, x+random(-50, 50), y+random(-250, 50), 8, true);
      eventVisual(1, particleLayer[2], 14, 0, x+random(-50, 50), y+random(-200, 100), 8, true);
      eventVisual(3, particleLayer[2], 14, 0, x+random(-50, 50), y+random(-250, 50), 8, true);
      musicBox(sequence, motion, true);
      
    } else {
      eventVisual(2, particleLayer[1], 14, 0, x+random(-50, 50), y+random(-250, 50), 8, true);
      eventVisual(1, particleLayer[2], 14, 0, x+random(-50, 50), y+random(-200, 100), 8, true);
      eventVisual(3, particleLayer[2], 14, 0, x+random(-50, 50), y+random(-250, 50), 8, true);
      eventVisual(3, particleLayer[3], 14, 0, x+random(-50, 50), y+random(-250, 50), 8, true);
      musicBox(sequence, motion, false);
    }
    

    break;
  }
}


void musicBox(int sequence, float motion, Boolean motionMod) {
  
  if ( sequenceNoiser.get() >= 0.0 && sequenceNoiser.get() < 0.25 ) {
    
    sequence = 1; 
   
  } else if ( sequenceNoiser.get() >= 0.25 && sequenceNoiser.get() < 0.5 ) {
    
    sequence = 1; 

    
  } else if ( sequenceNoiser.get() >= 0.5 && sequenceNoiser.get() < 0.75 ) {
    
    sequence = 2; 
    
  } else if ( sequenceNoiser.get() >= 0.75 && sequenceNoiser.get() < 1.0 ) {
    
    sequence = 3;
    
  } else {
    
    sequence = 2; 
    
  } 
  
  
  switch(sequence) {
  case 1:
    
    if ( motionMod == true ) {
      if (keys[0].isPlaying() == false && keys[1].isPlaying() == false) {
      keys[0].rewind();
      keys[1].rewind();
      if (noiser.get() < 0.65) {
        keys[1].play();
      } 
      else {
        keys[0].play();
      }
    } 
      if (trumpet.isPlaying() == false){
        trumpet.play(); 
      }
    }
    randSequencer(flute, 4, 1.0, "negative", noiser);

    /*randSequencer(notes, 0.3, 0.4, "positive", noiser);
    randSequencer(notes, 0.6, 0.3, "positive", noiser);
    randSequencer(notes, 0.3, 0.2, "negative", noiser);*/
  break;
  case 2:
    if (beats[0].isPlaying() == false && beats[1].isPlaying() == false) {
      beats[0].rewind();
      beats[1].rewind();
      if (motionMod == true) {
        beats[1].play();
      } else {
        beats[0].play();
      }
    } 
    
    if (motionMod == true ) {
      if (joFlute.isPlaying() == false){
        joFlute.play(); 
      }
    }

  break;
  
  case 3:
     if (motionMod == true ) {
      if (flute.isPlaying() == false){
        flute.play(); 
      }
      if (notes.isPlaying() == false){
        notes.play(); 
      }
       randSequencer(notes, 0.25, 1.0, "positive", noiser);
       randSequencer(notes, 0.5, 0.5, "positive", noiser);
       randSequencer(notes, 0.3, 1.0, "negative", noiser);
       randSequencer(trumpet, 4, 1.0, "positive", noiser);
    }
    
    if (notes.isPlaying() == false){
        notes.play(); 
      }
      
    randSequencer(notes, 0.5, 1.0, "positive", noiser);
       randSequencer(notes, 0.5, 1.0, "negative", noiser); 
  break;
  }    
   
}

