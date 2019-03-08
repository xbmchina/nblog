package cn.xbmchina.nblog.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
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
    private String keyword;
    private String shortcut;
    private String content;
    private Integer words;
    private Integer origin;//0原创;1转载;2翻译
    private String tagIds;
    private Integer specialId;//专栏id
    private Long categoryId;
    private String img;//列表显示缩略图
//    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone="GMT+8")
    private String createTime;
//    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone="GMT+8")
    private String updateTime;
//    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone="GMT+8")
    private String deployTime;
    private Long userId;
    private Integer isTop;
    private Integer isRecommend;
    private int status;



    private Long preId;
    private String preTitle;
    private Long nextId;
    private String nextTitle;

}
