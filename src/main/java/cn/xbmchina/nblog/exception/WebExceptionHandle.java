package cn.xbmchina.nblog.exception;

import cn.xbmchina.nblog.common.ResponseResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;


@ControllerAdvice
@ResponseBody
public class WebExceptionHandle {
	private static final Logger logger = LoggerFactory.getLogger(WebExceptionHandle.class);

	/**
	 * 400 - Bad Request
	 */
	@ResponseStatus(HttpStatus.BAD_REQUEST)
	@ExceptionHandler(HttpMessageNotReadableException.class)
	public ResponseResult handleHttpMessageNotReadableException(HttpMessageNotReadableException e) {
		logger.error("参数解析失败", e);
		return ResponseResult.ofError("参数解析失败");
	}

	/**
	 * 403 - Method Not Allowed
	 */
	@ResponseStatus(HttpStatus.FORBIDDEN)
	@ExceptionHandler(AccessDeniedException.class)
	public ResponseResult handleAccessDeniedException(AccessDeniedException e) {
		logger.error("不支持当前请求方法", e);
		return ResponseResult.ofError(403, e.getMessage(), null);
	}

	/**
	 * 405 - Method Not Allowed
	 */
	@ResponseStatus(HttpStatus.FORBIDDEN)
	@ExceptionHandler(HttpRequestMethodNotSupportedException.class)
	public ResponseResult handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
		logger.error("不支持当前请求方法", e);
		return ResponseResult.ofError(403, e.getMessage(), null);
	}
	/**
	 * 415 - Unsupported Media Type
	 */
	@ResponseStatus(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
	@ExceptionHandler(HttpMediaTypeNotSupportedException.class)
	public ResponseResult handleHttpMediaTypeNotSupportedException(Exception e) {
		logger.error("不支持当前媒体类型", e);
		return ResponseResult.ofError(405, "content_type_not_supported", null);
	}

	/**
	 * 500 - Internal Server Error
	 */
	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
	@ExceptionHandler(Exception.class)
	public ResponseResult handleException(Exception e) {

		logger.error("服务运行异常", e);
		if (e instanceof MissingServletRequestParameterException) {// 必填的参数没有

			return ResponseResult.ofError(e.getMessage());
		}

		if (e instanceof AccessDeniedException) {
			return ResponseResult.ofError(e.getMessage());
		}


		return ResponseResult.ofError(500, "server_error", null);
	}

}