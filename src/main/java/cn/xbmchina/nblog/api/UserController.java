package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.User;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/u")
public class UserController {


    @RequestMapping("/login")
    public ResponseResult login(User user) {
        return ResponseResult.ofSuccess("登录成功！",null);
    }
}
