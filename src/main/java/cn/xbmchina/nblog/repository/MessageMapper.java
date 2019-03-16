package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Message;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface MessageMapper {

    @Insert(" INSERT INTO message " +
            "( email, user_id, content, status, create_time, update_time) " +
            "VALUES ( #{email}, #{userId}, #{content}, #{status}, now(), now()) ")
    int addMessage(Message message);



    @Update(" UPDATE  " +
            " message " +
            " SET " +
            " user_id=#{userId}," +
            " content=#{content}," +
            " status=#{status}," +
            " create_time=#{createTime}," +
            " update_time=#{updateTime}  " +
            " WHERE id=#{id} ")
    int updateMessage(Message message);




    @Select(" SELECT id,user_id, email,content, status, create_time, update_time" +
            " FROM message " +
            " WHERE id = #{id} ")
    Message selectMessageById(Message message);


    @Select(" <script>  " +
            " select * from message  " +
            " <where> " +
            " <if test='createTime != null'>  " +
            " and create_time = #{createTime}" +
            " </if>" +
            "</where>" +
            " order by create_time desc " +
            "  </script> ")
    List<Message> getMessagesList(Message message);

}
