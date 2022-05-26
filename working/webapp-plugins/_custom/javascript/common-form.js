//*************************************************************************
// 파라메터에 포함된 정보로 ajax 호출
//*************************************************************************
function _submit(action, target, inputs) {
    var $form = $("#__term_form");
    if ($form.length != 0) { $form.remove(); }
    
    $form = $("<form id='__temp_form' action='" + action + "' target='" + target + "'></form>"); 
    $("body").append($form);

    $.each(inputs || [], function(i, v) {
        $form.append("<input type='hidden' name='" + i + "' value='" + v + "'/>");
    });
    
    $form.submit();
}