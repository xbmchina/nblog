package cn.xbmchina.nblog.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

/**
 * 子评论
 */
@Data
public class ChildComment {


    private String fid;
    private String fusername;//新评论者
    private String favatar;
    private String tid;
    private String tusername;//原评论者
    private String tavatar;
    private String content;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date createTime;

}
