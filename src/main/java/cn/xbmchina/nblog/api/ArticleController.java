package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/article")
public class ArticleController {

    @Autowired
    private ArticleService articleService;


    @RequestMapping("/add")
    public ResponseResult addArticle(Article article) {

        int addArticle = articleService.addArticle(article);
        if (addArticle > 0) {
            return ResponseResult.ofSuccess("添加成功",null);
        }
        return ResponseResult.ofError(500,"添加失败", null);
    }


    @RequestMapping("/update")
    public ResponseResult updateArticle(Article article) {

        int updateArticle = articleService.updateArticle(article);
        if (updateArticle > 0) {
            return ResponseResult.ofSuccess("修改成功",null);
        }
        return ResponseResult.ofError(500,"修改失败", null);
    }


    @RequestMapping("/detail")
    public ResponseResult getArticle(Article article) {

        Article result = articleService.getArticle(article);
        if (result != null) {
            return ResponseResult.ofSuccess("查询成功",result);
        }
        return ResponseResult.ofError(500,"查询失败", null);
    }


    @RequestMapping("/list")
    public ResponseResult getArticleList(Article article) {

        List<Article> list = articleService.getArticleList(article);
        if (list != null) {
            return ResponseResult.ofSuccess("查询成功",list);
        }
        return ResponseResult.ofError(500,"查询失败", null);
    }

}
