PImage img;

var value,
allCharz,
allCharzKeyed,
allCharzLength,
typingCount,
filenameSave,
timearray, timename,
now, hour1, minute1, second1, month1, day1, year1; 

String poetry = "The \"smell\" of smoke like a cane and fur coat on the neck of those who come and go. Why, is it, that we don't know?";
String howl1 = "I saw the best minds of my generation destroyed by madness";
String howl2 = "I’m with you in Rockland in my dreams you walk dripping from a sea-journey on the highway across America in tears to the door of my cottage in the Western night.";
String howl3 = "What sphinx of cement and aluminum bashed open their skulls and ate up their brains and imagination?";
String typedString;
String[] chars;
int dataAmount;
int dataRepeat;

int randomCount;
int limitFade;
int[] clr = new int[3];
int[] clrTarget = new int[3];
color c1;
PixelBox[] pixbox = new PixelBox[0];

//Set up ASCII CHAR arrays for comparison with text
String[] csv_input;
float[] asciiDEC;
String[] asciiCHAR;

float[] conversionValuesArray;
float[] conversionColorsArray;
String[] reformedChars;
String reformedText;
String codeKey;
String[] codeKeySplit;
String[] parseRT;

int xCount = 0;
int yCount = 0;
int colorCount = 0;
int pixelSize = 1;
int colorBoxSize = 10;
int recordMode = 0;
float lastMillis = 0;
float mm;
boolean textEntered;
boolean makePixel;
color thisBlock;
String imageName = "123.png";

void setup() {
  size(320, 400);
  smooth();
  background(255);
  noStroke();
  img = loadImage(imageName);
  //chars = poetry.split("");
  //println(chars);
  csv_input = loadStrings("ASCII_DEC_values.csv");
  asciiDEC = new float[csv_input.length];
  asciiCHAR = new String[csv_input.length];
  chars = new String[csv_input.length];
  conversionValuesArray = new float[0];
  conversionColorsArray = new float[0];
  reformedChars = new String[0];
  loadASCII(); //function to load ascii from csv
  
  //set codeKey
  codeKey = "123";
  codeKeySplit = codeKey.split("");
  console.log("codeKeySplit = "+codeKeySplit);
  
  dataAmount = ((width/colorBoxSize)*(height/colorBoxSize))*3;
  
  limitFade = floor(random(50, 200));
  clrTarget[0]  = floor(random(100, 220));
  clrTarget[1]  = floor(random(100, 220));
  clrTarget[2]  = floor(random(100, 220));
}

void draw() {
  if(makePixel == true){
    colorGrid();
  }
  for (int i = 0; i < pixbox.length; i++) {
    pixbox[i].display();
    pixbox[i].update();
  }
}

void loadASCII(){
  //load ASCII DEC values and CHAR values from CSV
  for (int i = 0; i < csv_input.length; i++) {
    String[] splits = csv_input[i].split(",");
    asciiDEC[i] = float(splits[0]);
    asciiCHAR[i] = splits[1];
    asciiCHAR[12] = ",";
    asciiCHAR[2] = "\"";
    //println("asciiDEC = "+asciiDEC[i]);
  }
}

void matchCharacters(String[] chars){
  //clear conversionColorsArray if this is not the first translateColor
  conversionValuesArray = new float[0];
  
  for(int x=0; x < dataRepeat; x++){
    for(int i = 0; i < chars.length; i++){
      for(int j = 0; j < csv_input.length; j++){
          if(chars[i].equals(asciiCHAR[j])){
            int matchVals = int(asciiDEC[j]);
            //println("matchVals = "+matchVals);,
            conversionValuesArray = append(conversionValuesArray, matchVals+20); 
            //println("conversionValuesArray"+i+ " = " +conversionValuesArray[i]);
          }
        }
      }
    }
  colorCount = 0; 
  yCount=0;
  xCount=0; 
  makePixel = true;
  pixbox = expand(pixbox, 0);
  console.log("conversionValuesArray.length = " + conversionValuesArray.length);
}

