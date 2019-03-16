package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.ArticleVisitLog;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;


@Mapper
public interface ArticleVisitLogMapper {



    @Insert(" INSERT INTO  article_visit_log " +
            " (article_id, user_id, ip_address, create_time) " +
            " VALUES (#{articleId}, #{userId}, #{ipAddress}, now()) ")
    int addArticleVisitLog(ArticleVisitLog visitLog);



    @Select(" SELECT count(1) from article_visit_log where article_id = #{articleId} ")
    int getArticleVisitCount(Long articleId);

}
