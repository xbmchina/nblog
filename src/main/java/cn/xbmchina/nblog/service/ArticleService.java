package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.entity.*;
import cn.xbmchina.nblog.entity.vo.ArticleVo;
import cn.xbmchina.nblog.repository.ArticleLikesMapper;
import cn.xbmchina.nblog.repository.ArticleMapper;
import cn.xbmchina.nblog.repository.ArticleVisitLogMapper;
import cn.xbmchina.nblog.repository.CommentMapper;
import cn.xbmchina.nblog.security.JwtTokenUtil;
import cn.xbmchina.nblog.security.JwtUserDetailsServiceImpl;
import cn.xbmchina.nblog.util.IPGetUtil;
import cn.xbmchina.nblog.util.SessionUtil;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, readOnly = false, rollbackForClassName = "Exception")
public class ArticleService {

    @Autowired
    private ArticleMapper articleMapper;

    @Autowired
    private ArticleLikesMapper articleLikesMapper;

    @Autowired
    private CommentMapper commentMapper;

    @Autowired
    private ArticleVisitLogMapper articleVisitLogMapper;

    @Autowired
    private SessionUtil sessionUtil;

    /**
     * 发文章
     *
     * @param article
     * @return
     */
    public int saveArticle(Article article) {

        if (article != null && StringUtils.isNotBlank(article.getContent())) {
            if (article.getId() == null || article.getId() == 0) {
                article.setAuthor("zero");
                return articleMapper.insert(article);
            } else {
                return articleMapper.updateArticle(article);
            }
        }

        return 0;
    }


    /**
     * 获取文章详情
     *
     * @param article
     * @return
     */
    public Article getArticle(Article article) {

        if (article != null) {
            Article item = articleMapper.getArticle(article);
            if (item != null) {
                articleVisitLogMapper.addArticleVisitLog(new ArticleVisitLog(item.getId()));//添加文章记录
//                item.setCommentList(commentMapper.getCommentsByArticleId(item.getId()));//前10条评论
                Article preArticle = articleMapper.getPreArticle(article);
                Article nextArticle = articleMapper.getNextArticle(article);
                if (preArticle != null) {
                    item.setPreId(preArticle.getId());
                    item.setPreTitle(preArticle.getTitle());
                }
                if (nextArticle != null) {
                    item.setNextId(nextArticle.getId());
                    item.setNextTitle(nextArticle.getTitle());
                }
            }
            return item;
        }
        return null;
    }


    /**
     * 获取文章列表
     *
     * @param article
     * @return
     */
    public PageResult<ArticleVo> getArticleList(ArticleVo article) {

        if (article != null && article.getPageNum() != null && article.getPageSize() != null) {
            PageHelper.startPage(article.getPageNum(), article.getPageSize());
        } else {
            PageHelper.startPage(0, 10);
        }

        List<ArticleVo> list = articleMapper.getHomeArtList(article);
        PageInfo<ArticleVo> pageInfo = new PageInfo<>(list);
        List<ArticleVo> articles = pageInfo.getList();
        //此处需要添加点赞数、评论数、阅读数
        for (ArticleVo item : articles) {
            int commentNum = 0;
            List<Comment> byArticleId = commentMapper.getCommentsByArticleId(item.getId());
            if (byArticleId != null) {
                commentNum = byArticleId.size();
            }
            for (Comment comment : byArticleId) {
                if (StringUtils.isNotBlank( comment.getChildren())) {
                    List<ChildComment> childComments = JSONObject.parseArray(comment.getChildren(), ChildComment.class);
                    commentNum += childComments.size();
                }
            }

            item.setCommentNum(commentNum);
            item.setLikeNum(articleLikesMapper.getArtLikeCount(item.getId()));
            item.setReaderNum(articleVisitLogMapper.getArticleVisitCount(item.getId()));
        }

        PageResult<ArticleVo> pageResult = new PageResult<>();
        pageResult.setPageNum(pageInfo.getPageNum());
        pageResult.setPageSize(pageInfo.getPageSize());
        pageResult.setTotal(pageInfo.getTotal());
        pageResult.setData(pageInfo.getList());

        return pageResult;
    }


    /**
     * 根据id删除文章
     *
     * @param id
     * @return
     */
    public int deleteArticle(Long id) {

        if (id != null && id != 0) {
            return articleMapper.deleteArticle(id);
        } else {
            return 0;
        }

    }


    /**
     * 点赞
     *
     * @param articleLikes
     * @param request
     * @return
     */
    public int likeArticle(ArticleLikes articleLikes, HttpServletRequest request) {

        User currentUser = sessionUtil.getCurrentUser(request);
        if (currentUser==null) {
            return 0;
        }
        if (articleLikes != null) {
            ArticleLikes artLike = articleLikesMapper.getArtLike(articleLikes);
            if (artLike == null) {
                articleLikes.setUserId(currentUser.getId());
                articleLikes.setIpAddress(IPGetUtil.getIpAddress(request));
                articleLikes.setCreateTime(new Date());
                articleLikes.setIsLike(1);
                return articleLikesMapper.addArticleLikes(articleLikes);
            }
            return -1;//不让他取消点赞
        }
        return 0;

    }


    /**
     * 评论
     *
     * @param comment
     * @return
     */

    public int addComment(Comment comment, HttpServletRequest request) {

        User currentUser = sessionUtil.getCurrentUser(request);
        if (currentUser==null) {
            return 0;
        }

        if (comment == null) {
            return 0;
        }

        if (comment.getId() != null && StringUtils.isNotBlank(comment.getChildren())) {//修改子评论

            Comment commentById = commentMapper.getCommentById(comment.getId());
            if (commentById != null) {
                String childrenComment = commentById.getChildren();
                List<ChildComment> childComments = null;
                if (StringUtils.isNotBlank(childrenComment)) {
                     childComments = JSONObject.parseArray(childrenComment, ChildComment.class);
                }else {
                    childComments = new ArrayList<>();
                }
                ChildComment childComment = JSONObject.parseObject(comment.getChildren(), ChildComment.class);
                childComment.setCreateTime(new Date());
                childComment.setFid(currentUser.getId());
                childComment.setFusername(currentUser.getUsername());
                childComments.add(childComment);
                comment.setChildren(JSONObject.toJSONString(childComments));

                return commentMapper.updateComment(comment);
            }
        } else if (StringUtils.isNotBlank(comment.getUserId()) && comment.getArticleId() != null) {
            comment.setUserId(currentUser.getId());
            comment.setUsername(currentUser.getUsername());
            return commentMapper.addComment(comment);
        }
        return 0;
    }


    public Comment getCommentsByArticleId(Long articleId) {

        List<Comment> commentsByArticleId = commentMapper.getCommentsByArticleId(articleId);
        if (commentsByArticleId != null) {
            int total = commentsByArticleId.size();
            try {//json转换会有可能出错
                for ( Comment comment : commentsByArticleId ) {
                    if (StringUtils.isNotBlank(comment.getChildren())){
                        List<ChildComment> childComments = JSONObject.parseArray(comment.getChildren(), ChildComment.class);
                        total += childComments.size();
                        comment.setChildren(null);
                        comment.setChildComments(childComments);
                    }
                }
            }catch (Exception e) {
                e.printStackTrace();
            }

            Comment comments = new Comment();
            comments.setComments(commentsByArticleId);
            comments.setTotal(total);
            comments.setArticleId(articleId);
            return  comments;
        }

        return  null;
    }


}
