# HSL Integrated Ops — 통합감시실 운영·인수인계 패키지

고속선 **통합감시실** 및 **광명/구로 관제실**의 서버/스토리지/SAN/네트워크와  
**통합운용소프트웨어(메인/미디어/EMS/D·I)** 운영 지식과 절차를 **문서-우선(Documentation-First)** 원칙으로 버전관리합니다.

---

## 0) 빠른 링크

- 개요/토폴로지: `docs/overview/system-summary.md` · `docs/overview/topology.md`  
- 스토리지/SAN: `docs/storage/eva-overview.md` · `docs/storage/zoning-policy.md`  
- 통합운용SW: `docs/app/overview.md` · `docs/app/functions.md` · `docs/app/operations.md`  
- 구축 절차(Build): `build/app/*` · `build/network/*`  
- 운영/런북(Ops): `ops/checklists/*` · `ops/runbooks/*` · `ops/handover/*`  
- 인벤토리(정본): `inventory/assets.yaml` · `inventory/ipam.csv` · `inventory/vlan-plan.csv`

---

## 1) 저장소 목적

1. **인수인계 가능한 수준**으로 설치·운영·장애대응 전 과정을 문서화  
2. **정본(Inventory)** → **골든컨피그(Configs)** → **MOP(작업서)** → **증적(Evidence)** → **런북/교훈**의 반복 가능한 체계 확립  
3. 변경/장애 이력의 **가시성**과 **추적성** 확보(감사·사후분석 대응)

---

## 2) 폴더 구조(요약)

hsl-integrated-ops/
├─ inventory/
│  ├─ assets.yaml
│  ├─ ipam.csv
│  ├─ vlan-plan.csv
│  ├─ firewall-matrix.csv
│  ├─ san-wwpn-map.csv
│  ├─ sw-components.csv        (통합운용SW 구성요소/버전/설치경로/포트)
│  └─ sw-endpoints.csv         (서비스 엔드포인트/프로토콜/포트/의존)
├─ configs/
│  ├─ app/
│  │  ├─ service-topology.md   (메인/미디어/EMS/D·I 관계 · 데이터 흐름)
│  │  └─ runtime-config.md     (실행파일/설정키/로그경로 표준)
│  └─ storage/
│     └─ eva8000-presentations.md
├─ build/
│  ├─ app/
│  │  ├─ 00-precheck.md        (라이선스/계정/권한/시간동기/백신 예외)
│  │  ├─ 10-install-main.md    (메인설치: C:\home\safe\appl\opbin)
│  │  ├─ 12-install-media.md   (미디어설치: 클러스터 고려)
│  │  ├─ 14-install-ems.md     (EMS설치: C:\EMS)
│  │  ├─ 16-install-di.md      (D·I/MClient: C:\mclient)
│  │  ├─ 20-initial-config.md  (StatusChk · NetTime · AV 공통)
│  │  ├─ 30-startup-procedures.md   (가동: 메인/미디어/EMS/D·I)
│  │  ├─ 32-shutdown-procedures.md  (종료: 역순/주의점)
│  │  ├─ 50-update-procedures.md    (패치 배포/롤백)
│  │  └─ 90-commissioning-tests.md  (검수: 로그/프로세스/클러스터/표출)
│  └─ network/
│     ├─ 00-cabling-standards.md
│     ├─ 10-vlan-ip-plan.md
│     ├─ 20-core-l3-routing.md
│     ├─ 30-firewall-matrix-to-rules.md
│     └─ 40-san-zoning-mop.md
├─ ops/
│  ├─ runbooks/
│  │  ├─ rb-main-failover.md   (메인 장애/슬레이브 승격)
│  │  ├─ rb-media-cluster.md   (미디어 클러스터 오프라인/페일오버)
│  │  ├─ rb-ems-client.md      (EMS 접속/표출 장애)
│  │  └─ rb-di-active-di.md    (D·I/Active D·I 무표출/오동작)
│  ├─ checklists/
│  │  ├─ daily-app.md          (일일: 프로세스/로그/시간/클러스터)
│  │  ├─ weekly-app.md         (주간: 패치/백업/프리셋/용량)
│  │  └─ monthly-quarterly-app.md (월·분기: 리허설/계정검토)
│  └─ handover/
│     ├─ 00-oncall-quickstart.md
│     ├─ 30-mop-template.md
│     ├─ 40-rollback-criteria.md
│     └─ 50-uat-acceptance.md
├─ docs/
│  └─ app/
│     ├─ overview.md           (1장: 목적/범위/용어)
│     ├─ functions.md          (2장: 기능/이중화)
│     ├─ operations.md         (3장: 가동/종료—이미지 캡션 예정)
│     ├─ recovery.md           (4장: 장애유형/복구)
│     ├─ updates.md            (5장: 업데이트 대상/절차)
│     ├─ install.md            (6장: 설치 경로/권한/주의)
│     └─ org-contacts.md       (7장: 조직/역할/연락처)
├─ diagrams/
│  ├─ app-logic.drawio         (메인↔미디어↔EMS↔D·I 플로우, 추후)
│  ├─ main-ha.drawio           (StatusChk 이중화/Failover, 추후)
│  ├─ media-cluster.drawio     (Cluster1/2 동작, 추후)
│  └─ di-active-di.drawio      (D·I/Active D·I 표출 경로, 추후)
└─ scripts/
   ├─ app-time-sync.cmd        (Net Time 동기화 배치)
   ├─ app-process-check.ps1    (Run/StatusChk/EMS/MClient 점검)
   └─ app-log-collect.cmd      (로그 수집 표준)
   
