<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>LockerHub - Error 500</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">
<div class="text-center">
    <h1 class="display-1 fw-bold text-warning">500</h1>
    <h3 class="mb-3">Ocurrió un error en el sistema, ponte en contacto con soporte</h3>
    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-dark">Regresar al Inicio</a>
</div>
</body>
</html>