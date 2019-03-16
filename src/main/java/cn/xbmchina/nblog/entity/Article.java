package cn.xbmchina.nblog.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 文章相关
 */
@Data
public class Article {

    private Long id;
    private String title;
    private String subtitle;
    private String author;
    private String keyword;
    private String shortcut;
    private String content;
    private Integer words;
    private Integer origin;//0原创;1转载;2翻译
    private String tagIds;
    private Integer specialId;//专栏id
    private Long categoryId;
    private String img;//列表显示缩略图
    private String createTime;
    private String updateTime;
    private String deployTime;
    private Long userId;
    private Integer isTop;
    private Integer isRecommend;
    private int status;

    private List<Comment> commentList;//评论列表

    private Long preId;
    private String preTitle;
    private Long nextId;
    private String nextTitle;

}
