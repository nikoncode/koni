  $(function() {
    $( "#user-age" ).slider({
      range: true,
      min: 1,
      max: 200,
      values: [ 1, 200 ],
      slide: function( event, ui ) {
		var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " лет";
        document.getElementById('user-age-amount').innerHTML = CustomAmount;
      }
    });
	var startAmount =   "От " + $( "#user-age" ).slider( "values", 0 ) +
      " до " + $( "#user-age" ).slider( "values", 1 ) + " лет";
    document.getElementById('user-age-amount').innerHTML = startAmount;
  }  );
  
$(function() {
  $( "#h-with-trainer" ).slider({
      range: true,
      min: 0,
      max: 10000,
      values: [ 0, 10000 ],
      slide: function( event, ui ) {
		var CustomAmount =  "От " + ui.values[ 0 ] + " руб. до " + ui.values[ 1 ] + " руб.";
        document.getElementById('h-with-trainer-amount').innerHTML = CustomAmount;
      }
    });
	var startAmount =   "От " + $( "#h-with-trainer" ).slider( "values", 0 ) +
      " руб. до " + $( "#h-with-trainer" ).slider( "values", 1 ) + " руб.";
    document.getElementById('h-with-trainer-amount').innerHTML = startAmount;
  } );  
  
  $(function() {
  $( "#h-without-trainer" ).slider({
      range: true,
      min: 0,
      max: 10000,
      values: [ 0, 10000 ],
      slide: function( event, ui ) {
		var CustomAmount =  "От " + ui.values[ 0 ] + " руб. до " + ui.values[ 1 ] + " руб.";
        document.getElementById('h-without-trainer-amount').innerHTML = CustomAmount;
      }
    });
	var startAmount =   "От " + $( "#h-without-trainer" ).slider( "values", 0 ) +
      " руб. до " + $( "#h-without-trainer" ).slider( "values", 1 ) + " руб.";
    document.getElementById('h-without-trainer-amount').innerHTML = startAmount;
  } );  
  
  $(function() {
  $( "#wait-h" ).slider({
      range: true,
      min: 0,
     max: 10000,
      values: [ 0, 10000 ],
      slide: function( event, ui ) {
		var CustomAmount =  "От " + ui.values[ 0 ] + " руб. до " + ui.values[ 1 ] + " руб.";
        document.getElementById('wait-h-amount').innerHTML = CustomAmount;
      }
    });
	var startAmount =   "От " + $( "#wait-h" ).slider( "values", 0 ) +
      " руб. до " + $( "#wait-h" ).slider( "values", 1 ) + " руб.";
    document.getElementById('wait-h-amount').innerHTML = startAmount;
  } );  