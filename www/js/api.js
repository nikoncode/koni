console.info("Api.js file loaded");

function api_query(s) {
    console.info("Api method '%s' called.", s.amethod)
    $.ajax({
        type: s.qmethod,
        url: "/api/api.php?m="+s.amethod,
        dataType: "json",
        data: s.params
    }).done(function (data) {
            var respon = '';
        if (data.type == "success") {
            if (s.success)
                s.success(data.response, data);
        } else if (data.type == "error") 
            if (s.fail && typeof(s.fail) === "function")
                s.fail(data.response, data);
            else if (s.fail == "standart"){
                for (i=0;i<data.response.length;++i) respon += data.response[i]+'<br/>';
                var mdl = $("#modal-info");
                mdl.find('#info-block').html(respon);
                mdl.modal("show");
                setTimeout(function(){
                    mdl.modal('hide');
                },4000);
                //alert(respon);
            }

    }).fail(function (jqXHR) {
        if (s.fail && typeof(s.fail) === "function")
            s.fail(undefined, jqXHR);
        else if (s.fail == "standart" && jqXHR.status != 0)
            alert("Произошла неожиданная ошибка, мы уже ее исправляем.");
    });
}

$(function () { //to tab load in startup
    if (location.hash !== '')
        $('a[href="' + location.hash + '"]').tab('show');
    return $('a[data-toggle="tab"]').on('shown', function(e) {
        return location.hash = $(e.target).attr('href').substr(1);
    });
});