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

// Initiate global variables
var testVariable;

// Elements
// Collapse widget on the right
function collapseButton() {
  var collapseButton = document.createElement('button');
  collapseButton.id = 'follower_widget_collapse_button';
  collapseButton.innerHTML = '>';
  collapseButton.onclick = function(){
    symbol = document.getElementById('follower_widget_collapse_button').innerHTML;
    if (symbol == '&gt;') {
      document.getElementById('follower_widget_root').setAttribute('style','right:-300px !important;');
      document.getElementById('follower_widget_collapse_button').innerHTML = '<';
    } else {
      document.getElementById('follower_widget_root').setAttribute('style','right:0 !important;');
      document.getElementById('follower_widget_collapse_button').innerHTML = '>';
    }
  };
  document.getElementById('follower_widget_root').appendChild(collapseButton);
};

function widgetLogo() {
  var logo = document.createElement('div');
  logo.id = 'follower_widget_logo';
  logo.innerHTML = '<h1>Follower</h1>';
  document.getElementById('follower_widget_root').appendChild(logo);
};

function widgetDescription() {
  var description = document.createElement('div');
  description.id = 'follower_widget_description';
  description.innerHTML = '<p>Maecenas sed diam eget risus varius blandit sit amet non magna. Maecenas faucibus mollis interdum.</p>';
  document.getElementById('follower_widget_root').appendChild(description);
};

function widgetSetup() {
  var widgetSetup = document.createElement('div');
  widgetSetup.id = 'follower_widget_setup';
  widgetSetup.innerHTML = '<h5>Select next elements on your page:</h5>';
  document.getElementById('follower_widget_root').appendChild(widgetSetup);
  searchElementBlock('Item price', 'follower_widget_block_item_price');
  searchElementBlock('Item image', 'follower_widget_block_item_image');
  searchElementBlock('Item link', 'follower_widget_block_item_link');
  submitButton();
}

function searchElementBlock(elementName, elementId) {
  var block = document.createElement('div');
  block.className = 'follower_widget_setup_block';
  block.id = elementId;
  block.innerHTML = elementName;

  var button = document.createElement('button');
  button.className = 'follower_widget_btn follower_widget_btn_small';
  button.innerHTML = 'Search';
  button.onclick = function() {
    document.getElementById(elementId).getElementsByClassName('follower_widget_indicator')[0].setAttribute('style','background-color:blue !important;');
  };

  var indicator = document.createElement('span');
  indicator.className = 'follower_widget_indicator';

  block.appendChild(button);
  block.appendChild(indicator);
  document.getElementById('follower_widget_setup').appendChild(block);
}


function submitButton() {
  var submitButton = document.createElement('button');
  submitButton.id = 'follower_widget_submit';
  submitButton.className = 'follower_widget_btn follower_widget_btn_center follower_widget_btn_primary';
  submitButton.innerHTML = 'Submit';
  submitButton.onclick = function() {
    alert('Confirmed!');
  }
  document.getElementById('follower_widget_setup').appendChild(submitButton);
}

// Log out and close widget
function logOutButton() {
  var newButton = document.createElement('button');
  newButton.className = 'follower_widget_btn follower_widget_btn_center follower_widget_btn_default';
  newButton.innerHTML = 'Log Out';
  newButton.id = 'widget_log_out';
  newButton.onclick = function() {
    if (window.confirm("Are you sure to close follower?")) {
      deleteCookie('hello_world_cookie');
    };
  };
  document.getElementById('follower_widget_root').appendChild(newButton);
}

function addRootElement() {
  var newDiv = document.createElement('div');
  newDiv.id = 'follower_widget_root';
  newDiv.className = 'follower_widget_position_right'
  newDiv.innerHTML = '';
  document.body.appendChild(newDiv);
  collapseButton();
  widgetLogo();
  widgetDescription();
  widgetSetup();
  logOutButton();
}
// END

// FUNCTIONS
//Initiates the widget
function initFollower() {
  testVariable = 'HELLO WORLD!';
};

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
}

// FOLLOWER CHECKING ELEMENTS
function checkingElements(e) {
  //Disable clicking function
  document.body.onclick = null;

  e.preventDefault();
  var elementMouseIsOver, old_style, x, y;
  x = e.clientX;
  y = e.clientY;
  elementMouseIsOver = document.elementFromPoint(x, y);
  //document.getElementById('follower_element_id').innerHTML = elementMouseIsOver.id;
  old_style = elementMouseIsOver.style["boxShadow"];
  elementMouseIsOver.style["boxShadow"] = "0 0 15px #EC5616";
  return setTimeout((function() {
    return elementMouseIsOver.style["boxShadow"] = old_style;
  }), 1000);
};

$(document).ready( function () {
  initFollower();
  addRootElement();

  document.body.onclick = function(e) {
    checkingElements(e);
  }
});

//window.onload = function() {}
