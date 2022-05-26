## 환경 설정 참고
- /MicroStrategy/src/main/resources/properties/app.xml에 서버환경 반영
- /MicroStrategy/src/main/resources-mstr/WEB-INF/xml 하위 *.token 및 *.xml 파일 서버환경 반영

## 초기 URL
- http://localhost:8080/MicroStrategy/plugins/esm/jsp/sso.jsp?mstrUserId=demo
- mstrUserId는 존재하는 MSTR 사용자ID

## TODO
### 공통
- app.xml 파일의 속성 미정의 시 명확한 오류 메세지 출력
    - 대상소스 > /MicroStrategy/src/main/java/com/mococo/microstrategy/sdk/esm/CustomExternalSecurity.java 