package cn.xbmchina.nblog.security;

import java.util.ArrayList;
import java.util.Collection;

import cn.xbmchina.nblog.entity.Role;
import cn.xbmchina.nblog.entity.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;


public class JwtUserDetails implements UserDetails {

	private User user;

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public JwtUserDetails(User user) {
		this.user = user;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {

		ArrayList<SimpleGrantedAuthority> authorities = new ArrayList<>();
		if (this.user != null) {
			for (Role role : user.getRoles()) {//添加相应权限
				SimpleGrantedAuthority authority = new SimpleGrantedAuthority(role.getRole());
				authorities.add(authority);
			}
		}

		return authorities;
	}

	@Override
	public String getPassword() {
		return this.user.getPassword();
	}

	@Override
	public String getUsername() {
		return this.user.getUsername();
	}

	@Override
	public boolean isAccountNonExpired() {
		return this.user.getActivated()==1?true:false;
	}

	@Override
	public boolean isAccountNonLocked() {
		return this.user.getActivated()==1?true:false;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return this.user.getActivated()==1?true:false;
	}

	@Override
	public boolean isEnabled() {
		return this.user.getActivated()==1?true:false;
	}

}
