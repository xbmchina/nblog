package cn.xbmchina.nblog.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class BCryptEncoderUtil {

    /**
     * 加密
     * @param password
     * @return
     */
    public static String encode(String password) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();// 加密
        return encoder.encode(password.trim());
    }


    /**
     * 校验是否相等
     * @param rawPassword
     * @param encodedPassword
     * @return
     */
    public static boolean matches(String rawPassword,String encodedPassword) {

        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();// 加密

        return encoder.matches(rawPassword, encodedPassword);
    }

}
