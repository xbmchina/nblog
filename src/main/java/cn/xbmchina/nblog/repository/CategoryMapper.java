package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Category;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface CategoryMapper {

    @Insert(" INSERT INTO  " +
            " category " +
            " ( name, desc, create_time, update_time) " +
            " VALUES (#{name}, #{desc}, #{createTime}, #{updateTime}) ")
    int addCategory(Category category);




    @Update(" UPDATE  " +
            " category " +
            " SET " +
            " name=#{name}," +
            " desc=#{desc}," +
            " create_time=#{createTime}," +
            " update_time=#{updateTime}" +
            " WHERE  " +
            " id=#{id} ")
    int updateCategory(Category category);



    @Select(" SELECT id,name, desc, create_time, update_time " +
            " from category" +
            " WHERE " +
            " id = #{id} ")
    Category selectCategoryById(Category category);

}