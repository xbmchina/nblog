package cn.xbmchina.nblog.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

import java.util.Date;
import java.util.List;


/**
 * 评论实体类
 */
@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Comment {

    private Long id;

    private Long articleId;

    private String userId;

    private String username;

    private String avatar;

    private String content;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date createTime;

    private String children;

    private Integer status;

    private Integer isTop;





    private List<ChildComment> childComments;
    private Integer total;
    private  List<Comment> comments;
}
