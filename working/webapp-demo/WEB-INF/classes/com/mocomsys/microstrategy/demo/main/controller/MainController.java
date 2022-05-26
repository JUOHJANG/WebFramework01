package com.mocomsys.microstrategy.demo.main.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.microstrategy.utils.StringUtils;
import com.microstrategy.web.objects.WebIServerSession;
import com.microstrategy.web.objects.WebObjectsFactory;
import com.microstrategy.webapi.EnumDSSXMLApplicationType;
import com.microstrategy.webapi.EnumDSSXMLAuthModes;
import com.mocomsys.microstrategy.sdk.util.MstrFolderBrowseUtil;

@Controller
@RequestMapping("/main/*")
public class MainController {
	private static final Logger logger = LoggerFactory.getLogger(MainController.class); 

	private WebIServerSession getMstrSession(String serverName, String projectName, String userId, String userPwd) {
		WebObjectsFactory factory = WebObjectsFactory.getInstance();
		WebIServerSession session = factory.getIServerSession();
	
		try {
			session.setServerName(serverName);		
			session.setServerPort(0);			
			session.setProjectName(projectName);
			session.setLogin(userId);
			session.setPassword(userPwd);		
			session.setAuthMode(EnumDSSXMLAuthModes.DssXmlAuthStandard);
			session.setApplicationType(EnumDSSXMLApplicationType.DssXmlApplicationDSSWeb);
			session.setClientID(userId);
			
			session.getSessionID();			
		} catch(Exception e) {
			e.printStackTrace();
		}		
		
		return session;
	}
	
	@RequestMapping("/subMenu.json")
	@ResponseBody
	public Map<String, Object> getSubMenu(@RequestBody final Map<String, Object> param) throws Exception {
		String serverName = (String)param.get("SERVER_NAME");
		String projectName = (String)param.get("PROJECT");
		String userId = (String)param.get("USER_ID");
		String userPwd = (String)param.get("USER_PWD");
		String folderId = (String)param.get("FOLDER_ID");
		
		logger.debug("param:" + param);
		
		WebIServerSession isession = getMstrSession(serverName, projectName, userId, userPwd);
		List<Map<String, Object>> list = MstrFolderBrowseUtil.getFolderTree(isession, folderId, -1, null);
		
		Map<String, Object> subMenu	= new HashMap<String, Object>();
		subMenu.put("list", list);
		
        return subMenu;
    }
	
	@RequestMapping("/main/mstrSessionCheck.json")
	@ResponseBody
	public Map<String, Boolean> mstrSessionCheck(HttpServletRequest request) {
		String usrSmgr = (String)request.getSession(false).getAttribute("usrSmgr");
		
		Map<String, Boolean> map = new HashMap<String, Boolean>();
		
		if (StringUtils.isNotEmpty(usrSmgr)) {
			try {
				WebIServerSession session = WebObjectsFactory.getInstance().getIServerSession();
				session.restoreState(usrSmgr);
				session.getSessionID();			
				
				logger.debug("isAlive:" + session.isAlive());
				
				map.put("result", session.isAlive());
			} catch (Exception e) {
				e.printStackTrace();
				map.put("result", false);
			}
		} else {
			map.put("result", false);
		}
		
		return map;
	}		
}
