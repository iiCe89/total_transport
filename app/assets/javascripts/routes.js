$(document).ready(function() {
  var numOfRoutes = $('.route').length;

  $('.route .acordBtn').click(function() {
    var parent = $(this).parent('.route');
    if (parent.hasClass('open')) {
      parent.removeClass('open');
      parent.find('.acord').slideUp();
    } else {
      
      $('.route').each(function(){
        $(this).removeClass('open').find('.acord').slideUp();
      }).promise().done( function(){
        parent.find('.acord').slideDown();
      });
      parent.addClass('open');
    }
  });

  $('#input-cont input[name="from"]').keyup(function() {
    // On input change
    var tempTxt = $( this ).val();
    if ($( this ).val().length > 2) {
      // Only fire if above 3 characters
      var exception = [];
      $('.route .acord li').each(function() {
        // for each list item
        if ($(this).html().toLowerCase().indexOf(tempTxt.toLowerCase()) >= 0) {
          // check if it contains the same text 
          // if so add to id array 
          exception.push($(this).closest('.route').attr('id'));
        } else {
          // if not remove vis class
          $(this).closest('.route').removeClass('vis');
        }
      });
      
      $(exception).each(function(index, item) {
        // after checking all that add the vis class to all that need it
        $('#'+item).addClass('vis');
      });
      $('.route').each(function() {
        // run through all routes - if they dont have the vis class - kill them
        if(!$(this).hasClass('vis')) {
          $(this).slideUp();
        }
      });
    } else {
      $('.route').each(function() {
        // the text is 2 char or below, reveal any hidden routes 
        $(this).slideDown();
        $(this).removeClass('vis');
      });
    }
  });
});