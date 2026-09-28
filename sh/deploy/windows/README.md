# Windows 배포 스크립트

| 스크립트 | 설명 |
|----------|------|
| `build_app.ps1` | Maven WAR 빌드 (`-Env d\|p`) |
| `hash_war.ps1` | SHA256 → `target\war.sha256` |
| `package_for_transfer.ps1` | WAR+SHA ZIP 반입 패키지 |

```powershell
cd ta_ui-master\sh\deploy\windows
.\build_app.ps1 -Env d
.\hash_war.ps1
.\package_for_transfer.ps1
```

ExecutionPolicy 이슈 시: `powershell -ExecutionPolicy Bypass -File .\build_app.ps1 -Env d`
