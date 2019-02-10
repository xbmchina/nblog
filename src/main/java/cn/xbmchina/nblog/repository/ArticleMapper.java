package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Article;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ArticleMapper {

    @Insert(" INSERT INTO article (title, subtitle, author, keyword, shortcut, content, numbers, origin, tag_ids, category_id, special_id, create_time, update_time, deploy_time, user_id, is_top, is_recommend, status)  " +
            " VALUES  " +
            " ( #{title}, #{subtitle}, #{author}, #{keyword}, #{shortcut}, #{content}, #{numbers}, #{origin}, #{tagIds}, #{categoryId}, #{specialId}, now(), now(), now(), #{userId}, #{isTop}, #{isRecommend}, #{status}) ")
    int insert(Article article);



    @Select(" SELECT id, title, subtitle, author, keyword, shortcut, content, numbers, origin, tag_ids as tagIds, " +
            "category_id as categoryId, special_id as specialId, create_time as createTime, update_time as updateTime, " +
            "deploy_time as deployTime, user_id as userId, is_top as isTop, is_recommend as isRecommend, status " +
            "FROM article WHERE id = #{id}")
    Article getArticle(Article article);



    @Update(" UPDATE " +
            " article  " +
            " SET " +
            " title = #{title}, subtitle=#{subtitle}, author = #{author}, " +
            " keyword = #{keyword}, numbers=#{numbers}, origin = #{origin}, " +
            " tag_ids = #{tagIds},  " +
            " category_id = #{categoryId},special_id=#{specialId},is_top = #{isTop}," +
            " is_recommend = #{isRecommend}, " +
            " shortcut=#{shortcut}, content=#{content}," +
            " update_time= now(), " +
            " deploy_time= now(), user_id=#{userId}, status=#{status}  " +
            " WHERE id = #{id} ")
    int updateArticle(Article article);



    @Select(" <script> " +
            " SELECT  id, title, subtitle, author, keyword, shortcut, numbers, origin, tag_ids as tagIds," +
            " category_id as categoryId, special_id as specialId, create_time as createTime, update_time as updateTime," +
            " deploy_time as deployTime, user_id as userId, is_top as isTop, is_recommend as isRecommend, status" +
            " FROM article  " +
            " where 1 = 1 " +
            " <if test= \"author != null and author != '' \" > " +
            " and author = #{author} " +
            " </if> " +
            "  order by deploy_time desc  " +
            " </script>")
    List<Article> getArticleList(Article article);



    @Delete(" DELETE FROM article WHERE id = #{id} ")
    int deleteArticle(Long id);

}
