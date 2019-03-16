package cn.xbmchina.nblog.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@RequiredArgsConstructor
public class ArticleVisitLog {

    private Long id;
    @NonNull
    private Long articleId;
    private String userId;
    private String ipAddress;
    private Date creatTime;

}
