package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Tag;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface TagMapper {


    @Insert(" INSERT INTO tag (name, desc, icon, create_time, update_time)  " +
            " VALUES ( #{name}, #{desc}, #{icon}, #{createTime}, #{updateTime}) ")
    int addTag(Tag tag);


    @Update(" UPDATE  " +
            " tag " +
            " SET  " +
            " name=#{name}," +
            " desc=#{desc}," +
            " icon=#{icon}," +
            " create_time=#{createTime}," +
            " update_time=#{updateTime}" +
            " WHERE id=#{id} ")
    int updateTag(Tag tag);



    @Select(" SELECT id,name, desc, icon, create_time, update_time " +
            " FROM tag WHERE id = #{id}")
    Tag selectTagById(Tag tag);


}
