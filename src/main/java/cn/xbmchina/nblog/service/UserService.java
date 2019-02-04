package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.entity.User;
import cn.xbmchina.nblog.repository.UserMapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 用户类
 */
@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;


    public int addUser(User user) {
        if (user != null && StringUtils.isNotBlank(user.getPhone()) && StringUtils.isNotBlank(user.getPassword())){
           return userMapper.insert(user);
        }
        return 0;
    }


    public User getUser(User user) {
        if (user != null && StringUtils.isNotBlank(user.getPhone()) && StringUtils.isNotBlank(user.getPassword())){
            user.setPassword("");
            return userMapper.getUser(user);
        }
        return null;
    }

}
