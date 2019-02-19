package cn.xbmchina.nblog.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;


/**
 * 文章分类
 */
@Data
public class Category {

    private Long id;
    private String name;
    private String description;

    @DateTimeFormat(pattern="yyyy-MM-dd")  //入参时,即接收输入时
    @JsonFormat(pattern="yyyy-MM-dd",timezone = "GMT+8")  //出参数时，即返回结果时
    private Date createTime;

    @DateTimeFormat(pattern="yyyy-MM-dd")  //入参时,即接收输入时
    @JsonFormat(pattern="yyyy-MM-dd",timezone = "GMT+8")  //出参数时，即返回结果时
    private Date updateTime;

}
