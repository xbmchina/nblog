package cn.xbmchina.nblog.entity;

import lombok.Data;

import java.util.Date;

/**
 * 时间轴
 */
@Data
public class TimeAxis {

    private Long id;
    private String title;
    private String content;
    private Integer status;
    private Date startTime;
    private Date endTime;
    private Date createTime;
    private Date updateTime;
    private Long userId;

}