### 2.1 inventory/ (정본)
- `assets.yaml` : 서버/스토리지/SAN/네트워크 자산 정보  
- `ipam.csv` : IP 계획(호스트명/역할/게이트웨이/위치)  
- `vlan-plan.csv` : VLAN ID/이름/서브넷/게이트웨이/용도  
- `firewall-matrix.csv` : 출발지/목적지/프로토콜/포트/허용/비고  
- `san-wwpn-map.csv` : HBA WWPN/스위치포트/컨트롤러포트/Zone  
- `sw-components.csv` : **통합운용SW** 구성요소/버전/설치경로/실행파일/로그  
- `sw-endpoints.csv` : 서비스 엔드포인트/포트/프로토콜/의존관계

### 2.2 configs/
- `app/service-topology.md` : **메인/미디어/EMS/D·I** 모듈 관계·데이터 흐름  
- `app/runtime-config.md` : 실행파일/설정키/로그경로/폴더권한 표준  
- `storage/eva8000-presentations.md` : EVA 프레젠테이션/VRaid/스페어 정책

### 2.3 build/ (설치·구축)
- `app/00-precheck.md` : 라이선스/계정/권한/시간동기/백신 예외  
- `app/10-install-main.md` : **메인** 설치(`C:\home\safe\appl\opbin`)  
- `app/12-install-media.md` : **미디어** 설치(클러스터 고려)  
- `app/14-install-ems.md` : **EMS** 설치(`C:\EMS`)  
- `app/16-install-di.md` : **D·I/MClient** 설치(`C:\mclient`)  
- `app/20-initial-config.md` : StatusChk/NetTime/AV 공통 설정  
- `app/30-startup-procedures.md` : 가동(메인/미디어/EMS/D·I)  
- `app/32-shutdown-procedures.md` : 종료(역순·주의점)  
- `app/50-update-procedures.md` : 패치/롤백 절차  
- `app/90-commissioning-tests.md` : 기능검수(로그/프로세스/클러스터/표출)  
- `network/*` : VLAN/IP/라우팅/방화벽/SAN Zoning MOP

### 2.4 ops/ (운영·장애대응)
- `runbooks/rb-main-failover.md` : **메인** 장애/슬레이브 승격/재동기화  
- `runbooks/rb-media-cluster.md` : **미디어** 클러스터 페일오버/오프라인  
- `runbooks/rb-ems-client.md` : **EMS** 접속/표출 장애  
- `runbooks/rb-di-active-di.md` : **D·I/Active D·I** 무표출/오동작  
- `checklists/daily-app.md` : 일일 점검(프로세스/로그/시간/클러스터)  
- `checklists/weekly-app.md` : 주간 점검(패치/백업/프리셋/용량)  
- `checklists/monthly-quarterly-app.md` : 월/분기(리허설/패치 집중/계정검토)  
- `handover/*` : 온콜 10분 요약·MOP·롤백 기준·UAT/인수 서식

### 2.5 docs/app/ (통합운용SW 해설)
- `overview.md` : 목적/적용범위/용어(EMS·GUI 등)  
- `functions.md` : 기능(메인 HA, 미디어 1~4 Active/Active, EMS 표출, D·I/Active D·I)  
- `operations.md` : **가동/종료 절차**(후속 이미지 캡션 예정)  
- `recovery.md` : 장애유형·복구 플로우(메인 장애시 슬레이브 승격 등)  
- `updates.md` : 업데이트 대상·절차(경로/증적/롤백)  
- `install.md` : 설치 경로·폴더권한·주의사항  
- `org-contacts.md` : 조직/역할/연락처(placeholder)

