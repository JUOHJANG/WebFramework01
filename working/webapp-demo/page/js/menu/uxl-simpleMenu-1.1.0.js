
var timeout         = 10;

var closetimer		= 0;
var subclosetimer	= 0;

var ddmenusubitem;
var wizProject = null;  // 프로젝트 마법사
var ddmenuitem;

uxl = {};

uxl.SimpleMenu = function(selector, callback){
	
	// menu 이벤트 핸들러
	function navtabs_open(){
		navtabs_canceltimer();
		navtabs_close();
		ddmenuitem = $(this).find('>.menu-sub-box').show();
	}

	function navtabs_close(){
		if(ddmenuitem){
			ddmenuitem.hide();
		}
	}

	function navtabs_timer(){
		closetimer = window.setTimeout(navtabs_close, timeout);
	}
	
	function navtabs_canceltimer(){	
		if(closetimer) {
			window.clearTimeout(closetimer);
			closetimer = null;
		}
	}
		
	function navtabs_sub_open(){
		navtabs_sub_all_close();
		$(this).find('>.menu-sub-box').show();
	}
	
	function navtabs_sub_all_close(){
		$(selector).find(".menu-sub-box .menu-sub-box").hide();
	}

	function navtabs_sub_close(){
		$(this).find('>.menu-sub-box').hide();
	}
	
	function _initialize(selector, callback) {
		
		$(selector+">li").bind('mouseover', navtabs_open);
		$(selector+">li").bind('mouseout', navtabs_timer);
		
		$(selector+" li li").click(function(){
			if($(this).hasClass("on")){
				$(this).removeClass("on");
				navtabs_sub_close.call(this, event);
			}else{
				//$(selector+" .menu-sub-item.on").removeClass("on");
				$(selector+" .pure-menu-li.on").removeClass("on");
				$(this).addClass("on");
				navtabs_sub_open.call(this, event);
			}
		});
		
		$(selector+" li li").mouseover(function(){
			if($(this).hasClass("on")){
				//$(this).removeClass("on");
				navtabs_sub_close.call(this, event);
			}else{
				//$(selector+" .menu-sub-item.on").removeClass("on");
				$(selector+" .pure-menu-li.on").removeClass("on");
				$(this).addClass("on");
				navtabs_sub_open.call(this, event);
			}
		});
		
		if (typeof callback == "function") {
			$(selector + " li:not(:has(.menu-sub-box, .menu-sub-box2)) a").bind('click', function(event){
				var menuUrl = $(this).attr('menuUrl');
				
				navtabs_sub_close.call(this, event);
				navtabs_close();
				callback.call(
					this,
					event,
					{
						menuId:$(this).attr('menuId'), 
						menuName:$(this).attr('menuName'), 
						menuUrl:menuUrl,
					});
			});
		}
	}
	
	$(function(){_initialize(selector, callback);});
	
};
