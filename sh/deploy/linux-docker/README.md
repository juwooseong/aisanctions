# Linux Docker 배포 스크립트

| 스크립트 | 설명 |
|----------|------|
| `build_app.sh` | `docker run maven:...` 로 WAR 빌드 |
| `extract_artifact.sh` | `target/*.war` + SHA → `target/docker-out/artifact` |
| `restart_app.sh` | `docker-compose.deploy.yml` 앱 서비스 재기동 (로컬용) |
| `docker-compose.deploy.yml` | Tomcat 검증용 골격 (운영 JEUS 아님) |
| `env.example` | 이미지 태그·`-Denv` |

운영 반영: 산출 WAR를 PCMS/SFTP로 이관 후 **`../linux/restart_app.sh`** (JEUS `cdown`/`cboot`).
