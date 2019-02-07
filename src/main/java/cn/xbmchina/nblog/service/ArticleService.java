package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.repository.ArticleMapper;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.StringUtils;
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
            return articleMapper.getArticle(article);
        }
        return null;
    }


    public PageResult<Article> getArticleList(Article article) {
        if (article != null && article.getPageNum() != null && article.getPageSize() != null){
            PageHelper.startPage(article.getPageNum(),article.getPageSize());
        }else {
            PageHelper.startPage(0,10);
        }

        List<Article> list = articleMapper.getArticleList(article);
        PageInfo<Article> pageInfo = new PageInfo<>(list);

        PageResult<Article> pageResult = new PageResult<>();
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