void parseText(String[] chars){
  chars = allCharz;
  dataRepeat = dataAmount/chars.length;
  matchCharacters(chars);
} 

void colorGrid(){
  //make the color grid
  
  if(colorCount < dataAmount){
   //if (millis() > lastMillis+0) { //been at least 1 millis
     //lastMillis=millis();
      if (xCount < width) {
         for (int j = 0; j < width/colorBoxSize; j++) {       
          thisBlock = color(conversionValuesArray[colorCount], conversionValuesArray[colorCount+1], conversionValuesArray[colorCount+2]);
          
          
          if(colorCount==0){
            clr[0]  = conversionValuesArray[colorCount];
            clr[1]  = conversionValuesArray[colorCount+1];
            clr[2]  = conversionValuesArray[colorCount+2];
          }
          if (randomCount > limitFade) {
            clrTarget[0]  = clr[0];
            clrTarget[1]  = clr[1];
            clrTarget[2]  = clr[2];
            clr[0]  = conversionValuesArray[colorCount];
            clr[1]  = conversionValuesArray[colorCount+1];
            clr[2]  = conversionValuesArray[colorCount+2];
            limitFade = floor(random(50, 200));
            randomCount=0;
          }
          randomCount+=1;
          clrTarget[0]  += (clr[0]-clrTarget[0])*(limitFade*0.0001);//(clr[0]-clrTarget[0])*0.001;
          clrTarget[1]  += (clr[1]-clrTarget[1])*(limitFade*0.0001);
          clrTarget[2]  += (clr[2]-clrTarget[2])*(limitFade*0.0001);
          c1 = color (clrTarget[0], clrTarget[1], clrTarget[2]);
          
          PixelBox temp = new PixelBox(xCount, yCount, c1, thisBlock);
          pixbox = (PixelBox[])append (pixbox, temp);
        
          //fill(thisBlock); 
          //rect(xCount+5,yCount+5,pixelSize,pixelSize);
          colorCount+=3;
          xCount+=colorBoxSize;
        }
        xCount=width;
      } else {
        xCount=0;
        yCount+=colorBoxSize;
      }
   //}
  } else {
      console.log("colorCount = "+colorCount+" & the loop has ended");
      console.log("pixbox.length = "+pixbox.length);
      makePixel = false;
  }
}
 

void translateColor(){  
  //clear conversionColorsArray if it is not the first use of translateColor
  conversionColorsArray = new float[0];
  
  for (int i = 0; i < height/colorBoxSize; i++) {
    for (int j = 0; j < width/colorBoxSize; j++) { 
      
      int y = i*colorBoxSize + colorBoxSize/2;
      int x = j*colorBoxSize + colorBoxSize/2;
      int loc = x + y*width;
      
      loadPixels(); 
      float r = red(img.pixels[loc]); 
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      conversionColorsArray = append(conversionColorsArray, r-20);
      conversionColorsArray = append(conversionColorsArray, g-20); 
      conversionColorsArray = append(conversionColorsArray, b-20); 
    }
  }
  matchColors();
}

void matchColors(){
  //clear reformedText if it is not the first use of matchColors
  reformedText = "";
  
  for(int i = 0; i < conversionColorsArray.length; i++){
    for(int j = 0; j < asciiDEC.length; j++){
      if(conversionColorsArray[i] == asciiDEC[j]){
        //println("asciiCHAR[j] = " +asciiCHAR[j]);
        reformedChars = append(reformedChars, asciiCHAR[j]); 
      }
    }
  }
  checkCodeKey();
}

void checkCodeKey(){
  int keyConfirm=0;
  for(int i=0; i<codeKeySplit.length; i++){
    if(codeKeySplit[i] == reformedChars[i]){
      keyConfirm++;
      console.log(reformedChars[i]+" __&  keyConfirm = "+keyConfirm)
    }
  }
  if(keyConfirm == codeKeySplit.length){
    reformedText = join(reformedChars, ""); 
    parseRT = split(reformedText, codeKey); 
    //String[] parseRT = match(reformedText, "b/'''(.*?)'''b/");
//    for (int i=0; i<parseRT.length;i++) {
//    console.log("parseRT"+[i]+" = "+parseRT[i]);
//    }
  }
}

