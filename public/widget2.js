// Upload CSS file
var cssId = 'myCss';  // you could encode the css path itself to generate id..
if (!document.getElementById(cssId))
{
    var head  = document.getElementsByTagName('head')[0];
    var link  = document.createElement('link');
    link.id   = cssId;
    link.rel  = 'stylesheet';
    link.type = 'text/css';
    link.href = 'http://localhost:3000/widget.css';
    link.media = 'all';
    head.appendChild(link);
}

function addElement() {
  var newDiv = document.createElement('div');
  newDiv.className = 'follower_widget_frame';
  newDiv.innerHTML = '<h1 class="red_header">Hello world!</h1><p class="strange_text">there is some text</p>';

  document.body.appendChild(newDiv);
}

document.body.onload = addElement;
