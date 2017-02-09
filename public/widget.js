jQuery.loadScript = function (url, callback) {
  jQuery.ajax({
    url: url,
    dataType: 'script',
    success: callback,
    async: true
  })
}

var hash = '';

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

console.log(getParameterByName('hello_world'));

hash = getParameterByName('hello_world');

if (hash == 'welcome') {
    $.loadScript('http://localhost:3000/widget2.js', function() {
      // This code executes in case of success:
      //alert('another js file has been loaded');
    })
}
