function renderMenu(folder) {
	navigateDepthFirst(
		{"id":"root", "child":folder},
		function (ref, stack) { // javascript 객체를 트리 탐색 시 각 노드에 대해 호출되는 콜백함수
			var parentId = undefined;
			if (stack && stack.length > 0) { parentId = stack[stack.length - 1]["id"]; }
			
			var $parent = $("#reportMenu [report-id='" + parentId + "']");
			if ($parent.get(0) != undefined) {
				var $child = $("<div class='menu-node' report-id='" + ref["id"] + "' type='" + ref["type"] + "' is-vi='" + ref["isVI"] + "'><span>" + ref["name"] + "</span></div>");

				$("span", $child).on("click", function() { 
					
					var $parent = $(this).parent();
					var type = $parent.attr("type");
					var Server = 'DESKTOP-NE4ATKU';
					var Project = 'MicroStrategy Tutorial';		
					
					if (type == "8") {
						loadTableInfo($parent.attr("report-id"));
					} 

				});
				$parent.append($child);
				
			} 
		},
		"child"
	);		
}

function menuChild(ele,data){
	ele = ele + '>li:last-child';
	if(data.child[0]){
		$(ele).append('<ul></ul>');
		data.child.forEach((child, index) => {
			$(ele+'>ul').append('<li><div data-report-id="'+child.id+'" onClick="loadTableInfo(\''+child.id+'\')">'+child.name+'</div></li>');
			menuChild(ele+'>ul',child) 
		})
	}
}
/*
 * date : 2022-04-25
 * 1레벨 ~ 마지막레벨까지 메뉴 조회
 *MstrController.java의 @RequestMapping = getFolderMenu 참조
 */
function loadMenu() {
	var option = {
		url: contextPath+"/api/folderMenu",			
		type: "post",
		data: {wizard_id: wizardId},
		contentType: "application/x-www-form-urlencoded;charset=utf-8",
		dataType: "json",
		success: function(result) {
			console.log(result)
			result.wizardfolder.forEach((fristEl, index) => {
				$('#menu').append('<li><div>'+fristEl.name+'</div></li>');
				menuChild('#menu',fristEl)
				/* if(fristEl.child[0]){
					$('#menu>li:last-child').append('<ul></ul>');
					fristEl.child.forEach((secondEl, index) => {
						$('#menu>li:last-child>ul').append('<li><div>'+secondEl.name+'</div></li>');
						if(secondEl.child[0]){
							$('#menu>li:last-child>ul>li:last-child').append('<ul></ul>');
							secondEl.child.forEach((thirdEl, index) => {
								$('#menu>li:last-child>ul>li:last-child ul').append('<li><div>'+thirdEl.name+'</div></li>');
								if(thirdEl.child[0]){
									$('#menu>li:last-child>ul>li:last-child').append('<ul></ul>');
									thirdEl.child.forEach((fourthEl, index) => {
										$('#menu>li:last-child>ul>li:last-child ul').append('<li><div>'+fourthEl.name+'</div></li>');
									}) 
								}
							}) 
						}
					}) 
				} */
			});
			
			 

			$( "#menu" ).menu();
			// 서버로부터 응답을 받는 시점에서 호출되는 콜백함수
			if (result && result["errorCode"] == "success") {
				renderMenu(result["wizardfolder"]);
			} else {
				alert("메뉴정보 조회 중 오류가 발생하였습니다.");
			}
		},
		error: function() { 
			alert("메뉴정보 조회 중 오류가 발생하였습니다.");
		},
		async: true
	};				
	$.ajax(option);
}

/*
 * date : 2022-04-25
 * 마지막 레벨 선택 후, 해당레벨의 테이블(mstr에서 폴더)목록 조회
 * MstrController.java의 @RequestMapping = getFolderBrowse 참조
 */
function loadTableInfo(SelectFldId) {
		// json으로 메뉴정보를 조회
		$('#sortable1,#sortable1-2').empty();
		$('#sortable1,#sortable1-2').text('loading...');
 
		var option = {
			url: contextPath+"/app/getTableList.json",			
			type: "post",
			data: JSON.stringify({"lastfolderId" : SelectFldId, "fldDepth":"1", "ObjectType":"FolderList"}),
			contentType: "application/json;charset=utf-8",
			dataType: "json",
			success: function(result) {
				// 서버로부터 응답을 받는 시점에서 호출되는 콜백함수
				if (result && result["errorCode"] == "success") {
					console.log(result);
					$('#sortable1,#sortable1-2').empty();
					var aListFolder = result.folder; 
					for(var i=0; i<aListFolder.length; i++) {
						$('#sortable1').append('<li data-obj_id="'+aListFolder[i].id+'" class="'+aListFolder[i].id+' active" onclick="loadObject(\''+aListFolder[i].id+'\')">'+aListFolder[i].name + '</li>');
					}
				} else {
					alert("메뉴정보 조회 중 오류가 발생하였습니다.");
				}
				
				$("li", $('div.list')).on("click", function() {
					loadObject($(this).attr('obj_id'));
				});
				
			},
			error: function() { 
				alert("메뉴정보 조회 중 오류가 발생하였습니다.");
			},
			async: true
		};				
		
		$.ajax(option);
	}


