(function ( $ ) {

    var busy = false;
    var cnt = 5;
    var feed = 0;


    $.fn.autoload = function( options ) {
        var cont = this;
        if (options.feed)
            feed = options.feed;
        $(window).scroll(function () {
            if ($(window).scrollTop() + $(window).height() > cont.height() && !busy) {
                busy = true;
                api_query({
                    qmethod: "POST",
                    amethod: "news_extra",
                    params: {
                        "loaded": cnt,
                        "id": options.id,
                        "feed" : feed
                    },
                    success: function (resp) {
                        if (resp == "") {
                            console.log("ENDED")
                            window.onscroll = function() {}
                            return;   
                        }
                        cont.append(resp[0]);
                        cnt+=5;
                        busy=false;
                        /* init galleries in added posts */
                        $("[data-gallery-list]").each(function () { //TO-DO: performance (fix reinit existing)
                            gallery_initialize(this);
                        });
                    },
                    fail: "standart"
                });
            }
            
        });
    };
 
}( jQuery ));