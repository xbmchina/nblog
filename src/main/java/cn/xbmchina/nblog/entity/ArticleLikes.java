package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;

/**
 * 点赞
 */
@Data
public class ArticleLikes {

    private Long id;
    private String userId;
    private Long articleId;
    private String ipAddress;
    private Integer isLike;
    private Integer likeScore;
    private Date createTime;

}
