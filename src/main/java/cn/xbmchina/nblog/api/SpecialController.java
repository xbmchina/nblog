package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.Special;
import cn.xbmchina.nblog.service.SpecialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/special")
@RestController
public class SpecialController {

    @Autowired
    private SpecialService specialService;

    @RequestMapping("/list")
    public ResponseResult getList(Special special,Integer pageNum,Integer pageSize) {

        PageResult<Special> list = specialService.getList(special,pageNum,pageSize);

        if (list != null) {
            return ResponseResult.ofSuccess("查询成功",list);
        }
        return ResponseResult.ofError(500,"查询失败", null);

    }



}
