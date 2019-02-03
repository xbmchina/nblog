package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {

    @Insert("INSERT INTO USER (username,password,phone,email, address,sex,icon,remark)"+
            "VALUES ( #{username}, #{password}, #{phone}, #{email},#{address},#{sex},#{icon},#{remark})" )
    int insert(User user);

    @Select(" SELECT id,username,PASSWORD,phone,email,address,sex,icon,remark  " +
            " FROM user WHERE  username = #{username} and password = #{password}")
    User getUser(User user);


}
