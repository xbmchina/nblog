package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;

/**
 * 文章相关
 */
@Data
public class Article {

    private Long id;
    private String title;
    private String subtitle;
    private String author;
    private String shortcut;
    private String content;
    private Integer numbers;
    private Integer origin;
    private String tagIds;
    private Long categoryId;
    private Date createTime;
    private Date updateTime;
    private Date deployTime;
    private Long userId;
    private Integer isTop;
    private Integer isRecommend;
    private int status;



}
