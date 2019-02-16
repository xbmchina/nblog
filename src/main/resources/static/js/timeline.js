$(document).ready(function () {

    $(".headerpage").load("header.html");
    $(".footerpage").load("footer.html");

    $('.VivaTimeline').vivaTimeline({
        carousel: true,
        carouselTime: 3000
    });
});