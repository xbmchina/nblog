package cn.xbmchina.nblog.security;

import java.util.List;

import cn.xbmchina.nblog.entity.Role;
import cn.xbmchina.nblog.entity.User;
import cn.xbmchina.nblog.repository.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class JwtUserDetailsServiceImpl implements UserDetailsService {

	@Autowired
	private UserMapper userMapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		User userByName = userMapper.getUserByName(username);
		if (userByName == null) {
			throw new UsernameNotFoundException(String.format("No user found with username '%s'.", username));
		} else {
			List<Role> roles = userMapper.getRolesByUserId(userByName.getId());//查询权限。
			userByName.setRoles(roles);
			return JwtUserFactory.create(userByName);
		}
	}

}
