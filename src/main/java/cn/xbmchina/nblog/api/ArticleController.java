package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.entity.vo.ArticleVo;
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

    @RequestMapping("/detail")
    public ResponseResult getArticle(Article article) {

        Article result = articleService.getArticle(article);
        if (result != null) {
            return ResponseResult.ofSuccess("查询成功",result);
        }
        return ResponseResult.ofError(500,"查询失败", null);
    }

    @RequestMapping("/list")
    public ResponseResult getArticleList(ArticleVo article) {

        PageResult<ArticleVo> list = articleService.getArticleList(article);
        if (list != null) {
            return ResponseResult.ofSuccess("查询成功",list);
        }
        return ResponseResult.ofError(500,"查询失败", null);
    }


}
