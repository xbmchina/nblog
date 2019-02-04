package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;

/**
 * 评论
 */
@Data
public class Comment {

    private Long id;
    private Long articleId;
    private String content;
    private Integer isTop;
    private Integer isRecommend;
    private Long userId;
    private Integer status;
    private Date createTime;
    private Date updateTime;

}
