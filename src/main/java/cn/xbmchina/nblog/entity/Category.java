package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;

/**
 * 文章分类
 */
@Data
public class Category {

    private Long id;
    private String name;
    private String desc;
    private Date createTime;
    private Date updateTime;

}
