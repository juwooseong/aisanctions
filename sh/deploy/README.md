# 배포 스크립트 (플랫폼별)

Windows / Linux / Linux Docker 용 빌드·배포·재기동 스크립트를 분리한다.

| 디렉터리 | 대상 | 주 용도 |
|----------|------|---------|
| [`windows/`](./windows/) | Windows 빌드 PC / VDI / Build Agent | Maven 빌드, SHA256, WAR 패키징 |
| [`linux/`](./linux/) | Linux JEUS WAS (`wretaap*`) | 서버 빌드, `cdown`/`cboot`, 배포 복사 |
| [`linux-docker/`](./linux-docker/) | Linux + Docker | Maven 컨테이너 빌드, 산출물 추출, (선택) 앱 컨테이너 재기동 |

운영 JEUS Active-Active·무중단 Rolling 절차는  
[`docs/jeus-active-active-session-tibero-jdbc-guide.md`](../../docs/jeus-active-active-session-tibero-jdbc-guide.md) 제5~6장을 따른다.

기존 호스트별 스크립트(`sh/build/d|p1|p2/`)는 **linux/** 와 동일 목적의 현장 관행본이다.  
신규·문서화 기준은 본 `sh/deploy/` 트리를 사용한다.

## 빠른 선택

```text
외부에서 WAR만 만들 때          → windows/ 또는 linux-docker/
은행 JEUS 서버에 반영할 때      → linux/ (서버에서 실행)
CI에서 동일 JDK로 재현 빌드     → linux-docker/
로컬 Tomcat만 쓸 때             → windows/ build 후 IDE·Tomcat 배포
```
