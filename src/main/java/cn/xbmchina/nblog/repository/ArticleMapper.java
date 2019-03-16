package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Article;
import cn.xbmchina.nblog.entity.ArticleLikes;
import cn.xbmchina.nblog.entity.Comment;
import cn.xbmchina.nblog.entity.vo.ArticleVo;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ArticleMapper {

    @Insert(" INSERT INTO article (title, subtitle, author, keyword, img,shortcut, content, words, origin, tag_ids, category_id, special_id, create_time, update_time, deploy_time, user_id, is_top, is_recommend, status)  " +
            " VALUES  " +
            " ( #{title}, #{subtitle}, #{author}, #{keyword},#{img}, #{shortcut}, #{content}, #{words}, #{origin}, #{tagIds}, #{categoryId}, #{specialId}, now(), now(), now(), #{userId}, #{isTop}, #{isRecommend}, #{status}) ")
    int insert(Article article);



    @Select(" SELECT id, title, subtitle, author, keyword, img,shortcut, content, words, origin, tag_ids as tagIds, " +
            "category_id as categoryId, special_id as specialId, DATE_FORMAT(create_time,'%Y-%m-%d') as createTime, DATE_FORMAT(update_time,'%Y-%m-%d') as updateTime, " +
            "DATE_FORMAT(deploy_time,'%Y-%m-%d') as deployTime, user_id as userId, is_top as isTop, is_recommend as isRecommend, status " +
            "FROM article WHERE id = #{id}")
    Article getArticle(Article article);



    @Update(" UPDATE " +
            " article  " +
            " SET " +
            " title = #{title}, subtitle=#{subtitle}, img=#{img}, author = #{author}, " +
            " keyword = #{keyword}, words=#{words}, origin = #{origin}, " +
            " tag_ids = #{tagIds},  " +
            " category_id = #{categoryId},special_id=#{specialId},is_top = #{isTop}," +
            " is_recommend = #{isRecommend}, " +
            " shortcut=#{shortcut}, content=#{content}," +
            " update_time= now(), " +
            " deploy_time= now(), user_id=#{userId}, status=#{status}  " +
            " WHERE id = #{id} ")
    int updateArticle(Article article);



    @Select(" <script> " +
            " SELECT  id, title, subtitle, author, keyword,img,shortcut, words, origin, tag_ids as tagIds," +
            " category_id as categoryId, special_id as specialId, DATE_FORMAT(create_time,'%Y-%m-%d') as createTime, DATE_FORMAT(update_time,'%Y-%m-%d') as updateTime," +
            " DATE_FORMAT(deploy_time,'%Y-%m-%d') as deployTime, user_id as userId, is_top as isTop, is_recommend as isRecommend, status" +
            " FROM article  " +
            " where 1 = 1 " +
            " <if test= \"author != null and author != '' \" > " +
            " and author = #{author} " +
            " </if> " +
            "  order by deploy_time desc  " +
            " </script>")
    List<Article> getArticleList(Article article);



    @Select(" <script> " +
            " SELECT  " +
            " art.id, art.title, art.subtitle, art.author, art.keyword,art.img,art.shortcut, art.words, art.origin, art.tag_ids as tagIds," +
            " art.category_id as categoryId, art.special_id as specialId, DATE_FORMAT(art.create_time,'%Y-%m-%d') as createTime, DATE_FORMAT(art.update_time,'%Y-%m-%d') as updateTime," +
            " DATE_FORMAT(art.deploy_time,'%Y-%m-%d') as deployTime, art.user_id as userId, art.is_top as isTop, art.is_recommend as isRecommend, art.status," +
            " cat.name as tagName,sp.name as specialName " +
            " from article as art " +
            " LEFT JOIN special as sp on art.special_id = sp.id " +
            " LEFT JOIN category as cat on art.category_id = cat.id  " +
            " <where> " +
            " <if test= \"specialName != null  and specialName != '' \" > " +
            " and sp.name = #{specialName} " +
            " </if> " +
            " <if test= \"tagName != null and tagName != '' \" > " +
            " and cat.name = #{tagName} " +
            " </if> " +
            " <if test= \"author != null and author != '' \" > " +
            " and author = #{author} " +
            " </if> " +
            " <if test= \"title != null and title != '' \" > " +
            " and title LIKE concat(concat('%',#{title}),'%')" +
            " </if> " +
            " </where> " +
            "  order by deploy_time desc  " +
            " </script>")
    List<ArticleVo> getHomeArtList(ArticleVo article);



    @Delete(" DELETE FROM article WHERE id = #{id} ")
    int deleteArticle(Long id);

    @Select(" <script> " +
            " select id,title " +
            " from article  " +
            " where " +
            " id = (select max(id)  " +
            " from article where id &lt; #{id})" +
            " </script> ")
    Article getPreArticle(Article article);


    @Select(" <script> " +
            " select id,title " +
            " from article  " +
            " where " +
            " id = (select min(id)  " +
            " from article where id &gt; #{id})" +
            " </script> ")
    Article getNextArticle(Article article);


}
