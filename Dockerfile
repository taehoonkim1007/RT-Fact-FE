# [1] 빌드 단계
FROM node:24-alpine AS builder

RUN npm install -g pnpm@10.27.0
WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

# [2] 배포 단계 (Nginx)
FROM nginx:alpine

# 빌드 결과물을 Nginx 폴더로 복사
COPY --from=builder /app/dist /usr/share/nginx/html

# 작성한 Nginx 설정 파일 덮어쓰기
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 도커 내부 포트 (Nginx 기본)
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]