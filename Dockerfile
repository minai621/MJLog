FROM node:20-alpine
WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm@8 \
 && pnpm install --frozen-lockfile

COPY . .
RUN pnpm run build          # .next 생성

ENV HOST 0.0.0.0
EXPOSE 3000
CMD ["pnpm","run","serve"]  # ← dev 아님
