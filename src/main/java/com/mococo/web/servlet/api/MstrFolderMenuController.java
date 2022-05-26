package com.mococo.web.servlet.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microstrategy.web.objects.WebIServerSession;
import com.microstrategy.web.objects.WebObjectsException;
import com.microstrategy.webapi.EnumDSSXMLObjectTypes;
import com.mococo.microstrategy.sdk.esm.vo.MstrUser;
import com.mococo.microstrategy.sdk.prompt.servlet.MstrSdkServlet;
import com.mococo.microstrategy.sdk.util.MstrFolderBrowseUtil;
import com.mococo.microstrategy.sdk.util.MstrUtil;
import com.mococo.web.util.ControllerUtil;
import com.mococo.web.util.CustomProperties;

//1레벨 ~ 마지막레벨까지 메뉴 조회하는 API
@WebServlet("/api/folderMenu")
public class MstrFolderMenuController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(MstrSdkServlet.class);

    /**
     * @see HttpServlet#HttpServlet()
     */
    public MstrFolderMenuController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 			 
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, Object> success = ControllerUtil.getSuccessMap(); 
		Map<String, Object> param = null; 
		StringBuilder builder = new StringBuilder();
		HttpSession session_ = request.getSession(false); 
		Object mstrUser= session_.getAttribute("mstr-user-vo");
		logger.debug("==> builder: [{}]", builder); 
		MstrUser user = (MstrUser) mstrUser;
		
		if (StringUtils.isNotEmpty(builder.toString())) {
			param = new ObjectMapper().readValue(builder.toString(), new TypeReference<Map<String, Object>>() {});
			logger.debug("==> param: [{}]", param); 
			
		}  
		logger.debug("==> getParameter: [{}]", request.getParameter("wizard_id")); 

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		WebIServerSession session = null;
		try {
			String server = MstrUtil.getLiveServer(CustomProperties.getProperty("mstr.default.server"));
			String project = CustomProperties.getProperty("mstr.default.project.name");
			String uid = user.getId();
			
			String wizardId = (String)request.getParameter("wizard_id");
			String trustToken = CustomProperties.getProperty("mstr.trust.token");
			
			logger.debug("=> server:[{}], project:[{}], uid:[{}], folderId:[{}], trustToken:[{}]", server, project, uid, wizardId, trustToken);

		
			session = MstrUtil.connectTrustSession(server, project, uid, CustomProperties.getProperty("mstr.trust.token"));
			list = MstrFolderBrowseUtil.getFolderTree(
						session, wizardId, 4, 
						Arrays.asList(
								EnumDSSXMLObjectTypes.DssXmlTypeFolder
						)
			);
			
			success.put("wizardfolder", list);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.print(new ObjectMapper().writeValueAsString(success));
			out.flush();
		} catch (Exception e) {
			logger.error("!!! error", e);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.print("Eorror!!");
			out.flush();
			throw new RuntimeException();
		} finally {
			if (session != null) { try { session.closeSession(); } catch (WebObjectsException e) { logger.error("!!! error", e); } }
		}	
	}

}