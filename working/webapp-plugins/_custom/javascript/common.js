/**
 * 
 */
function wait() {
	$.blockUI({ 
        theme: true, 
        // title: "알림", 
        message: "<p><b>잠시 기다려 주세요...<b></p>" 
    }); 	
}

function unwait() {
	$.unblockUI();
}