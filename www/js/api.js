console.info("Api.js file loaded");

function api_query(s) {
    console.info("Api method '%s' called.", s.amethod)
    $.ajax({
        type: s.qmethod,
        url: "/api/api.php?m="+s.amethod,
        dataType: "json",
        data: s.params
    }).done(function (data) {
        if (data.type == "success") {
            if (s.success)
                s.success(data.response, data);
        } else if (data.type == "error") 
            if (s.fail && typeof(s.fail) === "function")
                s.fail(data.response, data);
            else if (s.fail == "standart")
                for (i=0;i<data.response.length;++i)
                    alert(data.response[i]);
    }).fail(function (jqXHR) {
        if (s.fail && typeof(s.fail) === "function")
            s.fail(undefined, jqXHR);
        else if (s.fail == "standart")
            alert("Произошла неожиданная ошибка, мы уже ее исправляем.");
    });
}