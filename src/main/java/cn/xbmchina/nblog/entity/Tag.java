package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;

/**
 * 标签
 */
@Data
public class Tag {

    private Long id;
    private String name;
    private String desc;
    private String icon;
    private Date createTime;
    private Date updateTime;
}
