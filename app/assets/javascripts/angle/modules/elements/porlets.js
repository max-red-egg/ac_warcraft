/**=========================================================
 * Module: portlet.js
 * Drag and drop any card to change its position
 * The Selector should could be applied to any object that contains
 * card, so .col-* element are ideal.
 =========================================================*/

(function($, window, document) {
    'use strict';

    // Component is NOT optional
    if (!$.fn.sortable) return;

    var Selector = '[data-toggle="portlet"]',
        storageKeyName = 'jq-portletState';

    $(function() {

        $(Selector).sortable({
            connectWith:          Selector,
            items:                'div.card',
            handle:               '.portlet-handler',
            opacity:              0.7,
            placeholder:          'portlet box-placeholder',
            cancel:               '.portlet-cancel',
            forcePlaceholderSize: true,
            iframeFix:            false,
            tolerance:            'pointer',
            helper:               'original',
            revert:               200,
            forceHelperSize:      true,
            update:               savePortletOrder,
            create:               loadPortletOrder
        })
        // optionally disables mouse selection
        //.disableSelection()
        ;

    });

    function savePortletOrder(event, ui) {

        var data = $.localStorage.get(storageKeyName);

        if (!data) { data = {}; }

        data[this.id] = $(this).sortable('toArray');

        if (data) {
            $.localStorage.set(storageKeyName, data);
        }

    }

    function loadPortletOrder() {

        var data = $.localStorage.get(storageKeyName);

        if (data) {

            var porletId = this.id,
                cards = data[porletId];

            if (cards) {
                var portlet = $('#' + porletId);

                $.each(cards, function(index, value) {
                    $('#' + value).appendTo(portlet);
                });
            }

        }

    }

}(jQuery, window, document));