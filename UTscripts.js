 $(document).ready(function(){        
        var value,
         allCharz,
         allCharzLength;
                
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
        console.log(textfill);
        }).keyup();
        
/*
        $("#textarea").keydown(function () {
            if (event.keyCode == '13') { 
            if (event.keyCode == '13') { event.preventDefault(); } 
                $(this).val($(this).val()+"|");
            }
        }).keydown();
*/
       
        $("#imageizer").click(function() {
          $(".presentText").text(textfill);
          allCharz = textfill.split("");
           console.log(textfill);
          allCharzLength = allCharz.length;
          console.log(allCharzLength);
           fixit();
           console.log(allCharz);
           typedString = allCharz.join();
        });
        
        function fixit() {
          for (x=0; x<allCharzLength; x++)  {
          // replace all the single, double quotes:
            if (allCharz[x] == "\""){ 
                allCharz[x] = "\\\"";
            }
            if (allCharz[x] == "<br />"){ 
                allCharz[x] = "br";
            }
          }
          return allCharz;
        }
        
        $( '#viewfinder' ).live( 'pageinit',function(event){
            parseText();
            matchCharacters();
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

