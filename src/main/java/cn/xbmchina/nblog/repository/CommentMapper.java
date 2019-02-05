package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Comment;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface CommentMapper {


    @Insert(" INSERT INTO  " +
            " comment " +
            " (article_id, content, is_top, is_recommend, user_id, status, create_time, update_time)  " +
            " VALUES (#{articleId}, #{content}, #{isTop}, #{isRecommend}, #{userId}, #{status}, #{createTime}, #{updateTime})")
    int addComment(Comment comment);



    @Update(" UPDATE  " +
            " comment " +
            " SET  " +
            " article_id=#{articleId}," +
            " content=#{content}," +
            " is_top=#{isTop}," +
            " is_recommend=#{isRecommend}," +
            " user_id=#{userId}," +
            " status=#{status}," +
            " create_time=#{createTime}," +
            " update_time=#{updateTime}" +
            " WHERE id=#{id} ")
    int updateComment(Comment comment);



    @Select(" SELECT id,article_id, content, is_top, is_recommend, user_id, status, create_time, update_time  " +
            " FROM comment WHERE id  = #{id}")
    Comment selectCommentById(Comment comment);
}
