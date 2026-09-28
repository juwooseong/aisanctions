# Linux (JEUS WAS) 배포 스크립트

| 스크립트 | 설명 |
|----------|------|
| `build_app.sh` | 서버 Maven 빌드 (`MVN_DENV` / hostname) |
| `restart_app.sh` | `cdown` → 복사 → `cboot` (+ 선택 백업·BIRT) |
| `hash_war.sh` | SHA256 |
| `apply_config.sh` | datasource.jeus / system.properties 치환 |
| `env.example` | 경로·인스턴스 기본값 |

```bash
cd sh/deploy/linux
cp env.example env.local   # 경로 수정
chmod +x *.sh
./build_app.sh
ENV_PROFILE=p ./apply_config.sh /home/aisac/apps   # 또는 explode 경로
# 무중단: WebToB Drain 후
./restart_app.sh
```

기존 `sh/build/d|p1|p2/` 는 호스트 고정 관행본. 본 디렉터리가 문서화 기준이다.
