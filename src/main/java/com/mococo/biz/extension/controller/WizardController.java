package com.mococo.biz.extension.controller;

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
import com.mococo.biz.extension.service.WizardService;
import com.mococo.microstrategy.sdk.esm.vo.MstrUser;
import com.mococo.microstrategy.sdk.util.MstrFolderBrowseUtil;
import com.mococo.microstrategy.sdk.util.MstrReportUtil;
import com.mococo.microstrategy.sdk.util.MstrUtil;
import com.mococo.web.util.ControllerUtil;
import com.mococo.web.util.CustomProperties;

@Controller
public class WizardController {
	private static final Logger logger = LoggerFactory.getLogger(WizardController.class);
	
	@Autowired 
	private WizardService wizardService; 
	
	private static final String getUid(HttpServletRequest request) {
		MstrUser mstrUser = (MstrUser)request.getSession().getAttribute("mstr-user-vo");

		String userId = null;
		
		if (mstrUser != null) { userId = mstrUser.getId(); }
		
		return userId;
	}

	
	//마지막 레벨 선택 후, 해당레벨의 테이블(mstr에서 폴더)목록 조회 
	@RequestMapping(value = "/getTableList.json", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getFolderList2(@RequestBody final Map<String, Object> param, @SessionAttribute("mstr-user-vo") MstrUser mstrUser) {
		Map<String, Object> success = ControllerUtil.getSuccessMap();

		logger.debug("=> param:[{}]", param);
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		WebIServerSession session = null;
		try {
			String server = MstrUtil.getLiveServer(CustomProperties.getProperty("mstr.default.server"));
			String project = CustomProperties.getProperty("mstr.default.project.name");
			String uid = mstrUser.getId();
			
			String folderId = (String)param.get("lastfolderId");
			logger.debug("=> lastfolderId:[{}]", folderId);
			String folderDepth = (String) param.get("fldDepth");
			String objTp = (String)param.get("ObjectType");
			
			int ifolderDepth = Integer.parseInt(folderDepth);
			
			String trustToken = CustomProperties.getProperty("mstr.trust.token");
			
			//logger.debug("=> server:[{}], project:[{}], uid:[{}], folderId:[{}], trustToken:[{}]", server, project, uid, folderId, trustToken);

			List<Integer> listObjType = null;
			if (objTp.equalsIgnoreCase("FolderList")) {
				listObjType = Arrays.asList(
						EnumDSSXMLObjectTypes.DssXmlTypeFolder
				);
			} else {
				// Object List 
				listObjType =Arrays.asList(
						EnumDSSXMLObjectTypes.DssXmlTypeFolder,
						EnumDSSXMLObjectTypes.DssXmlTypeShortcut
				);
			}
			
			session = MstrUtil.connectTrustSession(server, project, uid, CustomProperties.getProperty("mstr.trust.token"));
			list = MstrFolderBrowseUtil.getFolderTree(session, folderId, ifolderDepth, listObjType);
			if (!objTp.equalsIgnoreCase("FolderList")) {
				List<Map<String, Object>> listResult = new ArrayList<Map<String, Object>>();
				excludeFolderObjectList(listResult, list);
				
				list = listResult;
			}
			
			success.put("folder", list);
		} catch (Exception e) {
			logger.error("!!! error", e);
			
			throw new RuntimeException();
		} finally {
			if (session != null) { try { session.closeSession(); } catch (WebObjectsException e) { logger.error("!!! error", e); } }
		}				
		return success;
	}	

	@RequestMapping(value = "/getAttrMetricInfo.json", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> save_report(@RequestBody final Map<String, Object> Param, @SessionAttribute("mstr-user-vo") MstrUser mstrUser) {
		
		Map<String, Object> success = ControllerUtil.getSuccessMap();
		WebIServerSession session = null;

		ArrayList<String> attribute = (ArrayList<String>) Param.get("Attribute");
		ArrayList<String> metric = (ArrayList<String>) Param.get("Metric");
		ArrayList<String> prompt = (ArrayList<String>) Param.get("Prompt");
		String reportName = (String) Param.get("ReportName");
		
		logger.error("!!! reportName", reportName);

		success.put("saveObjId","failed");
		try {
			
			String server = MstrUtil.getLiveServer(CustomProperties.getProperty("mstr.default.server"));
			String project = CustomProperties.getProperty("mstr.default.project.name");
			String uid = mstrUser.getId();
			session = MstrUtil.connectTrustSession(server, project, uid, CustomProperties.getProperty("mstr.trust.token"));
			
			String saveObjId = MstrReportUtil.ExecuteReport(session, attribute, metric, prompt, 0, 0, reportName);
			success.put("saveObjId", saveObjId);
		} catch (WebObjectsException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return success;
	}	
	
   private void excludeFolderObjectList(List<Map<String, Object>> listResult, List<Map<String, Object>> listArgs) {
	   int tmpVal = -1;
	   List<Map<String, Object>> tmpChild = null; 
	   for(Map<String, Object> tmpObjInfo : listArgs) {
		    tmpVal = (int) tmpObjInfo.get("type");
		    if (tmpVal == 8) { //folder type
				tmpChild = (List<Map<String, Object>>) tmpObjInfo.get("child");
				excludeFolderObjectList(listResult, tmpChild);
			} else {
				listResult.add(tmpObjInfo);
			}
		}
   }	
}