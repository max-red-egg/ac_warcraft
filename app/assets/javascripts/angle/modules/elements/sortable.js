// HTML5 Sortable demo
// -----------------------------------

(function(window, document, $, undefined) {

    if (typeof sortable === 'undefined') return;

    $(function() {

        sortable('.sortable', {
            forcePlaceholderSize: true,
            placeholder: '<div class="box-placeholder p0 m0"><div></div></div>'
        });

    });

})(window, document, window.jQuery);