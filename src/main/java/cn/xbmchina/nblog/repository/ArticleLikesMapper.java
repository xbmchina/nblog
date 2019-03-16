package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.ArticleLikes;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ArticleLikesMapper {


    @Insert(" INSERT INTO  " +
            " article_likes " +
            " ( article_id, ip_address, is_like, like_score,user_id,create_time) " +
            " VALUES ( #{articleId}, #{ipAddress}, #{isLike}, #{likeScore},#{userId},#{createTime}) ")
    int addArticleLikes(ArticleLikes articleLikes);


    @Select(" <script> SELECT * FROM  article_likes " +
            " <where> " +
            "  <if test='id != null'>" +
            "  and id = #{id} " +
            " </if>" +
            "  <if test='userId != null and userId != \"\" '>" +
            "  and user_id = #{userId} " +
            " </if>" +
            "  <if test='articleId != null  '>" +
            "  and article_id = #{articleId} " +
            " </if>" +
            " </where> " +
            " </script>")
    ArticleLikes getArtLike(ArticleLikes articleLikes);



    @Select(" SELECT count(1) FROM  article_likes  where article_id = #{articleId} ")
    int getArtLikeCount(Long articleId);

}
