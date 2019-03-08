package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.entity.vo.ArticleVo;
import cn.xbmchina.nblog.repository.ArticleMapper;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Service
public class ArticleService {

    @Autowired
    private ArticleMapper articleMapper;



    public int saveArticle(Article article) {

        if (article!= null  && StringUtils.isNotBlank(article.getContent())){
            if (article.getId() == null || article.getId() ==0) {
                article.setAuthor("zero");
                return articleMapper.insert(article);
            }else {
                return articleMapper.updateArticle(article);
            }
        }

        return 0;
    }



    public Article getArticle(Article article) {
        if (article != null) {
            Article item = articleMapper.getArticle(article);
            if (item != null) {
                Article preArticle =  articleMapper.getPreArticle(article);
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


    public PageResult<ArticleVo> getArticleList(ArticleVo article) {
        if (article != null && article.getPageNum() != null && article.getPageSize() != null){
            PageHelper.startPage(article.getPageNum(),article.getPageSize());
        }else {
            PageHelper.startPage(0,10);
        }

        List<ArticleVo> list = articleMapper.getHomeArtList(article);
        PageInfo<ArticleVo> pageInfo = new PageInfo<>(list);
        List<ArticleVo> articles = pageInfo.getList();
        //此处需要添加点赞数、评论数、阅读数
        for (ArticleVo item : articles) {
            item.setCommentNum((int)(1+Math.random()*20));
            item.setLikeNum((int)(1+Math.random()*50));
            item.setReaderNum((int)(1+Math.random()*100));
        }

        PageResult<ArticleVo> pageResult = new PageResult<>();
        pageResult.setPageNum(pageInfo.getPageNum());
        pageResult.setPageSize(pageInfo.getPageSize());
        pageResult.setTotal(pageInfo.getTotal());
        pageResult.setData(pageInfo.getList());

        return pageResult;
    }



    public int deleteArticle(Long id) {
        if (id != null && id != 0) {
            return articleMapper.deleteArticle(id);
        }else {
            return 0;
        }

    }


}
