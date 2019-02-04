package cn.xbmchina.nblog.entity;

import lombok.Data;

/**
 * 用户实体
 */
@Data
public class User {

    private Long id;
    private String username;
    private String password;
    private String phone;
    private String email;
    private String address;
    private String sex;
    private String icon;
    private String remark;




}