/*
 * date : 2022-04-25
 * 마지막 레벨 선택 후, 해당레벨의 테이블(mstr에서 폴더)목록 조회
 * /MstrController.java의 @RequestMapping = getFolderBrowse 참조
 */
function loadObject(SearchObj) {
		// json으로 메뉴정보를 조회
		
//		$('#sortable2,#sortable2-2').empty();
//		$('#sortable3,#sortable3-2').empty();
//		
//		$('#sortable2,#sortable2-2').text('loading...');
//		$('#sortable3,#sortable3-2').text('loading...');
		if( !$( '#sortable1 .' + SearchObj ).hasClass('active')){ 
			console.log(!$( '#sortable1 .' + SearchObj ).hasClass('active'))
			return ;
		}
	    $( '.' + SearchObj ).removeClass( 'active' ); 
	    $('#sortable1-2').append('<li obj_name="'+ $( '.' + SearchObj ).text() + '" obj_id="'+SearchObj+'" class="'+SearchObj+' active" onclick="removeObject(\''+ SearchObj +'\')">'+ $( '.' + SearchObj ).text() + '</li>')
		var option = {
			url: contextPath+"/app/getTableList.json",			
			type: "post",
			data: JSON.stringify({"lastfolderId" : SearchObj, "fldDepth":"-1", "ObjectType":"objs"}),
			contentType: "application/json;charset=utf-8",
			dataType: "json",
			success: function(result) {
				// 서버로부터 응답을 받는 시점에서 호출되는 콜백함수
				if (result && result["errorCode"] == "success") {
					//console.log(result);


					var attrObject = result.folder;
					$('#sortable2,#sortable2-2').empty();
					//$('#sortable3,#sortable3-2').empty();
					$('#accordion').empty();
					const cnt = $('#attribute li').length;
					$('#attribute li').addClass('first')
					for(var i=0; i<attrObject.length; i++) {
						if(attrObject[i].type == "12"){  
							let requiredName = "";  
							if(attrObject[i].name.substr(0,required_prefix.length) == required_prefix){
								requiredName = "Required"; 
							} 
								
							if(cnt>0 && requiredName===""){
								$('#'+attrObject[i].id).removeClass('first');
								$('#attribute div').each(function(item, value){
									console.log(value)
									console.log($(value).children('li').length)
								   if($(value).children('li').length===0) $(value).remove();
								})
							}else{ 
								
								if(!$('#'+attrObject[i].parentsID)[0]){
									$('#attribute'+requiredName).append('<h3 id="'+attrObject[i].parentsID+'">'+attrObject[i].parentsName+'</h3><div id="'+attrObject[i].parentsID+'_"></div>')
								} 
								$('#'+attrObject[i].parentsID+'_').append('<li obj_name="'+attrObject[i].name+'" obj_id="'+attrObject[i].id+'" id="'+attrObject[i].id+'" class="'+attrObject[i].id+' active" onClick="selectAttr(\''+attrObject[i].id+'\')">'+attrObject[i].name + '</li>')
							 }
							//attribute는 mstr metaDB에서 type컬럼으로 12로 저장이 되어 있음
							//선택한 테이블에서 애트리뷰트는 div.attribute 태그에 위치함
						//	$('#sortable2').append('<li obj_name="'+attrObject[i].name+'" obj_id="'+attrObject[i].id+'">'+attrObject[i].name + '</li>');
						}else if(attrObject[i].type == "4"){
							//metric은 mstr metaDB에서 type컬럼으로 4로 저장이 되어 있음
							//선택한 테이블에서 메트릭은 div.metric 태그에 위치함
							if(!$('#'+attrObject[i].id)[0]){
						   	 	$('#sortable3').append('<li obj_name="'+attrObject[i].name+'" class="'+attrObject[i].id+' active" obj_id="'+attrObject[i].id+'" id="'+attrObject[i].id+'" onClick="selectedMet(\''+attrObject[i].id+'\')">'+attrObject[i].name + '</li>');
						   	 }
						}		
					}
					
					$( '#attribute li.first').remove();
	        		$( "#attribute" ).accordion( "refresh" )
	        		$( "#attributeRequired" ).accordion( "refresh" );
	        		

	        		
				} else {
					alert("메뉴정보 조회 중 오류가 발생하였습니다.");
				}
				//선택된(클릭한) 애트리뷰트는 div.selectObjectAttr 태그에 위치함
				/* $('#attribute li.active, #attributeRequired li.active').on("click", function() { 
					if ($('span[obj_id="'+ $(this).attr('obj_id')+'"]', $('div.selectObjectAttr')).length > 0){
						//skip
					}else {
						$('#selectAttribute').append($(this)[0].outerHTML+"<br/>");
						$(this).remove()
					}
	
				}); */
				//선택된(클릭한) 메트릭은 div.selectObjectMetric 태그에 위치함
				$("span", $('div.metric')).on("click", function() {
					
					if ($('span[obj_id="'+ $(this).attr('obj_id')+'"]', $('div.selectObjectMetric')).length > 0) {
						//  skip
					} else {
						$('div.selectObjectMetric').append($(this)[0].outerHTML+"<br/>");
					}
				});				
			},
			error: function() { 
				alert("메뉴정보 조회 중 오류가 발생하였습니다.");
			},
			async: true
		};				
		$.ajax(option);
	}
	function removeObject(SearchObj){ 
		$( '#sortable1 .' + SearchObj ).addClass('active')
		$( '#sortable1-2 .' + SearchObj ).remove(); 

	}
