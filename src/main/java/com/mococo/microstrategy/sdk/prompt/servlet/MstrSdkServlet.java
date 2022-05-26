package com.mococo.microstrategy.sdk.prompt.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
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
import com.mococo.microstrategy.sdk.exception.SdkRuntimeException;
import com.mococo.microstrategy.sdk.prompt.cache.CacheManager;
import com.mococo.microstrategy.sdk.prompt.cache.CacheManager.CacheObjectType;
import com.mococo.microstrategy.sdk.prompt.config.MstrSessionProvider;
import com.mococo.microstrategy.sdk.prompt.prop.PropManager;

/**
 * Servlet implementation class MstrSdkServlet
 */
public class MstrSdkServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(MstrSdkServlet.class);
	private static MstrSessionProvider mstrSessionProvider = null;
	
    @Override
	public void init() throws ServletException {
		super.init();
		
		Map<String, String> providerConfig = PropManager.<String>getProp("mstrSessionProvider");
		String providerName = providerConfig.get("className");
		try {
			Class<?> clazz = MstrSdkServlet.class.getClassLoader().loadClass(providerName);
			mstrSessionProvider = (MstrSessionProvider)clazz.newInstance(); 
		} catch (ClassNotFoundException | InstantiationException | IllegalAccessException e) {
			logger.error("!!! error load Mstr Session Provider", e);
		}
	}

	/**
     * @see HttpServlet#HttpServlet()
     */
    public MstrSdkServlet() { super(); }

    	private RequestHandler<?> getHandler(String serviceId) {
    		RequestHandler<?> handler = null;
    		
    		try {
    			Map<String, String> requestHandlerConfig = PropManager.<String>getProp("requestHandler"); 
    			
    			String handlerClassName = (String)requestHandlerConfig.get(serviceId);
    			
    			handler = CacheManager.<RequestHandler<?>>getCache(CacheManager.getCacheItemId(CacheObjectType.REQUEST_HANDLER, handlerClassName));
    			if (handler == null) {
    				Class<?> clazz = MstrSdkServlet.class.getClassLoader().loadClass(handlerClassName);
    				handler = (RequestHandler<?>)clazz.newInstance();
    				CacheManager.<RequestHandler<?>>setCache(CacheManager.getCacheItemId(CacheObjectType.REQUEST_HANDLER, handlerClassName), handler);
    			}
    		} catch (Exception e) {
    			logger.error("!!! RequestHandler instantiate error.", e);
    		}
    		
    		return handler;
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
    	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StringBuilder builder = new StringBuilder();
		
		try {
			BufferedReader reader = request.getReader();
			String line = null;
			while ((line = reader.readLine()) != null) {
				builder.append(line);
			}
			
			Map<String, Object> param = null;
			RequestHandler<?> handler = null;
			String serviceId = null;
			if (StringUtils.isNotEmpty(builder.toString())) {
				param = new ObjectMapper().readValue(builder.toString(), new TypeReference<Map<String, Object>>() {});
				logger.debug("==> param: [{}]", param);
				serviceId = (String)param.get("serviceId");
				handler = getHandler(serviceId);
			}
			
			if (handler != null) {
				writeResponse(response, getSuccessResponseString(handler.GetResponse(mstrSessionProvider, param)));
			} else {
				writeResponse(response, getFailResponseString(new SdkRuntimeException("request handler not found, serviceId: [" + serviceId + "]")));
			}
		} catch (Exception e) {
			logger.error("!!! error ", e);
			writeResponse(response, getFailResponseString(e));
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
