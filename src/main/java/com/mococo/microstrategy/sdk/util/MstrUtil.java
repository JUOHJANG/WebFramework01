package com.mococo.microstrategy.sdk.util;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microstrategy.utils.localization.LocaleInfo;
import com.microstrategy.web.objects.WebCluster;
import com.microstrategy.web.objects.WebClusterAdmin;
import com.microstrategy.web.objects.WebElement;
import com.microstrategy.web.objects.WebElements;
import com.microstrategy.web.objects.WebIServerSession;
import com.microstrategy.web.objects.WebObjectInfo;
import com.microstrategy.web.objects.WebObjectSource;
import com.microstrategy.web.objects.WebObjectsException;
import com.microstrategy.web.objects.WebObjectsFactory;
import com.microstrategy.webapi.EnumDSSXMLApplicationType;
import com.microstrategy.webapi.EnumDSSXMLAuthModes;
import com.microstrategy.webapi.EnumDSSXMLObjectFlags;
import com.mococo.microstrategy.sdk.exception.SdkRuntimeException;

public class MstrUtil {
	private static final Logger logger = LoggerFactory.getLogger(MstrUtil.class);

	private MstrUtil() {}
	
	public static String getLiveServer() throws WebObjectsException {
		return getLiveServer(null);
	}
	
	public static String getLiveServer(String defaultServer) throws WebObjectsException {
		WebClusterAdmin admin = WebObjectsFactory.getInstance().getClusterAdmin();
		admin.refreshAllClusters();
		String serverName = defaultServer;
		Enumeration<WebCluster> clusters = admin.getClusters().elements();
		if (clusters.hasMoreElements()){
			WebCluster cluster = clusters.nextElement();
			serverName = cluster.get(0).getNodeName();

		}

		return serverName;
	}



	public static WebIServerSession connectSession(String server, int port, String project, String uid, String pwd, int authMode, int localeNum, String trustToken, String clientId) throws WebObjectsException {
	    WebIServerSession session = null;
		
		String serverName =	getLiveServer(server);
		
		if (StringUtils.isEmpty(serverName) || StringUtils.isEmpty(uid)) { throw new RuntimeException("서버명 또는 사용자ID가 비어있습니다."); }
		if (authMode == EnumDSSXMLAuthModes.DssXmlAuthSimpleSecurityPlugIn && StringUtils.isEmpty(trustToken)) { throw new RuntimeException("트러스트인증 토큰이 비어있습니다."); }
			
		session = WebObjectsFactory.getInstance().getIServerSession();
	    session.setServerName(serverName);
	    session.setServerPort(0);
	    if (StringUtils.isNotEmpty(project)) { session.setProjectName(project); }
	    session.setLogin(uid); 
    	session.setAuthMode(authMode);
    	
	    switch (authMode) {
	    case EnumDSSXMLAuthModes.DssXmlAuthStandard :
	    case EnumDSSXMLAuthModes.DssXmlAuthLDAP :
	    	session.setPassword(pwd);
	    	break;
	    case EnumDSSXMLAuthModes.DssXmlAuthSimpleSecurityPlugIn :
	    	session.setTrustToken(trustToken);
	    	break;
	    }
	    
	    Locale locale = LocaleInfo.getInstance(localeNum).getLocale();
	    session.setDisplayLocale(locale);
	    session.setLocale(locale);
        session.setApplicationType(EnumDSSXMLApplicationType.DssXmlApplicationDSSWeb);
        // session.setApplicationType(com.microstrategy.webapi.EnumDSSXMLApplicationType.DssXmlApplicationCustomApp);
        if (StringUtils.isNotEmpty(clientId)) { session.setClientID(clientId); }
        session.getSessionID();

		return session;
	}
	
	public static WebIServerSession connectSession(String server, String project, String uid, String pwd) throws WebObjectsException {
		return connectSession(server, 0, project, uid, pwd, EnumDSSXMLAuthModes.DssXmlAuthStandard, 1042, null, null);
	}
	
	public static WebIServerSession connectTrustSession(String server, String project, String uid, String trustToken) throws WebObjectsException {
	    return connectSession(server, 0, project, uid, null, EnumDSSXMLAuthModes.DssXmlAuthSimpleSecurityPlugIn, 1042, trustToken, null);
	}	

	public static WebIServerSession reconnectSession(String sessionState) throws WebObjectsException {
		if (StringUtils.isEmpty(sessionState)) { return null; }
		
		WebIServerSession session = WebObjectsFactory.getInstance().getIServerSession();
		
		session.restoreState(sessionState);
		if (!session.isAlive()) { session.reconnect(); }
		
		return session;
	}
	
	public static void closeISession(WebIServerSession wss) throws SdkRuntimeException {
		try {
			if (wss != null)
				wss.closeSession();
	    } catch (WebObjectsException e) {
			if (e.getErrorCode() != -2147205069) {
				logger.error("error !!!", e);
			}
		} catch (Exception e) {
			logger.error("error !!!", e);
			throw new SdkRuntimeException(e); 
		}
	}
	
	public static void closeISession(String sessionState) {
    	try {
    		WebIServerSession session = WebObjectsFactory.getInstance().getIServerSession();
    		session.restoreState(sessionState);
    		
    		if (session.isAlive()) {
    			session.closeSession();
    		}
    	} catch (WebObjectsException e) {
        	logger.error("!!! error", e);
    	}			
	}
	
	public static String logWebElements(WebElements webElements) {
		StringBuilder builder = new StringBuilder();
		Enumeration<WebElement> e = webElements.elements();
		
		builder.append("{");
		while (e.hasMoreElements()) {
			WebElement webElement = e.nextElement();
			builder
				.append("id:").append(webElement.getID())
				.append(", elementId:").append(webElement.getElementID())
				.append(", displayName:").append(webElement.getDisplayName());
		}
		builder.append("}");
		
		return builder.toString();
		
	}
	
	public static Map<String, Object> getLongDesc(WebObjectInfo object, WebIServerSession session) {
		WebObjectSource source = session.getFactory().getObjectSource();
		source.setFlags(source.getFlags() | EnumDSSXMLObjectFlags.DssXmlObjectComments);
		
		Map<String, Object> configInfo = null;
		if (object != null) { 
			try {
				WebObjectInfo info = source.getObject(object.getID(), object.getType(), true);
				
				if (info.getComments() != null && info.getComments().length > 0) {
					String json = info.getComments()[0];
					
					if (StringUtils.isNotEmpty(json)) {
						configInfo = new ObjectMapper().readValue(json, new TypeReference<Map<String, Object>>() {});
					}
				}
			} catch (WebObjectsException | IllegalArgumentException e) {
				logger.error("!!! error", e);
			} catch (IOException e) {
				logger.error("!!! json [{}] parsing error", e);
			}

		}
		
		return configInfo;
	}	
	
}