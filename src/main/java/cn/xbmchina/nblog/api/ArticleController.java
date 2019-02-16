package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/article")
public class ArticleController {

    @Autowired
    private ArticleService articleService;


    @RequestMapping("/save")
    public ResponseResult saveArticle(Article article) {

        int addArticle = articleService.saveArticle(article);
        if (addArticle > 0) {
            return ResponseResult.ofSuccess("操作成功",null);
        }
        return ResponseResult.ofError(500,"操作失败", null);
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

        PageResult<Article> list = articleService.getArticleList(article);
        if (list != null) {
            return ResponseResult.ofSuccess("查询成功",list);
        }
        return ResponseResult.ofError(500,"查询失败", null);
    }

    @RequestMapping("/del")
    public ResponseResult deleteArticle(Long id) {

        int result = articleService.deleteArticle(id);
        if (result > 0 ) {
            return ResponseResult.ofSuccess("删除成功",null);
        }
        return ResponseResult.ofError(500,"删除失败", null);
    }





}
