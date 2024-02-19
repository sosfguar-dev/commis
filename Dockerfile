
FROM node:18.12.1-alpine as builder

WORKDIR /app
COPY . ./
RUN npm i --prefer-offline

RUN npm run build && npm prune --production

FROM node:18.12.1-alpine
WORKDIR /app
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/tsconfig.json /app/tsconfig.json
COPY --from=builder /app/tsconfig.build.json /app/tsconfig.build.json
EXPOSE 3000
CMD [ "npm", "run", "start:prod" ]