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

    @RequestMapping("/save")
    public ResponseResult addSpecial(Special special) {
        if (special != null){
            int result = specialService.save(special);
            if (result >0){
                return ResponseResult.ofSuccess("操作成功！",null);
            }
        }
        return ResponseResult.ofError("操作失败！");
    }


    @RequestMapping("/update")
    public ResponseResult updateSpecial(Special special) {

        if (special != null && special.getId() != null) {
            int result = specialService.update(special);
            if (result >0){
                return ResponseResult.ofSuccess("操作成功！",null);
            }
        }
        return ResponseResult.ofError("操作失败！");
    }



    @RequestMapping("/del")
    public ResponseResult delSpecial(Long id) {

        if ( id != null) {
            int result = specialService.delete(id);
            if (result >0){
                return ResponseResult.ofSuccess("操作成功！",null);
            }
        }
        return ResponseResult.ofError("操作失败！");
    }


    @RequestMapping("/list")
    public ResponseResult getList(Special special,Integer pageNum,Integer pageSize) {

        PageResult<Special> list = specialService.getList(special,pageNum,pageSize);

        if (list != null) {
            return ResponseResult.ofSuccess("查询成功",list);
        }
        return ResponseResult.ofError(500,"查询失败", null);

    }



}
