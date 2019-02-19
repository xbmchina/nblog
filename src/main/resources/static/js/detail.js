$(function(){

    $(".headerpage").load("header.html");
    $(".footerpage").load("footer.html");
    var params = getQueryString();
    // 高亮显示代码
    var rendererMD = new marked.Renderer();
    marked.setOptions({
        renderer: rendererMD,
        gfm: true,
        tables: true,
        breaks: false,
        pedantic: false,
        sanitize: false,
        smartLists: true,
        smartypants: false
    });
    var markdownString = '```js\n console.log("hello"); \n```';
    marked.setOptions({
        highlight: function (code) {
            return hljs.highlightAuto(code).value;
        }
    });


    $.ajax({
        type: "GET",
        url: "/article/detail",
        dataType:'json',
        data: {id:params[0]},//也可以是字符串链接"id=1001"，建议用对象
        success: function(result){
            if (result.code == 200) {
                $("#content").html(marked(result.data.content));
            }
        }
    });



    function getQueryString() {
        var url = location.href;
        var paraString = url.substring(url.indexOf("?") + 1, url.length).split("&");
        var param = new Array();
        for(var i =0;i<paraString.length;i++) {
            var item = paraString[i];
            var value = item.substring(item.indexOf("=") + 1, item.length);
            param[i]=value;
        }
        console.log("param:"+param);
        console.log("getQueryString();"+paraString);

        return param;
    }

    getQueryString();
});