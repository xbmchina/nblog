package cn.xbmchina.nblog.backstage;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.entity.vo.ArticleVo;
import cn.xbmchina.nblog.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/admin/article")
public class AdminArticleController {

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


    @RequestMapping("/del")
    public ResponseResult deleteArticle(Long id) {

        int result = articleService.deleteArticle(id);
        if (result > 0 ) {
            return ResponseResult.ofSuccess("删除成功",null);
        }
        return ResponseResult.ofError(500,"删除失败", null);
    }





}
