#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 통합 배포 스크립트 (Next.js / k3s)
#   1. 로컬 포트 3000 충돌 프로세스 종료
#   2. git pull (dirty 하면 stash)
#   3. Docker BuildKit 빌드 (rootless or sudo 자동 감지)
#   4. 결과 이미지를 k3s (containerd) 로 import (tar 無)
#   5. Deployment 롤링 재시작
# -----------------------------------------------------------------------------
set -euo pipefail

### ─────── 사용자 설정값 ────────────────────────────────
APP_NAME="nextjs-app"            # Deployment & 이미지 이름 (로컬 태그)
NAMESPACE="monitoring"          # K8s 네임스페이스
PORT=3000                        # 로컬 dev 포트 (종료 대상)
K3S_CTR="sudo k3s ctr"          # containerd CLI alias (보통 sudo 필요)
REGISTRY_PREFIX="docker.io/library" # k3s 가 자동으로 붙이는 prefix
### ──────────────────────────────────────────────────────

log()   { echo -e "[\e[36m$(date +%H:%M:%S)\e[0m] $*"; }
error() { echo -e "[\e[31m✗\e[0m] $*" >&2; exit 1; }

### ─── Docker 권한 자동 감지 ───────────────────────────
if docker info >/dev/null 2>&1; then
  DOCKER="docker"
  log "Docker daemon에 직접 접근 (rootless)"
else
  DOCKER="sudo docker"
  ${DOCKER} info >/dev/null 2>&1 || error "Docker daemon 에 접근할 수 없습니다 (sudo 포함)"
  log "Docker 명령은 sudo 로 실행"
fi

### 0. 포트 3000 종료 -----------------------------------
if lsof -i :${PORT} >/dev/null 2>&1; then
  log "Port ${PORT} in use → kill"
  lsof -t -i :${PORT} | xargs -r kill -9 || true
else
  log "Port ${PORT} is free"
fi

### 1. Git 최신화 ---------------------------------------
if [[ -n $(git status --porcelain) ]]; then
  log "Dirty working tree → git stash -u"
  git stash push -u -m "deploy-$(date +%s)" || error "git stash 실패"
  STASHED=1
fi

log "▶︎ git pull --rebase"
git pull --rebase || error "git pull 실패"

### 2. Docker BuildKit 빌드 ------------------------------
IMAGE_TAG=$(git rev-parse --short HEAD)
IMAGE_NAME="${APP_NAME}:${IMAGE_TAG}"

log "▶︎ ${DOCKER} build (${IMAGE_NAME})"
DOCKER_BUILDKIT=1 ${DOCKER} build -t "${IMAGE_NAME}" . || error "docker build 실패"

### 3. 이미지 → k3s Runtime -----------------------------
log "▶︎ Pipe 이미지 → k3s ctr import"
${DOCKER} save "${IMAGE_NAME}" | ${K3S_CTR} images import - || error "ctr import 실패"
# containerd 는 docker.io/library/ 를 자동으로 붙여 저장하므로 그 이름을 사용
IMPORTED_NAME="${REGISTRY_PREFIX}/${IMAGE_NAME}"
${K3S_CTR} images tag "${IMPORTED_NAME}" "${APP_NAME}:latest" || error "ctr tag 실패"

### 4. 롤링 재시작 --------------------------------------
log "▶︎ kubectl set image"
kubectl -n "${NAMESPACE}" set image "deployment/${APP_NAME}" "${APP_NAME}=${IMAGE_NAME}" || error "set image 실패"

log "▶︎ kubectl rollout restart"
kubectl -n "${NAMESPACE}" rollout restart "deployment/${APP_NAME}" || error "rollout 실패"

log "▶︎ rollout status (wait)"
kubectl -n "${NAMESPACE}" rollout status "deployment/${APP_NAME}"

### 5. stash pop (있으면) --------------------------------
if [[ "${STASHED:-0}" -eq 1 ]]; then
  log "▶︎ git stash pop"
  git stash pop || log "⚠️  stash pop 충돌: 수동 해결 필요"
fi

log "✅ 배포 완료: ${IMAGE_NAME} → k3s"
