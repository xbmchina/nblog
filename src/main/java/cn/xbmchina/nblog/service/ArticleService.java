package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.repository.ArticleMapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ArticleService {

    @Autowired
    private ArticleMapper articleMapper;



    public int addArticle(Article article) {

        if (article!= null && StringUtils.isNotBlank(article.getAuthor()) && StringUtils.isNotBlank(article.getContent())){

           return articleMapper.insert(article);
        }

        return 0;
    }



    public Article getArticle(Article article) {

        if (article != null) {
            return articleMapper.getArticle(article);
        }
        return null;
    }


    public List<Article> getArticleList(Article article) {

        if (article != null) {
            return articleMapper.getArticleList(article);
        }
        return null;
    }




    public int updateArticle(Article article) {

        if (article != null && article.getId() !=null) {
            return articleMapper.updateArticle(article);
        }
        return 0;
    }




}
