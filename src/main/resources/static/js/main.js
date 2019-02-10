// 下拉加载更多
$(document).ready(function(){

    loadMore();
    topReturn();

});

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

//返回顶部
function topReturn() {

    //goToTop距浏览器顶端的距离，这个距离可以根据你的需求修改
    var topDistance = 500;

    //距离浏览器顶端多少距离开始显示goToTop按钮，这个距离也可以修改，但不能超过浏览器默认高度，为了兼容不同分辨率的浏览器，我建议在这里设置值为1；
    var showDistance = 1;

    //定义一个变量，方便后面加入在html元素标签中插入这个goToTop按钮的标签
    var goToTopButton = $('<div id="goToTop"><a href="javascript:;">回到顶部</a></div>');

    var thisTop = $(window).scrollTop() + topDistance;

    //在container的div里插入我们前面定义好的html标签元素
    $('.main').append(goToTopButton);

    //设置goToTop按钮top的css属性和属性值
    $('#goToTop').css('top' ,thisTop);

    if($(window).scrollTop() < showDistance){
        $('#goToTop').hide();
    }

    // 给窗口绑定一个滚动事件，当窗口滚动条滚动时执行
    $(window).scroll(function(){

        // console.log($(this).scrollTop());

        thisTop = $(this).scrollTop() + topDistance;        //获取当前window向上滚动的距离
        $('#goToTop').css('top', thisTop);                    //修改goToTop按钮的top距离

        // console.log(thisTop);

        if($(this).scrollTop() > showDistance){
            $('#goToTop').fadeIn();
        }else{
            $('#goToTop').fadeOut();
        }

    });


    // 给按钮绑定一个click事件，点击按钮时，返回顶部
    $('#goToTop a').click(function(){
        $('html ,body').animate({scrollTop: 0}, 300);
        return false;
    });
}