void loadTheImage() {
  img = loadImage(filenameSave);
}

void keyReleased() {
    if (key == 'm'){
      matchCharacters();//function to check text against ascii
    }
    if (key == 's'){
      save("howl2.png");
    }
    if (key == 't'){
      translateColor();
    }
    if (key == 'r'){
      matchColors();
    }
  }
  
  
  
class PixelBox {
  int x = 0;
  int y = 0;
  color collor;
  color centerColor;

  PixelBox(int xin, int yin, color cin, color thisin) {
    x = xin;
    y = yin;
    collor = cin;
    centerColor = thisin;
  }

  void update() {
  }

  void display() {
    fill(collor);
    rect(x, y, colorBoxSize, colorBoxSize);
    fill(centerColor);
    rect(x+5,y+5,pixelSize,pixelSize);
  }

} 
  
  


////////////////////JQUERY FUNCTIONS////////////////////

 $(document).ready(function(){  
    now = new Date();
    hour1 = now.getHours();
    minute1 = now.getMinutes();
    second1 = now.getSeconds();
    month1 = now.getMonth()+1;
    day1 = now.getDate();
    year1 = now.getYear()+ 1900;
    timearray = {month1,"_",day1,"_",year1,"_",hour1,"_",minute1,"_",second1,".png"};
    //timearray = {month1,day1,year1,hour1,minute1,second1,".png"};
    timename = timearray.join("");
            
    //onload, fit giftWrap class to fill window
    var  windowHeight = $(window).height();
    $('.giftWrap').css("height", windowHeight);
    //if window is resized, fit giftWrap class to fill new window size
     $(window).resize(function() {
        windowHeight = (-($(document).width())/2)-60;
          $('.giftWrap').css("height", windowHeight);
    });
    
    $("#textarea").keyup(function () {
    textfill = $(this).val();
    typingCount = textfill.split("");
    $('#tcounter').html("character count: "+typingCount.length);
    console.log(textfill);
    
//    allCharzKeyed = textfill;
//    allCharz = allCharzKeyed.split("");
//      for(i=0; i<allCharz.length; i++){
//         console.log("allCharz"+[i]+" = "+allCharz[i]);
//      }
    }).keyup();
    

    $("#textarea").keydown(function () {
        if (event.keyCode == '13') { 
         if (event.keyCode == '13') { event.preventDefault(); } 
            $(this).val($(this).val()+" ");
        }
    }).keydown();

   
    $("#imageizer").click(function() {
      $(".presentText").text(textfill);
      allCharzKeyed = "123"+textfill+"123";
      allCharz = allCharzKeyed.split("");
      allCharzLength = allCharz.length;
      console.log("allCharzKeyed = " + allCharzKeyed);
       fixit();
       //typedString = allCharz.join("");
       //matchCharacters(allCharz);
       console.log("allCharz = " + allCharz);
    });
    
    function fixit() {
      for (x=0; x<allCharzLength; x++)  {
      // replace all the single, double quotes:
        if (allCharz[x] == "\""){ 
            allCharz[x] = "\"";
        }
      }
      return allCharz;
    }
    
    $('#viewfinder').live('pageshow',function(event){
        console.log("pageload");
        parseText(allCharz);
//        parseText();
//        setTimeout(matchCharacters, 200);
    });
  
    $("#savename").val(timename);
    
    $('#saver').click(function() {
      filenameSave = $("#savename").val();
      console.log("filenameSave = "+ filenameSave);
      save(filenameSave);
    });
    
    //$('#showThisImage').attr({src: "images/"+filenameSave});
    
    $('#ctt').live('pageshow',function(event){
      //loadTheImage();
      translateColor();
      $('#textreadout').val(parseRT[1]);
    });
    
    
    $('#upSlides').cycle({ 
        fx: 'none', 
        timeout: 10, 
        speed: 1000,
     });   
     $('#downSlides').cycle({ 
        fx: 'none', 
        timeout: 10, 
        speed: 1000,
     });   
});



