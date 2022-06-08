package com.mococo.web.core.servlet.page;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mococo.microstrategy.sdk.prompt.servlet.MstrSdkServlet;
import com.mococo.web.core.util.HttpServletUtil;

/**
 * Servlet implementation class WizardController
 */
@WebServlet("/wizard")
public class WizardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(MstrSdkServlet.class);

    /**
     * @see HttpServlet#HttpServlet()
     */
    public WizardController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(HttpServletUtil.checkSession(request,response)) {

			StringBuilder builder = new StringBuilder();
			request.setCharacterEncoding("UTF-8"); 
	        response.setContentType("text/html; charset=utf-8");
			
			try {
				BufferedReader reader = request.getReader();
				String line = null;
				while ((line = reader.readLine()) != null) {
					builder.append(line);
				}
				
				Map<String, Object> param = null; 
				if (StringUtils.isNotEmpty(builder.toString())) {
					param = new ObjectMapper().readValue(builder.toString(), new TypeReference<Map<String, Object>>() {});
					logger.debug("==> param: [{}]", param); 
					
				} 
	//	        request.setAttribute("member", member); 
				final String viewPath = "/plugins/main/jsp/wizard.jsp";
			    final RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
			    dispatcher.forward(request, response);
	//			writeResponse(response,  getSuccessResponseString("TEST"));
				 
			} catch (Exception e) {
				logger.error("!!! error ", e);
				writeResponse(response, getFailResponseString(e));
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	private String getFailResponseString(Exception e) throws JsonGenerationException, JsonMappingException, IOException {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("isOk", false);
		result.put("message", e.getMessage());
		return new ObjectMapper().writeValueAsString(result); 
	}

	private void writeResponse(HttpServletResponse response, String json) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(json);
		out.flush();
	} 
 

}