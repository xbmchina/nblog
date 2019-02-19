package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Category;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface CategoryMapper {

    @Insert(" <script> " +
            " INSERT INTO category ( name, description, create_time, update_time)  " +
            " VALUES  " +
            " ( #{name}, #{description}, #{createTime}, #{updateTime})  " +
            " </script> ")
    int addCategory(Category category);




    @Update(" UPDATE  " +
            " category " +
            " SET " +
            " name=#{name}," +
            " description=#{description}," +
            " create_time=#{createTime}," +
            " update_time=#{updateTime}" +
            " WHERE  " +
            " id=#{id} ")
    int updateCategory(Category category);


    @Delete(" DELETE FROM category WHERE id = #{id}")
    int deleteCategory(Long id);


    @Select(" <script>" +
            " SELECT id,name, description, create_time, update_time " +
            " from category" +
            " <where> " +
            " <if test='name != null and name != \"\" ' > " +
            " and name = #{name} " +
            "</if>" +
            " <if test='id != null' > " +
            " and id = #{id} " +
            "</if>" +
            " </where> " +
            " </script>")
    Category selectByCondition(Category category);


    @Select(" SELECT * FROM category ")
    List<Category> getList(Category category);
}
