package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;

/**
 * 留言
 */
@Data
public class Message {

    private Long id;
    private Long userId;
    private String content;
    private Integer status;
    private Date createTime;
    private Date updateTime;

}
