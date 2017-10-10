(function ($, $document) {
    "use strict";

    function columnControl()
    {
        var $fields, $numColFieldContainer = null, $numCols = 0;
        var xkColCtrl = $('[data-identifier="xk-colctrl"]');
        
        if (xkColCtrl.length)
        {
            $fields = $('.coral-Form-fieldwrapper', xkColCtrl);

            if ($fields.length)
            {
                $fields.each(function(){
                    var e = $(this);
                    if (e.find('[data-style="not-colctrl"]').length) {
                        e.addClass('excluded');
                    }
                });
            }

            $fields = $('.coral-Form-fieldwrapper:not(.excluded)', xkColCtrl);

            if ($fields.length) {

                toggleFields();

                if ($numColFieldContainer !== null) {
                    $numCols = getVal($numColFieldContainer);
                }

                toggleFields();
            }
        }

        function toggleFields() {
            $fields.each(function(i){
                var $e = $(this);
                if (i > 0) {
                    if ($numCols > 0 && i <= $numCols) {
                        $e.removeClass('hide');
                    }
                    else {
                        $e.addClass('hide');
                        reset($e);
                    }
                }
                else if (i === 0) {
                    $numColFieldContainer = $e;
                }
            });
        }

        function reset(e) {
            e.find('input[type="number"]').attr("value", 0);
        }

        function getVal(e) {
            return e.find('input[type="number"]').val();
        }
    }

    $document.ready(function(){
        setTimeout(columnControl, 101);
    });

    $document.on("dialog-ready", function() {
        setTimeout(columnControl, 101);
    });

    $document.on("change", function() {
        setTimeout(columnControl, 101);
    });

})($, $(document));