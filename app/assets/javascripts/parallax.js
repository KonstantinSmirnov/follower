$(window).on('scroll', function() {
    responsive = $(window).width();
    if (responsive >= 768) {
        parallax();
    }
});

var parallax = debounce(function() {
    no_of_elements = 0;
    $('.parallax').each(function() {
        var $elem = $(this);

        if (isElementInViewport($elem)) {
            var parent_top = $elem.offset().top;
            var window_bottom = $(window).scrollTop();
            var $image = $elem.find('.parallax-background-image')
            var $oVal = ((window_bottom - parent_top) / 3);
            $image.css('margin-top', $oVal + 'px');
        }
    });
}, 6)

function debounce(func, wait, immediate) {
    var timeout;
    return function() {
        var context = this,
            args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            timeout = null;
            if (!immediate) func.apply(context, args);
        }, wait);
        if (immediate && !timeout) func.apply(context, args);
    };
};


function isElementInViewport(elem) {
    var $elem = $(elem);

    // Get the scroll position of the page.
    var scrollElem = ((navigator.userAgent.toLowerCase().indexOf('webkit') != -1) ? 'body' : 'html');
    var viewportTop = $(scrollElem).scrollTop();
    var viewportBottom = viewportTop + $(window).height();

    // Get the position of the element on the page.
    var elemTop = Math.round($elem.offset().top);
    var elemBottom = elemTop + $elem.height();

    return ((elemTop < viewportBottom) && (elemBottom > viewportTop));
}
