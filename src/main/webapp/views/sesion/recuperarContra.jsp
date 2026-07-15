<%--
  Created by IntelliJ IDEA.
  User: josef
  Date: 7/1/2026
  Time: 8:50 p. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Recuperar Contraseña</title>
    <link href="../../css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/bootstrap-icons-1.13.1">
    <link rel="stylesheet" href="../../css/customer.css">
</head>
<body class="bg-light" style="min-height: 100vh; display: flex; flex-direction: column;">

<nav class="navbar navbar-dark bg-navy py-3 shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="#">LockerHub</a>
        <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/inicio" class="text-white text-decoration-none small opacity-75">Inicio</a>
            <a href="${pageContext.request.contextPath}/registro" class="text-white text-decoration-underline small fw-bold">Registro</a>
        </div>
    </div>
</nav>

<div class="container d-flex flex-grow-1 justify-content-center align-items-center py-5">
    <div class="recover-container p-5 shadow-sm text-center">

        <h2 class="fw-bold text-navy h3 mb-2">Recuperar Contraseña</h2>
        <p class="text-muted small mb-4">Ingresa tu correo institucional para recibir las instrucciones de recuperación.</p>

        <form novalidate id="recoverForm">
            <div class="text-start mb-4">
                <label class="form-label text-secondary small fw-semibold mb-1">Correo Institucional</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" placeholder="usuario@universidad.edu" required>

                    <div class="invalid-feedback">No pudimos encontrar una cuenta con ese correo electrónico.</div>
                </div>
            </div>

            <button type="submit" class="btn btn-navy w-100 py-2.5 fw-bold text-uppercase mb-4 rounded-3" style="letter-spacing: 0.03em; font-size: 0.9rem;">
                Enviar Instrucciones
            </button>

            <div class="mt-2">
                <a href="inicioSecion.html" class="back-link text-decoration-none d-inline-flex align-items-center gap-1">
                    <i class="bi bi-arrow-left"></i> Volver al inicio de sesión
                </a>
            </div>
        </form>

    </div>
</div>

<footer class="bg-white py-4 border-top mt-auto">
    <div class="container text-muted" style="font-size: 0.75rem;">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                <span class="fw-semibold text-dark">LockerHub</span> &nbsp; | &nbsp; <a href="#" class="text-muted text-decoration-none mx-1">Privacy Policy</a> &nbsp; <a href="#" class="text-muted text-decoration-none mx-1">Terms of Service</a> &nbsp; <a href="#" class="text-muted text-decoration-none mx-1">Help Center</a>
            </div>
            <div class="col-md-6 text-center text-md-end">
                © 2024 LockerHub University Services
            </div>
        </div>
    </div>
</footer>

<script src="../../js/bootstrap.bundle.min.js"></script>
<script src="../../js/sesion/recuperarContra.js"></script>
</body>
</html>