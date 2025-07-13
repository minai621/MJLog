# 사용할 Node.js 버전과 이미지 (예: node:20-alpine)
# Alpine 이미지는 작고 가볍지만, 특정 라이브러리 호환성 문제가 있을 수 있습니다.
# 만약 문제가 발생하면 더 큰 Node.js 이미지 (예: node:20)를 고려해볼 수 있습니다.
FROM node:20-alpine

# 컨테이너 내 작업 디렉토리 설정
WORKDIR /app

# package.json 및 pnpm-lock.yaml 복사
# 이 파일들만 먼저 복사하여 종속성 설치 단계를 캐싱할 수 있도록 합니다.
COPY package.json pnpm-lock.yaml ./

# pnpm 전역 설치 및 pnpm 스토어 디렉토리 설정
# pnpm config set store-dir 명령을 추가하여 컨테이너 내부에서 일관된 스토어 경로를 사용하도록 합니다.
# 이렇게 하면 "ERR_PNPM_UNEXPECTED_STORE" 오류를 방지할 수 있습니다.
RUN npm install -g pnpm@8 && \
    pnpm config set store-dir /app/.pnpm-store --global && \
    pnpm install --frozen-lockfile

# 나머지 애플리케이션 파일 복사
# .dockerignore에 지정된 파일들은 복사되지 않습니다.
COPY . .

# Next.js 애플리케이션 빌드
# 이 단계에서 .next 디렉토리가 생성됩니다.
RUN pnpm run build

# Next.js 애플리케이션이 수신할 호스트와 포트 설정
# 0.0.0.0으로 설정하여 모든 네트워크 인터페이스에서 접근 가능하게 합니다.
ENV HOST 0.0.0.0
EXPOSE 3000

# 애플리케이션 실행 명령어
# Next.js 프로덕션 서버는 일반적으로 'next start'로 실행됩니다.
# 만약 'pnpm run serve' 스크립트가 package.json에 정의되어 Next.js를 시작한다면 문제가 없습니다.
# 하지만 표준 Next.js 배포라면 'next start'를 사용하는 것이 일반적입니다.
CMD ["pnpm", "run", "serve"]
