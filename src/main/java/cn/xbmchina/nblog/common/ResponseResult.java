package cn.xbmchina.nblog.common;

import lombok.Data;

@Data
public class ResponseResult {


    private int code;
    private String message;
    private Object data;

    public ResponseResult() {
    }

    public ResponseResult(int code, String message, Object data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }


    public static ResponseResult ofSuccess(String message,Object data) {
        return new ResponseResult(200,message,data);
    }

    public static ResponseResult ofError(int code,String message,Object data) {
        return new ResponseResult(code,message,data);
    }

}
