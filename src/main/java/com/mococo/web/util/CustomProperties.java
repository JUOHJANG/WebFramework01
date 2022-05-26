package com.mococo.web.util;

import java.util.Properties;

/**
 * Application Scope에서 사용할 porperties를 singleton으로 관리
 * <br/><b>History</b><br/>
 * <pre>
 * 2012. 2. 23. 최초작성
 * </pre>
 * @author 박형일
 * @version 1.0
 */
final public class CustomProperties {
	private static final String DFT_PTH = "/properties/";
	private static final String DFT_NAM = "app.xml";
	private static final String DFT_RTN = "";
	
	private static PropertiesHolder<CustomProperties> holder = new PropertiesHolder<CustomProperties>(
		new CustomProperties(),
		new PropertiesHolder.AbstractPropertiesLoader() {
			@Override
			public Properties load() {
				return PropertiesHolder.loadFromXml(DFT_PTH + DFT_NAM);  
			}			
		},
		CustomProperties.DFT_RTN
	);
	
	private CustomProperties() { }
	
	public static String getProperty(final String pid) { return holder.getString(pid); }
	
}
