#개발모드
mode=op
modeName=운영

#도메인
domain=https://sanction.woorifg.com:8080

#포털로그인
portal.login=http://eportal.woorifg.com

#포털프록시
portal.prc=http://wsypxy1.woorifg.com:7781/sanction/sso/prx

#승인여부 체크
check.approve.yn=Y

#그리드 속성
grid.height=438

#BPR 이미지
bpr.url=http://wbbpr.woorifg.com/web/jsp/bprInbCall.jsp?bprScrnNo=BTR000990051&imgKeyNo=

#파일업로드
#upload.path=/home/aisac/apps/resources/files/
upload.path=/home/aisac/
upload.path.down=/home/aisac/tmp/
upload.url=/files/
upload.exts=txt,pptx,ppt,xlsx,xls,pdf,doc,docx,json,jpg,png,gif,bmp
upload.maxSize=20971520

#심사상세관련
img.url=http://10.233.64.10:10917/sa/g001
#img.url=http://10.233.95.51:10917/sa/g001
file.upload=http://10.233.64.10:10917/aisac/file/upload
file.download=http://10.233.64.10:10917/aisac/file/download
file.delete=http://10.233.64.10:10917/aisac/file/delete
extraction.url=http://10.233.64.10:8096/extraction
inspection.url=http://10.233.64.10:8093/inspection

# sso 통합 로그인 관련
sso.enc.key=!sanction.woori!

# QA 배치시간
batchTime.qa=0 0 6 * * *

# 업무마감 배치시간
batchTime.taskEnd=0 30 23 * * *