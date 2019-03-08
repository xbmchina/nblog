package cn.xbmchina.nblog.security;

import cn.xbmchina.nblog.entity.User;
/**
 * 创建user工厂类
 * @author Administrator
 *
 */
public class JwtUserFactory {

	public static JwtUserDetails create(User user) {
		return new JwtUserDetails(user);
	}

}
