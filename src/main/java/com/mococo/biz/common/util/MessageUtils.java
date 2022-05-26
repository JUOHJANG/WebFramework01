package com.mococo.biz.common.util;

import java.util.Locale;

import org.springframework.context.support.MessageSourceAccessor;

public class MessageUtils {
	private static MessageSourceAccessor msAcc = null;
	
	public void setMessageSourceAccessor(MessageSourceAccessor msAcc) {
		MessageUtils.msAcc = msAcc;
	}
	
	public static String getMessage(String code) {
		// Locale.getDefault()는 운영체제의 기본 언어값으로 읽어온다
		return msAcc.getMessage(code, Locale.getDefault());
	}
	
	public static String getMessage(String code, Object[] objs) {
		return msAcc.getMessage(code, objs, Locale.getDefault());
	}
	
	public static String getMessage(String code, Object[] objs, Locale locale) {
		return msAcc.getMessage(code, objs, locale);
	}
}
