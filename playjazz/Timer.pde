class PresetTimer {
  int currentTime; // current time elapsed, in seconds. 
  int presetTime; // how long each preset runs for
  int coolDown; // when the preset is done, how much cooldown before switching to the next one. Allows particles time to die so change is smooth. 
  int currentPresetOrder; // preset # currently in use. 
  int[] presetOrder; // contains the full preset order
  
  PresetTimer(int pT, int cD, int[] pO) {
    currentTime = 0;
    presetTime = pT; 
    coolDown = cD;
    presetOrder = pO;
    currentPresetOrder = 0;  
  }
  
  void changeTime(int pT) {
    presetTime = pT;
  }
  
  void update() {
    if (frameCount%30==0) currentTime += 1;
    
    if (currentTime >= presetTime + coolDown) {
      this.nextPreset();   
    }
    
    if (currentPresetOrder > presetOrder.length) currentPresetOrder = 0; // failsafe to avoid array out of bounds. 
    
  }
  
  int getCurrentPreset() {
    return presetOrder[currentPresetOrder];  
  } 
 
  Boolean isCooldown() { // method to return if are we in the "cooldown" phase? 
    if (currentTime < presetTime + coolDown && currentTime > presetTime) {
      return true; 
    } else {
      return false; 
    }   
  } 
  
  void prevPreset() {
    
    if (currentPresetOrder == 0 ) {
      currentPresetOrder = presetOrder.length - 1; // go back to first preset in the array if we've reached the end
      //println("The array length: " + presetOrder.length); 
    } else {
      currentPresetOrder = currentPresetOrder - 1; // go to LAST preset     
    }
    currentTime = 0; // reset the timer
    println("CURRENT PRESET: " + currentPresetOrder);
  }
  
  
  void nextPreset() {
    
    if (currentPresetOrder == presetOrder.length - 1) {
      currentPresetOrder = 0; // go back to first preset in the array if we've reached the end
      println("The array length: " + presetOrder.length); 
    } else {
      currentPresetOrder += 1; // go to next preset     
    }
    currentTime = 0; // reset the timer
     println("CURRENT PRESET: " + currentPresetOrder);
  }
  
}
