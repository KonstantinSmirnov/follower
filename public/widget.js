jQuery.loadScript = function (url, contentType, callback) {
  jQuery.ajax({
    url: url,
    dataType: 'script',
    contentType: contentType,
    success: callback,
    async: true
  })
}

// Get hash from request parameters
function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}
// END

// Put session hash to cookies
function createCookie(name,value,days) {
    var expires = "";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days*24*60*60*1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + value + expires + "; path=/";
}

// Get session hash from cookies
function readCookie(name) {
  var nameEq = name + "=";
  var ca = document.cookie.split(';');
  for (var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
    if (c.indexOf(nameEq) == 0) return c.substring(nameEq.length,c.length);
  }
  return null;
}

if (readCookie('hello_world_cookie') == 'welcome') {
  //should send session hash to B/E and verify it
  $.loadScript('http://localhost:3000/widget/js/follower_widget.js', 'text/javascript', function() {
  });
} else if (getParameterByName('hello_world') == 'welcome') {
  //should send session hash to B/E and verify it. Additionally receives hash for session
  $.loadScript('http://localhost:3000/widget/js/follower_widget.js', 'text/javascript', function() {
    createCookie('hello_world_cookie', 'welcome', 1)
  });
}
