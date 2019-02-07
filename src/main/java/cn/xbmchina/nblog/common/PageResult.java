package cn.xbmchina.nblog.common;

import lombok.Data;

import java.util.List;
@Data
public class PageResult<T> {

    private Integer pageNum;
    private Integer pageSize;
    private Long total;
    private List<T> data;

}
