package cn.xbmchina.nblog.security;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

/**
 * 生成token
 */
@Component
public class JwtTokenUtil {

	private String secret = "zero";

	final static String KEY_USERNAME = "username";

	public String generateToken(UserDetails userDetails) {
		Map<String, Object> claims = new HashMap<>();
		claims.put(KEY_USERNAME, userDetails.getUsername());
		return generateToken(claims);
	}

	public String getUsernameFromToken(String token)  {
		Claims claims = getClaimsFromToken(token);
		if (claims != null) {
			return claims.get(KEY_USERNAME, String.class);
		}
		return null;
	}

	public boolean  validateToken (String token,UserDetails userDetails) {
		String username = getUsernameFromToken(token);
		if(!StringUtils.isEmpty(username) && !StringUtils.isEmpty(userDetails.getUsername()) ) {
			return username.equals(userDetails.getUsername());
		}
		return false;
	}
	
	private String generateToken(Map<String, Object> claims) {
		return Jwts.builder().setClaims(claims).setExpiration(generateExpirationDate())
				.signWith(SignatureAlgorithm.HS512, secret) // 采用什么算法是可以自己选择的，不一定非要采用HS512
				.compact();
	}

	private Date generateExpirationDate() {
		Calendar c = Calendar.getInstance();
		c.add(Calendar.DAY_OF_YEAR, 180);
		//c.add(Calendar.SECOND, 1);
		return c.getTime();
	}

	private Claims getClaimsFromToken(String token) {
		Claims claims;
		try {
			claims = Jwts.parser().setSigningKey(secret).parseClaimsJws(token).getBody();
		} catch (Exception e) {
//			e.printStackTrace();
			claims = null;
		}
		return claims;
	}
/*
	public static void main(String[] args) {
		JwtTokenUtil jt = new JwtTokenUtil();
		Map<String, Object> claims = new HashMap<>();
		claims.put(KEY_USERNAME, "哈哈");
		String token = jt.generateToken(claims);
		System.err.println(token);
		
		System.err.println(jt.getClaimsFromToken(token).get(KEY_USERNAME));
		
	}*/




}