---

## 3) 통합운용소프트웨어 핵심 요약

| 구성요소 | 설치 경로(예시) | 실행파일 | 역할/비고 |
|---|---|---|---|
| **메인(Main)** | `C:\home\safe\appl\opbin` | `Run.exe` | 이벤트/영상 1차 처리, 마스터만 실행 |
| **StatusChk(HA)** | `C:\home\safe\appl\opbin` | `StatusChk.exe` | 메인 이중화(마스터/슬레이브 판별·승격) |
| **미디어(Media1~4)** | 동상 | `Run.exe` | 4대 Active/Active, (1·2)·(3·4) 클러스터 |
| **EMS(Client)** | `C:\EMS` | `EMS.exe` | GUI/텍스트 표출, 메인 결과 표시 |
| **D·I / Active D·I** | `C:\mclient` | `MClient.exe` | 멀티큐브 표출/이벤트 순차 확대 |
| 공통 | System | `net time`, `V3 Server 6.0` | 시간동기/백신(예외 규정 준수) |

- **가동 순서(요약)**: 메인(마스터→슬레이브 `StatusChk.exe` 실행) → 미디어(클러스터 Online) → EMS(클라이언트 실행) → D·I/Active D·I  
- **종료 순서(요약)**: D·I → EMS → 미디어(클러스터 Offline 역순: 4→1) → 메인(슬레이브 `StatusChk`→마스터 `Run`→`StatusChk`)

자세한 단계별 스텝은 `build/app/30-startup-procedures.md`, `build/app/32-shutdown-procedures.md` 참고.

---

## 4) 장애 복구(런북 하이라이트)

- **메인 장애(마스터 다운)** → 슬레이브 `Run.exe` 자동 기동 확인 → 필요 시 EMS를 **백업 IP**로 재접속 → 사후 RCA, 역할 재조정은 영업종료 후  
  → `ops/runbooks/rb-main-failover.md`

- **미디어 클러스터 이슈** → 클러스터 관리자에서 자원 Online/Offline 제어, HeartBit/Proc 확인 → 필요시 반대 노드로 Failover  
  → `ops/runbooks/rb-media-cluster.md`

- **EMS 표출 장애** → 서비스/포트/DB 연결 점검, 이벤트 로그 수집, 재기동 1회 규정  
  → `ops/runbooks/rb-ems-client.md`

- **D·I/Active D·I 무표출** → 전원/케이블/프리셋/연동 컨트롤러 점검, 백업 프리셋 롤백  
  → `ops/runbooks/rb-di-active-di.md`

---

## 5) 점검 체크리스트(발췌)

- **일일**: 시간 동기 OK, 메인(마스터 Run/슬레이브 StatusChk), 미디어(클러스터 Online & 프로세스 6개), EMS 표출 OK, D·I 샘플 프리셋 확인, AV 예외/업데이트, 디스크 여유>10%  
  → `ops/checklists/daily-app.md`

- **주간/월·분기**: 백업·패치·프리셋 덤프, 페일오버 리허설, 계정 정비  
  → `ops/checklists/weekly-app.md`, `ops/checklists/monthly-quarterly-app.md`

---

## 6) 스크립트(예)

- `scripts/app-time-sync.cmd` : NetTime 동기화  
- `scripts/app-process-check.ps1` : Run/StatusChk/EMS/MClient 상태 점검  
- `scripts/net-ping-matrix.py` : 세그먼트 간 Ping 매트릭스 검사

---

## 7) 도면/이미지

- 원본: `diagrams/*.drawio`, `diagrams/*.mmd`  
- 렌더본: `diagrams/*.png` 또는 `*.svg` (README/문서에 삽입용)  
- 추후 제공될 **가동/종료/클러스터/Active D·I** 화면 캡처는 `docs/app/operations.md`에 단계별 캡션으로 연결

---

## 8) 협업 규칙

- 브랜치/PR: `main` 보호 → `feature/*`에서 PR, **영향도/롤백/테스트** 필수  
- 변경 이력: `CHANGELOG.md` · 기여 가이드: `CONTRIBUTING.md`  
- 보안: 기본 계정 즉시 변경, 최소 권한/금고(2인 승인)/이동식매체 통제 → `SECURITY.md`

---

## 9) 면책/주의

> 본 README의 일부 주소/경로는 **도면 기반 예시**입니다.  
> 실제 운영 값은 `inventory/ipam.csv`, `inventory/vlan-plan.csv`, 장비 설정을 **정본**으로 유지하세요.


