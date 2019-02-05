package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Message;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface MessageMapper {

    @Insert(" INSERT INTO  " +
            " message " +
            " ( user_id, content, status, create_time, update_time) " +
            " VALUES ( #{userId}, #{content}, #{status}, #{createTime}, #{updateTime}) ")
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




    @Select(" SELECT id,user_id, content, status, create_time, update_time" +
            " FROM message " +
            " WHERE id = #{id} ")
    Message selectMessageById(Message message);



}
