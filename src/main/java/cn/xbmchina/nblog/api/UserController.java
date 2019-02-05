package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.User;
import cn.xbmchina.nblog.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/u")
public class UserController {


    @Autowired
    private UserService userService;

    @RequestMapping("/login1")
    public ResponseResult login1(User user) {
        User loginUser = userService.getUser(user);
        if (loginUser != null) {
            return ResponseResult.ofSuccess("登录成功！",loginUser);
        }
        return ResponseResult.ofError(500,"登录失败",null);
    }


    @RequestMapping("/login")
    public ResponseResult login(User user) {
        Map<String,String> dataMap = new HashMap<>();
        System.out.println("呵呵呵呵呵呵");
        dataMap.put("token","admin");
        return ResponseResult.ofSuccess("成功！",dataMap);
    }

    @RequestMapping("/info")
    public String userInfo(User user) {

        System.out.println("xixixixixiix");
        return "{\n" +
                "  \"code\": 200,\n" +
                "  \"data\": {\n" +
                "    \"roles\": [\n" +
                "      \"admin\"\n" +
                "    ],\n" +
                "    \"name\": \"admin\",\n" +
                "    \"avatar\": \"https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif\"\n" +
                "  }\n" +
                "}";
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
