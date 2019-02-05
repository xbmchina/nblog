package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.TimeAxis;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface TimeAxisMapper {


    @Insert(" INSERT INTO  time_axis " +
            " (title, content, status, start_time, end_time, create_time, update_time, user_id) " +
            " VALUES  " +
            " (#{title}, #{content}, #{status}, #{startTime}, #{endTime}, #{createTime}, #{updateTime}, #{userId}) ")
    int addTimeAxis(TimeAxis timeAxis);


    @Update(" UPDATE time_axis " +
            " SET " +
            " title=#{title}," +
            " content=#{content}," +
            " status=#{status}," +
            " start_time=#{startTime}," +
            " end_time=#{endTime}," +
            " create_time=#{createTime}," +
            " update_time=#{updateTime}," +
            " user_id=#{userId}" +
            " WHERE id=#{id} ")
    int updateTimeAxis(TimeAxis timeAxis);


    @Select(" SELECT id,title, content, status, start_time, end_time, create_time, update_time, user_id " +
            " FROM  time_axis " +
            " WHERE id = #{id} ")
    TimeAxis selectTimeAxisById(TimeAxis timeAxis);

}
