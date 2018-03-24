// MARKDOWN DOCS
// -----------------------------------


(function(window, document, $, undefined) {

    // DEPRECATED: FLATDOC will be removed in following versions
    // unless it starts supporting jQuery v3
    $.fn.andSelf = function() {
        return this.addBack(); // patch to support jquery v3
    }

    $(function() {

        $('.flatdoc').each(function() {

            Flatdoc.run({

                fetcher: Flatdoc.file('server/documentation/readme.md'),

                // Setup custom element selectors (markup validates)
                root: '.flatdoc',
                menu: '.flatdoc-menu',
                title: '.flatdoc-title',
                content: '.flatdoc-content'

            });

        });

    });

})(window, document, window.jQuery);