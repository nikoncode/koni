  $(function() {
    $( "#city-dist" ).slider({
      range: true,
      min: 0,
      max: 500,
      values: [ 0, 500 ],
      slide: function( event, ui ) {
		var CustomAmount =  "От " + ui.values[ 0 ] + " км. до " + ui.values[ 1 ] + " км.";
        document.getElementById('city-dist-amount').innerHTML = CustomAmount;
      }
    });
	var startAmount =   "От " + $( "#city-dist" ).slider( "values", 0 ) +
      " км. до " + $( "#city-dist" ).slider( "values", 1 ) + " км.";
    document.getElementById('city-dist-amount').innerHTML = startAmount;
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
        $("[name=amount_start]").val(ui.values[0]);
        $("[name=amount_end]").val(ui.values[1]);
      }
    });
	var startAmount =   "От " + $( "#h-with-trainer" ).slider( "values", 0 ) +
      " руб. до " + $( "#h-with-trainer" ).slider( "values", 1 ) + " руб.";
      $("[name=amount_start]").val($( "#h-with-trainer" ).slider( "values", 0 ));
      $("[name=amount_end]").val($( "#h-with-trainer" ).slider( "values", 1 ));
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