package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Special;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface SpecialMapper {

    @Insert(" INSERT INTO  special ( name, detail, img, uid, remark, create_time) " +
            " VALUES (#{name}, #{detail}, #{img}, #{uid}, #{remark}, #{createTime}) ")
    int insertSpecial(Special special);


    @Update(" UPDATE  special  " +
            " SET " +
            " name=#{name}, " +
            " detail=#{detail}," +
            " img=#{img}," +
            " uid=#{uid}," +
            " remark=#{remark}," +
            " create_time=#{createTime}" +
            " WHERE" +
            "  id=#{id} ")
    int updateSpecial(Special special);



    @Delete(" DELETE FROM special WHERE id = #{id} ")
    int deleteSpecial(Long id);


    @Select(" SELECT * FROM special ")
    List<Special> getList(Special special);
}
