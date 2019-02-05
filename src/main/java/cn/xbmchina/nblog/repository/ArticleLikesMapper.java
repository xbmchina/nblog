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
            " ( article_id, ip_address, is_like, like_score) " +
            " VALUES ( #{articleId}, #{ipAddress}, #{isLike}, #{likeScore}) ")
    int addArticleLikes(ArticleLikes articleLikes);



    @Update(" UPDATE  " +
            " article_likes " +
            " SET  " +
            " article_id=#{articleId}," +
            " ip_address=#{ipAddress}," +
            " is_like=#{isLike}," +
            " like_score=#{likeScore}" +
            " WHERE id=#{id} ")
    int updateArticleLikes(ArticleLikes articleLikes);


    @Select(" SELECT id,article_id, ip_address, is_like, like_score " +
            " FROM  article_likes " +
            " WHERE id = #{id} ")
    ArticleLikes selectArticleLikesById(ArticleLikes articleLikes);

}
