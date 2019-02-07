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
    private Integer numbers;
    private Integer origin;//0原创;1转载;2翻译
    private String tagIds;
    private Integer specialId;//专栏id
    private Long categoryId;
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


    private Integer pageNum;
    private Integer pageSize;


}
