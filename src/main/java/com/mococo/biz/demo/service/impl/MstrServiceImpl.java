package com.mococo.biz.demo.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mococo.biz.common.dao.SimpleBizDao;
import com.mococo.biz.demo.service.MstrService;

@Service(value = "mstrService") 
public class MstrServiceImpl implements MstrService {
	private static final Logger logger = LoggerFactory.getLogger(MstrServiceImpl.class);

	@Autowired
	private SimpleBizDao simpleBizDao;
	
	@Override
	public List<Map<String, Object>> getBulletinList(Map<String, Object> param) {
		List<Map<String, Object>> list = simpleBizDao.list("bulletin.list", param);
		logger.debug("=> list: {}", list);
		
		return list;
	}
}
