package cn.xbmchina.nblog.entity.vo;

import cn.xbmchina.nblog.entity.Comment;
import lombok.Data;


/**
 * 文章表实体类
 */
@Data
public class ArticleVo {

    private Long id;//id
    private String title;//标题
    private String subtitle;//子标题
    private String img;//列表显示缩略图
    private String author;//作者
    private String shortcut;//摘要
    private String content;//正文
    private String origin;//0原创;1转载;2翻译
    private String deployTime;//发布时间
    private Integer words;//字数
    private Integer readerNum;//阅读数
    private Integer commentNum;//评论数
    private Integer likeNum;//点赞数
    private String tagName;//标签名
    private String specialName;//专栏名
    private int status;//状态



    private Integer pageNum;
    private Integer pageSize;

}
