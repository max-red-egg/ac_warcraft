// Demo Cards
// -----------------------------------


(function(window, document, $, undefined) {

    $(function() {

        /**
         * This functions show a demonstration of how to use
         * the card tools system via custom event.
         */

        $('.card.card-demo')
            .on('card.refresh', function(e, card) {

                // perform any action when a .card triggers a refresh event
                setTimeout(function() {

                    // when the action is done, just remove the spinner class
                    card.removeSpinner();

                }, 3000);

            })
            .on('hide.bs.collapse', function(event) {

                console.log('Card Collapse Hide');

            })
            .on('show.bs.collapse', function(event) {

                console.log('Card Collapse Show');

            })
            .on('card.remove', function(event, card, deferred) {
                console.log('Removing Card');
                // Call resolve() to continue removing the card
                // perform checks to avoid removing card if some user action is required
                deferred.resolve();
            })
            .on('card.removed', function(event, card) {

                console.log('Removed Card');

            });

    });


})(window, document, window.jQuery);