// 下拉加载更多
$(document).ready(function(){

    $(".headerpage").load("header.html");
    // $(".footerpage").load("footer.html");

    loadMore();
    getList();

});


function getList() {

    console.log("xxxxxxxxxxxxxxxx");

    $.ajax({
        type: "GET",
        url: "/article/list",
        data: null,
        dataType: "json",
        success: function(result){
            var data = result.data.data;
            var pageNum =result.data.pageNum;
            console.log("ggggggggg"+data);
            // $('#resText').empty();   //清空resText里面的所有内容
            var html = '';
            $.each(data, function(i, item){

                html += '<div class="list-group-item item_article article shadow">\n' +
                    '    <div class="row">\n' +
                    '        <div class="div_center col-9">\n' +
                    '            <a class="list-group-item-heading div_article_title" href="/detail.html?id='+item.id+'">\n' +
                    '                <strong>\n' +
                    '                    '+item.title+'\n' +
                    '                </strong>\n' +
                    '            </a>\n' +
                    '            <p class="list-group-item-text div_article_content">\n' +
                    '                '+item.shortcut+'\n' +
                    '            </p>\n' +
                    '            <div class="article-footer">\n' +
                    '                <span><i class="fa fa-clock-o"></i>41</span>\n' +
                    '                <span class="article-author"><i class="fa fa-user"></i>0</span>\n' +
                    '                <span><i class="fa fa-tag"></i>0</span>\n' +
                    '                <span><i class="fa fa-tag"></i>Java</span>\n' +
                    '                <span class="article-viewinfo"><i class="fa fa-eye"></i>2019-01-29</span>\n' +
                    '            </div>\n' +
                    '        </div>\n' +
                    '        <!-- 右侧图片，信息 -->\n' +
                    '        <div class="col-3 div_right_info">\n' +
                    '            <img class="iv_article img-rounded" src="img/ic_android1.jpg">\n' +
                    '        </div>\n' +
                    '    </div>\n' +
                    '</div>'

            });
            if (pageNum == 1){
                $('.article-content').html(html);
            }else {
                $('.article-content').append(html);
            }


        }
    });

}



// 加载更多
function loadMore() {

    var range = 50;             //距下边界长度/单位px
    var elemt = 500;           //插入元素高度/单位px
    var maxnum = 9;            //设置加载最多次数
    var num = 1;
    var totalheight = 0;
    var main = $(".article-content");                     //主体元素
    $(window).scroll(function(){
        var srollPos = $(window).scrollTop();    //滚动条距顶部距离(页面超出窗口的高度)

        totalheight = parseFloat($(window).height()) + parseFloat(srollPos);
        if(($(document).height()-range) <= totalheight  && num != maxnum) {
            var html = ' <div class="list-group-item item_article article shadow">\n' +
                '                    <div class="row">\n' +
                '                        <div class="div_center col-9">\n' +
                '                            <a class="list-group-item-heading div_article_title" href="#">\n' +
                '                                <strong>\n' +
                '                                    Java设计理念\n' +
                '                                </strong>\n' +
                '                            </a>\n' +
                '                            <p class="list-group-item-text div_article_content">\n' +
                '                                所有设计源于生活，JAVA框终点在于分层、层与层之间如何交流。\n' +
                '                            </p>\n' +
                '                            <div class="article-footer">\n' +
                '                                <span><i class="fa fa-clock-o"></i>41</span>\n' +
                '                                <span class="article-author"><i class="fa fa-user"></i>0</span>\n' +
                '                                <span><i class="fa fa-tag"></i>0</span>\n' +
                '                                <span><i class="fa fa-tag"></i>Java</span>\n' +
                '                                <span class="article-viewinfo"><i class="fa fa-eye"></i>2019-01-29</span>\n' +
                '                            </div>\n' +
                '                        </div>\n' +
                '                        <!-- 右侧图片，信息 -->\n' +
                '                        <div class="col-3 div_right_info">\n' +
                '                            <img class="iv_article img-rounded" src="img/ic_android1.jpg">\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                </div>';

            main.append(html);
            num++;
        }
    });

}



