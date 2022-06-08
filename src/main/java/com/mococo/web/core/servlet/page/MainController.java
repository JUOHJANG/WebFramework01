package com.mococo.web.core.servlet.page;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mococo.microstrategy.sdk.prompt.servlet.MstrSdkServlet; 

/**
 * Servlet implementation class MainController
 */
@WebServlet("/main")
public class MainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(MstrSdkServlet.class);
	
//	@WebFilter("/*") 
//	public class FilterSample implements Filter {
//
//		//필터를 인터턴스화(초기 설정)될때 처리할 내용을 작성
//		public void init(FilterConfig fConfig) throws ServletException{ } 
//
//		//지정한 서블릿 클랫스가 호출될때 처리할 내용을 작성 
//		public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//		throws IOException, ServletException{
//			request.setCharacterEncoding("UTF-8");
//			chain.doFilter(request, response);
//		}
//
//		//필터 인스턴스가 파기되기전에 실행할 처리할 내용을 작성
//		public void destroy(){ } 
//	}
	
	/**
	 * @see Servlet#init(ServletConfig)
	 */
    @Override
	public void init(ServletConfig config) throws ServletException {
		super.init();
		// TODO Auto-generated method stub
	}
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MainController() {
        super();
        // TODO Auto-generated constructor stub
    } 

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if(checkSession(request,response)) {

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
				final String viewPath = "/plugins/main/jsp/main2.jsp";
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

	/**
	 * @see HttpServlet#doPut(HttpServletRequest, HttpServletResponse)
	 */
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doDelete(HttpServletRequest, HttpServletResponse)
	 */
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
	
	private boolean checkSession(HttpServletRequest request, HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException {
		   
			HttpSession session = request.getSession(false);

			Object mstrUser= session.getAttribute("mstr-user-vo");
			if(mstrUser==null) {
				 response.sendRedirect("/MicroStrategy/plugins/esm/jsp/sso.jsp?mstrUserId=demo");
			}
//			session.getAttributeNames().asIterator()
//	        .forEachRemaining(name -> logger.info("session name={}, value={}", name, session.getAttribute(name)));
			return true;
			
	}
 

	private String getSuccessResponseString(Object object) throws JsonGenerationException, JsonMappingException, IOException {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("isOk", true);
		result.put("data", object);
		return new ObjectMapper().writeValueAsString(result);
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