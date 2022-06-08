package com.mococo.biz.demo.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.microstrategy.web.objects.WebIServerSession;
import com.microstrategy.web.objects.WebObjectsException;
import com.microstrategy.webapi.EnumDSSXMLObjectTypes;
import com.mococo.biz.demo.service.MstrService;
import com.mococo.microstrategy.sdk.core.util.MstrFolderBrowseUtil;
import com.mococo.microstrategy.sdk.core.util.MstrReportUtil;
import com.mococo.microstrategy.sdk.core.util.MstrUtil;
import com.mococo.microstrategy.sdk.core.vo.MstrUser;
import com.mococo.microstrategy.sdk.prompt.ReportCharger;
import com.mococo.microstrategy.sdk.prompt.vo.Report;
import com.mococo.web.core.util.ControllerUtil;
import com.mococo.web.core.util.CustomProperties;

@Controller
public class MstrController {
	private static final Logger logger = LoggerFactory.getLogger(MstrController.class);
	
	@Autowired 
	private MstrService mstrService; 
	
	private static final String getUid(HttpServletRequest request) {
		MstrUser mstrUser = (MstrUser)request.getSession().getAttribute("mstr-user-vo");

		String userId = null;
		
		if (mstrUser != null) { userId = mstrUser.getId(); }
		
		return userId;
	}
	
	@RequestMapping(value = "/getReportInfo.json", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getReportInfo(@RequestBody final Map<String, Object> param, final HttpServletRequest request) {
		logger.debug("=> param : [{}]", param);
		
		String objectId = (String)param.get("objectId");
		int type = (int)param.get("type");
		String uid = getUid(request);
		
		logger.debug("=> objectId:[{}], type:[{}], uid:[{}]", objectId, type, uid);

		Map<String, Object> success = ControllerUtil.getSuccessMap();
		
		WebIServerSession session = null;
		try {
			session = MstrUtil.connectTrustSession(CustomProperties.getProperty("mstr.default.server"), CustomProperties.getProperty("mstr.default.project"), uid, CustomProperties.getProperty("mstr.trust.token"));
	    	Report report = ReportCharger.chargeObject(session, type, objectId);
	    	
	    	logger.debug("==> report: [{}]", report);
			
			success.put("report", report);
		} catch (WebObjectsException e) {
			logger.error("!!! error", e);
		} catch (Exception e) {
			logger.error("!!! error", e);
		} finally {
			MstrUtil.closeISession(session);
		}
		
		return success;
	}
	
	@RequestMapping(value = "/getAnswerXML.json", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getAnswerXML(@RequestBody final Map<String, Object> param, final HttpServletRequest request) {
		logger.debug("=> param : [{}]", param);
		
		String objectId = (String)param.get("objectId");
		int type = (int)param.get("type");
		String uid = getUid(request);

		Map<String, List<String>> promptVal = (Map<String, List<String>>)param.get("promptVal");
		
		logger.debug("=> objectId:[{}], type:[{}], uid:[{}]", objectId, type, uid);
		logger.debug("=> promptVal : [{}]", promptVal);
		
		Map<String, Object> success = ControllerUtil.getSuccessMap();
		
		WebIServerSession session = null;
		try {
			session = MstrUtil.connectTrustSession(CustomProperties.getProperty("mstr.default.server"), CustomProperties.getProperty("mstr.default.project"), uid, CustomProperties.getProperty("mstr.trust.token"));
			String xml = MstrReportUtil.getReportAnswerXML(session, objectId, type, promptVal);
			success.put("xml", xml);
		} catch (WebObjectsException e) {
			logger.error("!!! error", e);
		} catch (Exception e) {
			logger.error("!!! error", e);
		} finally {
			MstrUtil.closeISession(session);
		}
		
		return success;
	}
	
	//원래 포탈 메뉴 리스트 조회하는 json 메소드
	@RequestMapping(value = "/getFolderList.json", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getFolderList(@RequestBody final Map<String, Object> param, @SessionAttribute("mstr-user-vo") MstrUser mstrUser) {
		Map<String, Object> success = ControllerUtil.getSuccessMap();

		logger.debug("=> param111:[{}]", param);
		logger.debug("=> mstrUser:[{}]", mstrUser);
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		WebIServerSession session = null;
		try {
			String server = MstrUtil.getLiveServer(CustomProperties.getProperty("mstr.default.server"));
			String project = CustomProperties.getProperty("mstr.default.project.name");
			String uid = mstrUser.getId();
			String folderId = (String)param.get("folderId");
			String trustToken = CustomProperties.getProperty("mstr.trust.token");
			
			logger.debug("=> server:[{}], project:[{}], uid:[{}], folderId:[{}], trustToken:[{}]", server, project, uid, folderId, trustToken);

			
			session = MstrUtil.connectTrustSession(server, project, uid, CustomProperties.getProperty("mstr.trust.token"));
			list = MstrFolderBrowseUtil.getFolderTree(
						session, folderId, -1, 
						Arrays.asList(
								EnumDSSXMLObjectTypes.DssXmlTypeFolder, 
								EnumDSSXMLObjectTypes.DssXmlTypeReportDefinition, 
								EnumDSSXMLObjectTypes.DssXmlTypeDocumentDefinition, 
								EnumDSSXMLObjectTypes.DssXmlTypeShortcut
						)
			);
			
			success.put("folder", list);
		} catch (Exception e) {
			logger.error("!!! error", e);
			
			throw new RuntimeException();
		} finally {
			if (session != null) { try { session.closeSession(); } catch (WebObjectsException e) { logger.error("!!! error", e); } }
		}				
		return success;
	}
}