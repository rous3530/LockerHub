<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Recuperar Contraseña</title>

    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css">

</head>
<body style="min-height: 100vh; display: flex; flex-direction: column;">

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-navy py-3 shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center gap-2" href="#">
            LockerHub
        </a>
        <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-white text-decoration-none small opacity-75">Inicio</a>
            <a href="${pageContext.request.contextPath}/views/sesion/registro.jsp" class="text-white text-decoration-none small opacity-75">Registro</a>
        </div>
    </div>
</nav>

<!-- CONTENEDOR CENTRAL -->
<div class="container d-flex flex-grow-1 justify-content-center align-items-center py-5">
    <div class="register-container p-4 p-md-5 shadow-sm">

        <!-- Título Estático (Sin hover ni subrayados) -->
        <h2 class="fw-bold text-navy h3 mb-2 text-center text-decoration-none">Recuperar Contraseña</h2>
        <p class="text-muted small mb-4 text-center">Ingresa tu correo institucional para recibir las instrucciones de recuperación.</p>

        <form novalidate>
            <!-- Input: Correo Institucional -->
            <div class="text-start mb-4">
                <label class="form-label text-secondary small fw-semibold mb-1">Correo Institucional</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" placeholder="usuario@universidad.edu" required>
                    <div class="invalid-feedback">Ingresa un correo institucional válido.</div>
                </div>
            </div>

            <!-- Botón de Envío -->
            <button type="submit" class="btn btn-navy w-100 py-2.5 fw-semibold d-flex align-items-center justify-content-center gap-2 mb-4 rounded-3 text-uppercase">
                Enviar instrucciones
            </button>

            <hr class="text-muted opacity-25 my-4">

            <!-- Enlace Volver al Inicio de Sesión (Mismo color del título + Icono lateral de regresar) -->
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/index.jsp" class="back-to-login text-decoration-none d-inline-flex align-items-center gap-2">
                    <i class="bi bi-arrow-left fs-5"></i> Volver al inicio de sesión
                </a>
            </div>
        </form>

    </div>
</div>

<!-- FOOTER -->
<footer class="bg-white py-4 border-top mt-auto">
    <div class="container text-muted" style="font-size: 0.75rem;">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                <span class="fw-semibold text-dark">LockerHub</span> &nbsp; | &nbsp; © 2024 LockerHub University Services
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-muted text-decoration-none mx-2">Privacy Policy</a>
                <a href="#" class="text-muted text-decoration-none mx-2">Terms of Service</a>
                <a href="#" class="text-muted text-decoration-none mx-2">Help Center</a>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/sesion/inicioSecion.js"></script>
</body>
</html>