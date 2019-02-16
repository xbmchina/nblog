$(function(){

    $(".headerpage").load("header.html");
    $(".footerpage").load("footer.html");

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
        data: {id:19},//也可以是字符串链接"id=1001"，建议用对象
        success: function(result){
            if (result.code == 200) {
                $("#content").html(marked(result.data.content));
            }
        }
    });

});