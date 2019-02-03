package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Article;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface ArticleMapper {

    @Insert(" INSERT INTO article (title, subtitle, author, shortcut, content, create_time, update_time, deploy_time, uid, status) " +
            " VALUES ( #{title}, #{subtitle}, #{author}, #{shortcut}, #{content}, #{createTime}, #{updateTime}, #{deployTime}, #{uid}, #{status})")
    int insert(Article article);



    @Select(" SELECT id, title, subtitle, author, shortcut, content, create_time as createTime, " +
            "update_time as updateTime, deploy_time as deployTime, uid, status " +
            "FROM article WHERE id = #{id}")
    Article getArticle(Article article);



    @Update(" UPDATE " +
            " article  " +
            " SET " +
            " title=#{title}, subtitle=#{subtitle}, author=#{author}, " +
            " shortcut=#{shortcut}, content=#{content}," +
            " create_time=#{createTime}, update_time=#{updateTime}, " +
            " deploy_time=#{deployTime}, uid=#{uid}, status=#{status}  " +
            " WHERE id = #{id}")
    int updateArticle(Article article);



    @Select(" SELECT id, title, subtitle, author, shortcut, content, create_time as createTime, " +
            "update_time as updateTime, deploy_time as deployTime, uid, status " +
            "FROM article " +
            " WHERE title = #{title} " )
    List<Article> getArticleList(Article article);


}
