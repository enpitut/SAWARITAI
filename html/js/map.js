var locations = [
  [35.6722764, 139.6956099, 80, "<b>代々木公園</b><p>現在のペットボトル本数：42本<br />もうすぐ回収！<br />最終回収日時：11/17 16:30</p>"],
  [35.6745095, 139.7148602, 0, "<b>明治神宮野球場</b><p>現在のペットボトル本数：3本<br />最終回収日時：11/18 15:48</p>"],
  [35.6591041, 139.7015533, 20, "<b>渋谷ヒカリエ</b><p>現在のペットボトル本数：12本<br />最終回収日時：11/18 12:23</p>"]
];
var icon0 = new google.maps.MarkerImage('img/s_label0-20.png',
    new google.maps.Size(29,42),
    new google.maps.Point(0,0)
  );
  var icon20 = new google.maps.MarkerImage('img/s_label20-40.png',
    new google.maps.Size(29,42),
    new google.maps.Point(0,0)
  );
  var icon40 = new google.maps.MarkerImage('img/s_label40-60.png',
    new google.maps.Size(31,42),
    new google.maps.Point(0,0)
  );
  var icon60 = new google.maps.MarkerImage('img/s_label60-80.png',
    new google.maps.Size(29,42),
    new google.maps.Point(0,0)
  );
  var icon80 = new google.maps.MarkerImage('img/s_label80-100.png',
    new google.maps.Size(29,42),
    new google.maps.Point(0,0)
  );
var markers = [];
var infoWindows = [];

var currentWindow = null;

function initialize() {
  var latlng = new google.maps.LatLng(35.6674826,139.7004379);
  var myOptions = {
    zoom: 14,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false,
    mapTypeControl: false,
    navigationControlOptions: {
      style: google.maps.NavigationControlStyle.SMALL
    }
  };
  var map = new google.maps.Map(document.getElementById('map_canvas'), myOptions);

  for (var i = 0; i < locations.length; i++){
    var infoWindowOptions = {
      content: locations[i][3]
    };
    infoWindows[i] = new google.maps.InfoWindow(infoWindowOptions);

    switch(locations[i][2]) {
      case 0:
        icon = icon0;
        break;
      case 20:
        icon = icon20;
        break;
      case 40:
        icon = icon40;
        break;
      case 60:
        icon = icon60;
        break;
      case 80:
        icon = icon80;
        break;
    }

    markers[i] = new google.maps.Marker({
      position: new google.maps.LatLng(locations[i][0], locations[i][1]),
      map: map,
      icon: icon
    });
  }
  google.maps.event.addListener(markers[0], "click", function(){
    if (currentWindow) {
      currentWindow.close();
    }
    infoWindows[0].open(map, markers[0]);
    currentWindow = infoWindows[0];
  });
  google.maps.event.addListener(markers[1], "click", function(){
    if (currentWindow) {
      currentWindow.close();
    }
    infoWindows[1].open(map, markers[1]);
    currentWindow = infoWindows[1];
  });
  google.maps.event.addListener(markers[2], "click", function(){
    if (currentWindow) {
      currentWindow.close();
    }
    infoWindows[2].open(map, markers[2]);
    currentWindow = infoWindows[2];
  });
  // var markerPos1 = new google.maps.LatLng(35.6722764,139.6956099);
  // createMarker(map, markerPos1, 1, "<b>代々木公園</b><p>現在のペットボトル本数：42本<br>もうすぐ回収！<br>最終回収日時：11/17 16:30</p>");
  // var markerPos2 = new google.maps.LatLng(35.6745095,139.7148602);
  // createMarker(map, markerPos2, 2, "<b>明治神宮野球場</b><p>現在のペットボトル本数：3本<br>最終回収日時：11/18 15:48</p>");
  // var markerPos3 = new google.maps.LatLng(35.6591041,139.7015533);
  // createMarker(map, markerPos3, 3, "<b>渋谷ヒカリエ</b><p>現在のペットボトル本数：12本<br>最終回収日時：11/18 12:23</p>");
}
google.maps.event.addDomListener(window, 'load', initialize);
google.maps.event.addDomListener(window, 'resize',function(){ map.panTo(mapOptions.center); });

// function createMarker(map, latlng, id, text) {

//   var icon0 = new google.maps.MarkerImage('img/s_label0-20.png',
//     new google.maps.Size(29,42),
//     new google.maps.Point(0,0)
//   );
//   var icon20 = new google.maps.MarkerImage('img/s_label20-40.png',
//     new google.maps.Size(29,42),
//     new google.maps.Point(0,0)
//   );
//   var icon40 = new google.maps.MarkerImage('img/s_label40-60.png',
//     new google.maps.Size(31,42),
//     new google.maps.Point(0,0)
//   );
//   var icon60 = new google.maps.MarkerImage('img/s_label60-80.png',
//     new google.maps.Size(29,42),
//     new google.maps.Point(0,0)
//   );
//   var icon80 = new google.maps.MarkerImage('img/s_label80-100.png',
//     new google.maps.Size(29,42),
//     new google.maps.Point(0,0)
//   );
//   switch(id) {
//     case 1:
//       icon = icon80;
//       break;
//     case 2:
//       icon = icon0;
//       break;
//     case 3:
//       icon = icon20;
//       break;
//   }

//   var infoWindowOptions = {
//     content: text,
//   };
//   var infoWindow = new google.maps.InfoWindow(infoWindowOptions);

//   var markerOptions = {
//     position: latlng,
//     map: map,
//     icon: icon
//   };
//   var marker = new google.maps.Marker(markerOptions);
//   google.maps.event.addListener(marker, "click", function(){
//     if (currentWindow) {
//       currentWindow.close();
//     }
//     infoWindow.open(map, marker);
//     currentWindow = infoWindow;
//   });
//   return marker;
// }
// google.maps.event.addDomListener(window, 'load', initialize);
// google.maps.event.addDomListener(window, 'resize',function(){ map.panTo(mapOptions.center); });


$(function() {
  $(".span4 a").click(function() {
    for(var i = 0; i < markers.length; i++) {
      if(i == $(this).attr("data-id")) {
        infoWindows[i].open(map, markers[i]);
      } else {
        infoWindows[i].close();
      }
    }
    return false;
  });
});