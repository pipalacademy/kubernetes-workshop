FROM alpine
RUN apk update && apk add fortune
ADD fortune-loop.sh .
CMD ["./fortune-loop.sh"]
