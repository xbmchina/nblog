package cn.xbmchina.nblog.entity;

import lombok.Data;

/**
 * 点赞
 */
@Data
public class ArticleLikes {

    private Long id;
    private Long articleId;
    private Long ipAddress;
    private Integer isLike;
    private Integer likeScore;

}
