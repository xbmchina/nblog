package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Article {

    private Long id;
    private String title;
    private String subtitle;
    private String author;
    private String shortcut;
    private String content;
    private Date createTime;
    private Date updateTime;
    private Date deployTime;
    private Long uid;
    private int status;



}
