package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.User;
import cn.xbmchina.nblog.service.UserService;
import cn.xbmchina.nblog.util.IPGetUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/u")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/login12")
    public ResponseResult login12(User user) {
        Map<String,String> dataMap = new HashMap<>();
        System.out.println("呵呵呵呵呵呵");
        dataMap.put("token","admin");
        return ResponseResult.ofSuccess("成功！",dataMap);
    }

    @RequestMapping("/register")
    public ResponseResult register(HttpServletRequest request,User user) {

        int addUser = userService.register(request,user);
        if (addUser >0) {
            return ResponseResult.ofSuccess("注册成功！",null);
        }else if (addUser == -1) {
            return ResponseResult.ofError("用户名已被占用！");
        }else if (addUser == -2) {
            return ResponseResult.ofError("两次密码输入不一致！");
        }
        return ResponseResult.ofError(500,"注册失败！");
    }


    @RequestMapping("/login")
    public ResponseResult login1(User user) {
        User loginUser = userService.login(user);
        if (loginUser != null) {
            return ResponseResult.ofSuccess("登录成功！",loginUser);
        }
        return ResponseResult.ofError(500,"登录失败",null);
    }

}
