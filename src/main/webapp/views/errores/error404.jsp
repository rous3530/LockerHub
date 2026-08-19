<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>LockerHub - Error 404</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">
<div class="text-center">
    <h1 class="display-1 fw-bold text-danger">404</h1>
    <h3 class="mb-3">El recurso o elemento que estás buscando no existe o se movió de lugar</h3>
    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-dark">Regresar al Inicio</a>
</div>
</body>
</html>