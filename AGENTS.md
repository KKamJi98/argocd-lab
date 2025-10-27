# Repository Guidelines

<important>
`/home/kkamji/.codex/AGENTS.md`의 내용을 반드시 확인하고 따를 것
</important>

## 프로젝트 구조 및 모듈 구성
- 이 저장소는 Argo CD Application 선언을 관리하며 `app-of-apps-basic/root-app.yaml`이 `app-of-apps-basic/applications/` 하위 리소스를 모두 묶는 진입점입니다.
- 클러스터 전역 컨트롤러는 `cluster_local/`에 배치하고 파일명은 반드시 Application `metadata.name`과 동일하게 유지합니다.
- Helm chart 값 재정의는 `values/`에 보관하며 예시는 `kube-prometheus-stack-values.yaml`처럼 chart 이름을 그대로 따릅니다.
- 변경 전후 비교용 스모크 매니페스트는 `test/`에 두고, 실서비스와 구성이 달라질 때 `application-local.yaml`·`application-target.yaml`을 함께 갱신합니다.
- 사설 차트는 `private-repo/`에 선언하되 자격 증명 공유 절차를 완료한 뒤 커밋합니다.

## 빌드·테스트·개발 명령
- `./app-of-apps-basic/setup-kubeconfig.sh`를 실행해 EKS 컨텍스트를 갱신하고 `argocd.kkamji.net`에 로그인합니다.
- `kubectl apply --server-side --dry-run=client -f <path>`로 Kubernetes 스키마를 검증하고, 기본 확인 경로는 `cluster_local/ingress-nginx.yaml`입니다.
- `argocd app diff root-app --local app-of-apps-basic`으로 라이브 상태와 비교하며 승인용 스크린샷이나 로그를 PR에 첨부합니다.
- `argocd app sync root-app --retry-limit=1`을 사용해 변경사항을 적용하되 위험도가 높으면 수동 sync 후 관찰합니다.

## 코딩 스타일 및 네이밍 규칙
- YAML은 두 칸 들여쓰기를 사용하고 `metadata`, `spec`, `destination`, `syncPolicy` 순서를 지킵니다.
- Application 이름은 소문자-하이픈 패턴을 유지하며 파일명과 동일하게 합니다.
- Helm values는 원본 chart 구조를 그대로 따라가며 필요한 설명만 주석으로 남깁니다.
- 비밀 정보는 External Secrets 또는 AWS Parameter Store를 참조하며 직접 커밋하지 않습니다.

## 테스트 지침
- 신규 컨트롤러 추가 전 `helm template` 또는 `kubectl kustomize`로 렌더링 결과를 점검하고 결과 요약을 PR에 포함합니다.
- 각 수정 파일에 대해 최소 한 번 `kubectl apply --dry-run=server` 또는 `--client` 검증을 수행합니다.
- `argocd app diff` 결과를 캡처해 변경된 리소스 목록을 검토하고, 자동화 옵션 변경 시 성공 로그를 공유합니다.
- 테스트 데이터는 실제 네임스페이스·리소스 이름과 정합성을 맞춰 drift를 방지합니다.

## 커밋 및 PR 지침
- 커밋 메시지는 `<type>: <summary>` 형식을 따르며 72자 이내 영어 요약을 사용합니다.
- 논리적으로 다른 변경은 커밋을 분리해 롤백과 감사 추적을 단순화합니다.
- PR 설명에는 변경 목적, 배포 영향, 검증 절차, 후속 작업을 명확히 작성합니다.
- 관련 이슈·런북을 링크하고 Grafana·Harbor처럼 UI가 있는 배포는 스크린샷을 첨부합니다.
- 최소 한 명 이상 리뷰를 확보한 뒤 머지하고, 승인 후 Argo CD가 Healthy 상태인지 확인합니다.

## 보안 및 운영 팁
- `syncOptions`에 설정된 Prune 파라미터는 리소스 정리를 보장하므로 위험 변경 전 백업 또는 스냅샷을 권장합니다.
- Argo CD Notifications 주석을 활성화해 슬랙 알림을 복구하면 장애 감지 시간을 단축할 수 있습니다.
- SSO·비밀키 변경 시 `cluster_local/keycloak.yaml`과 External Secrets를 동시에 갱신해 인증 흐름을 유지합니다.
