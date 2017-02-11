// Upload CSS file
var cssId = 'myCss';  // you could encode the css path itself to generate id..
if (!document.getElementById(cssId))
{
    var head  = document.getElementsByTagName('head')[0];
    var link  = document.createElement('link');
    link.id   = cssId;
    link.rel  = 'stylesheet';
    link.type = 'text/css';
    link.href = 'http://localhost:3000/widget/css/widget.css';
    link.media = 'all';
    head.appendChild(link);
}
// END

function addRootElement() {
  var newDiv = document.createElement('div');
  newDiv.className = 'follower_widget_frame';
  newDiv.innerHTML = '<div id="widget_root"><strong>Follower widget</strong><div id="follower_element_id">ID</div></div>';

  document.body.appendChild(newDiv);
  addLogOutButton();
}

function addLogOutButton() {
  var newButton = document.createElement('button');
  newButton.className = 'follower_widget_btn';
  newButton.innerHTML = 'Log Out';
  newButton.id = 'widget_log_out';

  document.getElementById('widget_root').appendChild(newButton);
}

// Remove param from URL address
function removeURLParam(key, sourceURL) {
    var rtn = sourceURL.split("?")[0],
        param,
        params_arr = [],
        queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
    if (queryString !== "") {
        params_arr = queryString.split("&");
        for (var i = params_arr.length - 1; i >= 0; i -= 1) {
            param = params_arr[i].split("=")[0];
            if (param === key) {
                params_arr.splice(i, 1);
            }
        }
        rtn = rtn + "?" + params_arr.join("&");
    }
    return rtn;
};

function deleteCookie(name) {
  document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
  window.location.href = removeURLParam('hello_world', window.location.href);
  alert('You logged out.');
}


// FOLLOWER CHECKING ELEMENTS
function checkingElements(e) {
  e.preventDefault();
  var elementMouseIsOver, old_style, x, y;
  x = e.clientX;
  y = e.clientY;
  elementMouseIsOver = document.elementFromPoint(x, y);
  document.getElementById('follower_element_id').innerHTML = elementMouseIsOver.id;
  old_style = elementMouseIsOver.style.background;
  elementMouseIsOver.style.background = 'red';
  return setTimeout((function() {
    return elementMouseIsOver.style.background = old_style;
  }), 1000);
}

$(document).ready( function () {
  addRootElement()
  document.getElementById('widget_log_out').onclick = function() {
    deleteCookie('hello_world_cookie');
  }

  document.onclick = function(e) {
    //checkingElements(e);
  }
});

//window.onload = function() {}
