package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.entity.ArticleLikes;
import cn.xbmchina.nblog.entity.Comment;
import cn.xbmchina.nblog.entity.vo.ArticleVo;
import cn.xbmchina.nblog.security.JwtTokenUtil;
import cn.xbmchina.nblog.service.ArticleService;
import cn.xbmchina.nblog.util.IPGetUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
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
            return ResponseResult.ofSuccess("查询成功", result);
        }
        return ResponseResult.ofError(500, "查询失败", null);
    }

    @RequestMapping("/list")
    public ResponseResult getArticleList(ArticleVo article) {

        PageResult<ArticleVo> list = articleService.getArticleList(article);
        if (list != null) {
            return ResponseResult.ofSuccess("查询成功", list);
        }
        return ResponseResult.ofError(500, "查询失败", null);
    }


    /**
     * 喜欢
     *
     * @param articleLikes
     * @param request
     * @return
     */
    @RequestMapping("/like")
    public ResponseResult likeArticle(ArticleLikes articleLikes, HttpServletRequest request) {


        int result = articleService.likeArticle(articleLikes, request);
        if (result > 0) {
            return ResponseResult.ofSuccess("操作成功", null);
        } else if (result == -1) {
            return ResponseResult.ofSuccess("你已经点赞过了", null);
        }
        return ResponseResult.ofError(500, "操作失败", null);
    }


    /**
     * 评论
     *
     * @param comment
     * @return
     */
    @RequestMapping("/comment")
    public ResponseResult commentArticle(Comment comment,HttpServletRequest request) {

        int result = articleService.addComment(comment,request);
        if (result > 0) {
            return ResponseResult.ofSuccess("操作成功", null);
        }
        return ResponseResult.ofError(500, "操作失败", null);
    }


    /**
     * 根据文章id获取文章列表
     * @param comment
     * @return
     */
    @RequestMapping("/getComments")
    public ResponseResult getCommentsList(Comment comment) {

        Comment commentsByArticleId = articleService.getCommentsByArticleId(comment.getArticleId());

        if (commentsByArticleId != null) {
            return ResponseResult.ofSuccess("操作成功", commentsByArticleId);
        }

        return ResponseResult.ofError(500, "操作失败", null);

    }

}
