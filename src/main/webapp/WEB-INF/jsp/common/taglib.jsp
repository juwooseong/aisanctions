<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"></c:set>
<c:set var="ctx_res" value="${pageContext.request.contextPath}/resources"></c:set>
<c:set var="url_mapping" value="${pageContext.request.requestURL}"></c:set>

<c:set var="maxLength_refno" value="16"></c:set>
<c:set var="maxLength_cusno" value="9"></c:set>
<c:set var="maxLength_eno" value="8"></c:set>
<c:set var="maxLength_ipnumber" value="20"></c:set>
<c:set var="maxLength_mstno" value="20"></c:set>