function selectAttr(id){
	console.log(id)
	const current =  $('#'+id+'.active');
	const parentId = current.parent().parent().attr('id');
	console.log(parentId)

	let targetAttr = 'selectAttribute';
	if(!current.hasClass('active')){
		return;
	}
	if(parentId==="selectAttribute" ){
	console.log('active') 
		current.parent().remove();
		$('#'+id).addClass('active');
	}else{ 
		
		$('#selectAttribute').append('<li><input type="checkbox" name="prompt" value="'+id+'"> <span obj_name="'+$('#'+id).attr('obj_name')+'" obj_id="'+id+'" id="'+id+'" class="'+id+' active" onClick="selectAttr(\''+id+'\')">'+$('#'+id).text() + '</span></li>');
		$('#'+id).removeClass('active');
		//$('#'+id+'.active').prepend('<input type="checkbox">')
	}	 
	 
}

function selectedMet(id){
	console.log(id)
	const current =  $('#'+id+'.active');
	const parentId = current.parent().attr('id');
	console.log(parentId)

	let targetAttr = 'sortable3-2';
	if(!current.hasClass('active')){
		return;
	}
	if(parentId==="sortable3-2" ){
		console.log('active') 
		current.remove();
		$('#'+id).addClass('active');
	}else{ 
		
		$('#sortable3-2').append('<li  obj_name="'+$('#'+id).attr('obj_name')+'" obj_id="'+id+'" id="'+id+'" class="'+id+' active" onClick="selectedMet(\''+id+'\')">'+$('#'+id).text() + '</li>');
		$('#'+id).removeClass('active');
		//$('#'+id+'.active').prepend('<input type="checkbox">')
	}	 
	 
}


/*
 * date : 2022-04-25
 * 선택된 개체들(애트리뷰트,메트릭) 선택 후, 리포트 저장 및 실행 하는 자바스크립트
 * MstrController.java의 @RequestMapping = getAttrMetricInfo 참조
 */	
 
function saveReport() {
		
		var SelectedAttribute = new Array();
		var SelectedMetric = new Array();
		var SelectedPrompt = new Array();
		
		$('#selectAttribute span').each(function(item, value){
			SelectedAttribute.push($(value).attr('obj_id'));
		});		
		
		$('#sortable3-2 li').each(function(item, value){
			SelectedMetric.push($(value).attr('obj_id'));
		});
		
		$('input[name=prompt]:checked').each(function(item, value){
			SelectedPrompt.push($(value).val());
		});

		var AttributeParam = JSON.stringify({"Attribute":SelectedAttribute});	
		var MetricParam = JSON.stringify({"Metric":SelectedMetric});
		var ReportName = $('#recipient-name').val()+" - ";
		var option = {
			url: contextPath+"/app/getSaveReport.json",		
			type: "post",
			data: JSON.stringify({"Attribute": SelectedAttribute, "Metric": SelectedMetric, ReportName, "Prompt":SelectedPrompt}),
			contentType: "application/json;charset=utf-8",
			dataType: "json",
			success: function(result) {
				console.log(result);
				// 서버로부터 응답을 받는 시점에서 호출되는 콜백함수
				if (result && result["errorCode"] == "success") {
						try {
							var evt = '4001';
							var src = 'mstrWeb.4001';
							var sLinkURL = '/MicroStrategy/servlet/mstrWeb?evt='+evt+'&src='+src+'&visMode=0&reportViewMode=1&reportID='+result['saveObjId']+'&Server='+server+'&Project='+project+'&Port=0&share=1';
							var popName = "popup1";
							window.open("", popName);
							$('#frmMstr').attr('method', 'post').attr('action', sLinkURL).attr('target',popName).submit();
						} catch (e) {
							console.log(e);
						} finally {
							$('#frmMstr').removeAttr('action').removeAttr('target');
						}
					
				} else {
					alert("메뉴정보 조회 중 오류가 발생하였습니다.1");
				}				
			},
			error: function() { 
				alert("메뉴정보 조회 중 오류가 발생하였습니다.2");
			},
			async: true
		};				
		$.ajax(option);
	}
	
	$(function() {
		loadMenu();
	});
	
	function popupwindow(){
		var url ="";
		window.open(url,"Help","width =400, height =400, left=600");
	}