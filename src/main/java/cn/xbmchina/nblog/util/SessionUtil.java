package cn.xbmchina.nblog.util;

import cn.xbmchina.nblog.entity.User;
import cn.xbmchina.nblog.repository.UserMapper;
import cn.xbmchina.nblog.security.JwtTokenUtil;
import cn.xbmchina.nblog.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class SessionUtil {

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Value("${jwt.tokenHead}")
    private String tokenHead;// token的头，即Bearer

    @Value("${jwt.header}")
    private String tokenHeader;//token的头字段，即Authorization
    @Autowired
    private UserMapper userMapper;


    public User getCurrentUser(HttpServletRequest request) {

        String authHeader = request.getHeader(this.tokenHeader);
        if (StringUtils.isNotBlank(authHeader)) {
            final String authToken = authHeader.substring(tokenHead.length());
            String username = jwtTokenUtil.getUsernameFromToken(authToken);
            return userMapper.getUserByName(username);
        }
        return null;
    }
}
