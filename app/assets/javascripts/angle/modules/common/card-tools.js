// Module: card-tools
// -----------------------------------

/**
 * Dismiss cards
 * [data-tool="card-dismiss"]
 *
 * Requires animo.js
 */
(function($, window, document) {
    'use strict';

    var cardSelector = '[data-tool="card-dismiss"]',
        removeEvent = 'card.remove',
        removedEvent = 'card.removed';

    $(document).on('click', cardSelector, function() {

        // find the first parent card
        var parent = $(this).closest('.card');
        var deferred = new $.Deferred();

        // Trigger the event and finally remove the element
        parent.trigger(removeEvent, [parent, deferred]);
        // needs resolve() to be called
        deferred.done(removeElement);

        function removeElement() {
            parent.animo({ animation: 'bounceOut' }, destroyCard);
        }

        function destroyCard() {
            var col = parent.parent();

            $.when(parent.trigger(removedEvent, [parent]))
                .done(function() {
                    parent.remove();
                    // remove the parent if it is a row and is empty and not a sortable (portlet)
                    col
                        .trigger(removedEvent) // An event to catch when the card has been removed from DOM
                        .filter(function() {
                            var el = $(this);
                            return (el.is('[class*="col-"]:not(.sortable)') && el.children('*').length === 0);
                        }).remove();
                });
        }
    });

}(jQuery, window, document));


/**
 * Collapse cards
 * [data-tool="card-collapse"]
 *
 * Also uses browser storage to keep track
 * of cards collapsed state
 */
(function($, window, document) {
    'use strict';
    var cardSelector = '[data-tool="card-collapse"]',
        storageKeyName = 'jq-cardState';

    // Prepare the card to be collapsable and its events
    $(cardSelector).each(function() {
        // find the first parent card
        var $this = $(this),
            parent = $this.closest('.card'),
            wrapper = parent.find('.card-wrapper'),
            collapseOpts = { toggle: false },
            iconElement = $this.children('em'),
            cardId = parent.attr('id');

        // if wrapper not added, add it
        // we need a wrapper to avoid jumping due to the paddings
        if (!wrapper.length) {
            wrapper =
                parent.children('.card-heading').nextAll() //find('.card-body, .card-footer')
                .wrapAll('<div/>')
                .parent()
                .addClass('card-wrapper');
            collapseOpts = {};
        }

        // Init collapse and bind events to switch icons
        wrapper
            .collapse(collapseOpts)
            .on('hide.bs.collapse', function() {
                setIconHide(iconElement);
                saveCardState(cardId, 'hide');
                wrapper.prev('.card-heading').addClass('card-heading-collapsed');
            })
            .on('show.bs.collapse', function() {
                setIconShow(iconElement);
                saveCardState(cardId, 'show');
                wrapper.prev('.card-heading').removeClass('card-heading-collapsed');
            });

        // Load the saved state if exists
        var currentState = loadCardState(cardId);
        if (currentState) {
            setTimeout(function() { wrapper.collapse(currentState); }, 50);
            saveCardState(cardId, currentState);
        }

    });

    // finally catch clicks to toggle card collapse
    $(document).on('click', cardSelector, function() {

        var parent = $(this).closest('.card');
        var wrapper = parent.find('.card-wrapper');

        wrapper.collapse('toggle');

    });

    /////////////////////////////////////////////
    // Common use functions for card collapse //
    /////////////////////////////////////////////
    function setIconShow(iconEl) {
        iconEl.removeClass('fa-plus').addClass('fa-minus');
    }

    function setIconHide(iconEl) {
        iconEl.removeClass('fa-minus').addClass('fa-plus');
    }

    function saveCardState(id, state) {
        var data = $.localStorage.get(storageKeyName);
        if (!data) { data = {}; }
        data[id] = state;
        $.localStorage.set(storageKeyName, data);
    }

    function loadCardState(id) {
        var data = $.localStorage.get(storageKeyName);
        if (data) {
            return data[id] || false;
        }
    }


}(jQuery, window, document));


/**
 * Refresh cards
 * [data-tool="card-refresh"]
 * [data-spinner="standard"]
 */
(function($, window, document) {
    'use strict';
    var cardSelector = '[data-tool="card-refresh"]',
        refreshEvent = 'card.refresh',
        whirlClass = 'whirl',
        defaultSpinner = 'standard';

    // method to clear the spinner when done
    function removeSpinner() {
        this.removeClass(whirlClass);
    }

    // catch clicks to toggle card refresh
    $(document).on('click', cardSelector, function() {
        var $this = $(this),
            card = $this.parents('.card').eq(0),
            spinner = $this.data('spinner') || defaultSpinner;

        // start showing the spinner
        card.addClass(whirlClass + ' ' + spinner);

        // attach as public method
        card.removeSpinner = removeSpinner;

        // Trigger the event and send the card object
        $this.trigger(refreshEvent, [card]);

    });

}(jQuery, window, document));