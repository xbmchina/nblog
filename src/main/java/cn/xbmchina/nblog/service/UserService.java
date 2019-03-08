package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.entity.User;
import cn.xbmchina.nblog.repository.UserMapper;
import cn.xbmchina.nblog.security.BCryptEncoderUtil;
import cn.xbmchina.nblog.security.JwtTokenUtil;
import cn.xbmchina.nblog.security.JwtUserDetailsServiceImpl;
import cn.xbmchina.nblog.util.IPGetUtil;
import cn.xbmchina.nblog.util.UUIDUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

/**
 * 用户类
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, readOnly = false, rollbackForClassName = "Exception")
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private JwtUserDetailsServiceImpl userDetailsService;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    /**
     * 注册
     * @param request
     * @param user
     * @return
     */
    public int register(HttpServletRequest request, User user) {
        int result = 0;
        if (user != null && StringUtils.isNotBlank(user.getUsername())
                && StringUtils.isNotBlank(user.getPassword()) && StringUtils.isNotBlank(user.getAckPassword())){
            if (!user.getPassword().equals(user.getAckPassword())){
                return -2;//密码不一致。
            }
            User userByName = userMapper.getUserByName(user.getUsername().trim());
            if(userByName != null) {
                return -1;//用户名已被占用
            }
            user.setId(UUIDUtil.getUUID());
            user.setPassword(BCryptEncoderUtil.encode(user.getPassword().trim()));
            user.setActivated(1);//默认为激活状态
            user.setRoleId(2);//默认为普通用户
            user.setIp(IPGetUtil.getIpAddress(request));
            user.setCreateTime(new Date());
            user.setLastTime(new Date());
            result = userMapper.insert(user);
            if (result >0) {
                userMapper.addUserRole(user);
            }

        }
        return result;
    }


    public User getUser(User user) {
        if (user != null && StringUtils.isNotBlank(user.getUsername())
                && StringUtils.isNotBlank(user.getPassword())){
            user.setPassword("");
            return userMapper.getUser(user);
        }
        return null;
    }


    public User login(User user) {
        // 查询是否已存在该用户
        if (user != null && StringUtils.isNotBlank(user.getUsername()) && StringUtils.isNotBlank(user.getPassword())){
            User loginUser = userMapper.getUserByName(user.getUsername());
            if (loginUser == null) {
                return null;
            }
            if (BCryptEncoderUtil.matches(user.getPassword(),loginUser.getPassword())){// 判断密码是否相同
                UsernamePasswordAuthenticationToken upToken = new UsernamePasswordAuthenticationToken(
                        loginUser.getUsername(),user.getPassword());

                Authentication authentication = authenticationManager.authenticate(upToken);
                SecurityContextHolder.getContext().setAuthentication(authentication);
                UserDetails userDetails = userDetailsService.loadUserByUsername(loginUser.getUsername());
                String token = jwtTokenUtil.generateToken(userDetails);
                loginUser.setLastTime(new Date());
                userMapper.updateUserInfo(loginUser);

                loginUser.setPassword("");
                loginUser.setToken(token);

                return loginUser;
            }

        }
        return null;


    }



}
