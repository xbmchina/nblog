package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 用户实体
 */
@Data
public class User {

    private String id;
    private String username;
    private String password;
    private String phone;
    private String email;
    private String address;
    private String sex;
    private String icon;
    private String remark;
    private Integer roleId;//1：admin；2：user
    private String ip;//ip地址
    private Date createTime;//创建时间
    private Date lastTime;//最后登录时间
    /**
     * 该账号是否被禁用：1：可用，0：禁用,-1无条件
     */
    private Integer activated;
    private String ackPassword;
    private String token;
    /**
     * 用户的角色
     */
    private List<Role> roles;
    

}
