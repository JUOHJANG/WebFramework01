/* MSTR 화면 표시 시점에 현재 메인화면에서 표시되는 대기 메세지 표시 레이어 숨김 */
try {
	if (typeof window.top.unwait == "function") {
		window.top.unwait();
	}
} catch(e) {  }