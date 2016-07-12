// ToDo: change slideUp / sildeDown to a CSS animation

$(document).ready(function() {
  var activeDots = 0;
  var numOfStops = $('.stop').length;
  var stopNumber = 0;
  var pkupTxt = 'Select Pick Up Location';
  var drpfTxt = 'Select Drop Off Location';
  var cnfmTxt = 'Confirm Route';
  $('.stop').last().addClass('lastChild');

  // If a stop is clicked
  $('.stop').click(function() {
    if (activeDots == 2 && $(this).hasClass('firstStop')) {
      // ensure that the first one cannot be clicked if there are two clicked
      event.stopPropagation();
    } else if ($(this).hasClass('lastChild')) {
      // ensure that the last once cannot be clicked
      event.stopPropagation();
    } else {
      // If it has already been clicked - Revert
      if ($(this).hasClass('active')) {
        // lower the current global of active dots
        activeDots--;
        // remove its active class
        $(this).removeClass('active');
        // remove the alive class from its child
        $(this).find('.stop-dot-line').removeClass('alive');
        $(this).find('.stop-dot-line').removeAttr('style');
        if (activeDots == 1) {
          // If there is still another dot active move the global trackers onto that stop
          $('h1').html(drpfTxt);
          clearStopLine();
          stopNumber = $('.stop.active').attr('id');
          $('.stop.active').find('.stop-dot-line').addClass('alive');
          // reveal all stops above
          for (var i = numOfStops; i >= (parseInt($(this).attr('id')) + 1); i--) {
            $('#'+i).slideDown(); // IMPROVE - use css rather than jquery for this animation
          }
          // remove sub stop class from everything
          $('.stop').each(function(){
            $(this).removeClass('subStop');
          });
          $('#confirmation').slideUp(250);
        } else {
          // if there is no other stop remaining active reset to the start
          $('h1').html(pkupTxt);
          $('.firstStop').removeClass('firstStop');
          clearStopLine();
          stopNumber = 0;
          $('.lastChildOff').addClass('lastChild');
          $('.lastChildOff').removeClass('lastChildOff');
          // reveal any hidden stops
          $('.stop').each(function(){
            $(this).slideDown(); // IMPROVE - use css rather than jquery for this animation
          });
        }
      } else {
        // if it is not active - Make active
        if (activeDots < 2) {
          drawStopLine(stopNumber, parseInt($(this).attr('id')));
          // Only allow this if no more than 2 dots are active
          activeDots++;
          $('.lastChild').addClass('lastChildOff');
          $('.lastChild').removeClass('lastChild');
          $(this).addClass('active');
          
          if (activeDots == 1) {
            // if its the first dot store the globals and set title
            $('h1').html(drpfTxt);
            $(this).find('.stop-dot-line').addClass('alive');
            $(this).addClass('firstStop');
            // hide any stops above the clicked dot
            for (var i = (parseInt($(this).attr('id')) - 1); i >= 0; i--) {
              $('#'+i).slideUp(); // IMPROVE - use css rather than jquery for this animation
            }
            stopNumber = parseInt($(this).attr('id'));
          } else if(activeDots == 2) {
            // both stops have been chosen
            $('h1').html(cnfmTxt);
            setTimeout(function(){
              $('#confirmation').slideDown(500);
            }, 100);
            // hide any stop below the second stop clicked
            for (var i = numOfStops; i >= (parseInt($(this).attr('id')) + 1); i--) {
              $('#'+i).slideUp(); // IMPROVE - use css rather than jquery for this animation
            }
            // add class to all sub stops 
            setTimeout(function(){
              $('.stop').each(function(){
                if (!$(this).hasClass('active')) {
                  $(this).addClass('subStop');
                }
              });
            }, 100);
          }
        }
      }
    }
  });



  if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
    //IF MOBILE IT DOES NOT DO HOVER EFFECTS

  } else {
    $('.stop').hover(function() {
      // check if its not the last stop
      if ($(this).hasClass('lastChild')) {
        // it is the last stop
        $(this).addClass('lastHover');
      } else {
        // if on hover there is only one dot draw a line from the first dot to the current hover
        if (stopNumber != 0 && activeDots == 1) {
          var potentialStop = parseInt($(this).attr('id'));
          drawStopLine(stopNumber, potentialStop);
        }
        if (activeDots == 2 && $(this).hasClass('firstStop')) {
        // remove hover effect from the first stop if two stops are clicked
          $(this).css({'cursor' :"default"});
        } else {
          // only add the hover state if there is less than 2 dots active
          if (activeDots >= 2) {
            if ($(this).hasClass('active')) {
              $(this).addClass('hover');
            }
          } else {
            $(this).addClass('hover');
          }
        }
      }

    // reset this on mouse out
    }, function() {
        $(this).css({'cursor' :"pointer"});
        $(this).removeClass('hover');
        $(this).removeClass('lastHover');
        //clearStopLine();
    });
  }
});


function drawStopLine(begin, end) {
  if (begin == end) {
    // you are hovering on the active one!
    clearStopLine();
  } else {
    var diff = begin - end;
    if (diff < 0) {
      diff = diff*-1;
    }
    if (begin < end) {
      // it will be lower
      $('.stop-dot-line.alive').css('height', (diff*60));
      $('.stop-dot-line.alive').css('top', 30);
    } else {
      // it will be higher
      //$('.stop-dot-line.alive').css('top', -30);
    }
  }
}

function clearStopLine() {
  $('.stop-dot-line.alive').removeAttr('style');
  $('.stop-dot-line.alive').css('height', '0');
}