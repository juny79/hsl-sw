
# 통합운용SW 논리 토폴로지 (초안)
- 메인(Main): 이벤트/영상 1차 처리 → EMS 표출 신호
- 미디어(Media1~4): 영상 수집/분산, Cluster1(1·2) / Cluster2(3·4)
- EMS: GUI/Text 표출
- D·I/Active D·I: 멀티큐브 표출/이벤트 확대
- HA: StatusChk(Main), MSCS(Media)
