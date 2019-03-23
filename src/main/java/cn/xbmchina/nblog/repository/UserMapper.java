package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.Role;
import cn.xbmchina.nblog.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface UserMapper {

    @Insert("INSERT INTO user (id,username,password,phone,email, address,sex,icon,remark,ip,create_time,last_time,activated)"+
            "VALUES ( #{id},#{username}, #{password}, #{phone}, #{email},#{address},#{sex},#{icon},#{remark},#{ip},#{createTime},#{lastTime},#{activated})" )
    int insert(User user);

    @Select(" SELECT id,username,PASSWORD,phone,email,address,sex,icon,remark,activated  " +
            " FROM user WHERE  username = #{username} and password = #{password}")
    User getUser(User user);



    @Select(" SELECT id,username,PASSWORD,phone,email,address,sex,icon,remark,activated " +
            " FROM user WHERE  username = #{username} ")
    User getUserByName(String username);


    @Select(" SELECT u.username,r.* FROM user as u LEFT JOIN user_role ur on ur.user_id = u.id LEFT JOIN role r on r.id = ur.role_id WHERE u.id = #{id} ")
    List<Role> getRolesByUserId(String id);


    @Insert("INSERT INTO user_role (user_id,role_id)"+
            "VALUES ( #{id}, #{roleId})" )
    int addUserRole(User user);

    @Update(" UPDATE user set username = #{username},password = #{password} ,activated = #{activated},last_time = #{lastTime} WHERE id = #{id} ")
    int updateUserInfo(User loginUser);
}
