package cn.xbmchina.nblog.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

/**
 * 留言
 */
@Data
public class Message {

    private Long id;
    private String userId;
    private String email;
    private String content;
    private Integer status;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date createTime;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date updateTime;


    private Integer pageNum;
    private Integer pageSize;

}
