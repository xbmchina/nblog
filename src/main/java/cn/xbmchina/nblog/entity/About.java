package cn.xbmchina.nblog.entity;

import lombok.Data;

/**
 * 个人简介，站点信息
 */
@Data
public class About {

    private Long id;
    private String title;
    private String logo;
    private String subTitle;
    private String keywords;
    private String description;
    private String siteEmail;
    private String siteIcp;
    private String pingSites;
    private String meta;
    private String remark;
}
