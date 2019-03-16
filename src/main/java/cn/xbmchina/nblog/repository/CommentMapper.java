package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Comment;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface CommentMapper {


    @Insert(" INSERT INTO comments " +
            " (article_id, user_id, user_name, avatar, content, create_time, children, status, is_top) " +
            " VALUES ( #{articleId}, #{userId}, #{username}, #{avatar}, #{content}, now(), #{children}, #{status}, #{isTop})")
    int addComment(Comment comment);


    @Select(" select *,user_id as userId,user_name as username,create_time as createTime from comments where article_id = #{articleId}  order by is_top,create_time desc ")
    List<Comment> getCommentsByArticleId(Long articleId);


    @Select(" select *,user_id as userId,user_name as username from comments where id = #{id}  ")
    Comment getCommentById(Long id);


    @Update("UPDATE comments SET  children=#{children}, status=#{status}, is_top=#{isTop} WHERE id=#{id}")
    int updateComment(Comment comment);

}
