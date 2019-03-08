package cn.xbmchina.nblog.backstage;


import cn.xbmchina.nblog.entity.User;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/u")
public class AdminUserController {


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

}
