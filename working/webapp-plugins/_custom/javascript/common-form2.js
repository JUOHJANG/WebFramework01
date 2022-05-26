/**
 * 폼작성시 활용할 공통함수
 * 2015-12 - version 0.1
 */
/**
 * 파라메터에 포함된 정보로 폼엘리먼트 값 설정
 * @param $form
 * @param param
 */
function setDataEntryValue($form, param) {
	function _setElemValue($elem, value) {
		$elem.each(function() {
			switch (this.tagName.toLowerCase()) {
			case "input":
				switch (this.type.toLowerCase()) {
				case "hidden":
				case "text":
					$(this).val(value);
					break;
				case "radio":
				case "checkbox":
					$(this).prop("checked", this.value == value);
					break;
				default:
				}
			case "select":
				$(this).val(value);
				break;
			case "textarea":
				$(this).text(value);
				break;
			default:
			}
		});
	}
	
	if (!param || $form.length == 0) { return; }
	
	for (var prop in param.data) {
		var target = param.map[prop];
		
		if (typeof target == "function") {
			target(param.data[prop]);
		} else { 
			_setElemValue($form.find("[data-entry='" + prop + "']"), param.data[prop])
		}
	}
}

function clearDataEntryValue($selector) {
	$selector.each(function() {
		if (this.tagName.toLowerCase() != "form") { return true; }
		
		$(this).find("[data-entry]").each(function() {
			switch (this.tagName.toLowerCase()) {
			case "input":
				switch (this.type.toLowerCase()) {
				case "hidden":
				case "text":
					$(this).val("");
					break;
				case "radio":
					$(this).prop("checked", $("[name='" + this.name + "']")[0] == this);
					break;
				case "checkbox":
					$(this).prop("checked", false);
					break;
				default:
				}
				break;
			case "select":
				$(this).val($(this).children("option").eq(0).val());
				break;
			case "textarea":
				$(this).text("");
				break;
			default:
			}			
		});
	});
}

function getDataEntryValue($selector) {
	if ($selector.length > 1) {
		alert("Only one parent element required.");
		return;
	}
	
	var _result = {};
	
	$.each($selector.find("[data-entry]"), function() {
		var val;
		var $this = $(this);
		
		switch (this.tagName.toLowerCase()) {
		case "input":
			switch (this.type.toLowerCase()) {
			case "hidden":
			case "text":
				val = $this.val();
				break;
			case "radio":
				if (!$this.prop("checked")) { return true; }
				val = $this.val();
				break;
			case "checkbox":
				if (!$this.prop("checked")) { return true; }
				val = $this.val();
				break;
			default:
			}
		case "select":
			val = $this.val();
			break;
		case "textarea":
			// val = $this.text();
			val = $this.val();
			break;
		default:
		}			
		
		if (val) { _result[$this.attr("data-entry")] = val; }
	});
	
	return _result;
}

function setDataEntryEditable($form, editable) {
	if (!$form) { return; }
	$form.find("[data-entry]").filter("input[type='text'], input[type='hidden'], textarea").prop("readonly", !editable);
	$form.find("[data-entry]").filter("input[type='radio'], input[type='checkbox'], select").prop("diabled", !editable);
}
