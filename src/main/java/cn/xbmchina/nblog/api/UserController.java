package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.User;
import cn.xbmchina.nblog.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/u")
public class UserController {


    @Autowired
    private UserService userService;

    @RequestMapping("/login")
    public ResponseResult login(User user) {
        User loginUser = userService.getUser(user);
        if (loginUser != null) {
            return ResponseResult.ofSuccess("登录成功！",loginUser);
        }
        return ResponseResult.ofError(500,"登录失败",null);
    }


    @RequestMapping("/register")
    public ResponseResult register(User user) {

        int addUser = userService.addUser(user);
        if (addUser >0) {
            return ResponseResult.ofSuccess("注册成功！",null);
        }
        return ResponseResult.ofError(500,"注册失败！",null);
    }

}
