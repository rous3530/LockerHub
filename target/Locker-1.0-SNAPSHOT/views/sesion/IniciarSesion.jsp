<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Iniciar Sesión</title>

    <!-- Bootstrap 5 CSS CDN para asegurar consistencia total de estilos -->
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
    <!-- Usamos 'register-container' para heredar la configuración de 440px y bordes de customer.css -->
    <div class="register-container p-4 p-md-5 shadow-sm">

        <!-- Sección de Cabecera -->
        <h2 class="fw-bold text-navy h3 mb-2 text-center">Inicio de sesión</h2>
        <p class="text-muted small mb-4 text-center">Accede a tu cuenta de casillero</p>

        <form novalidate id="loginForm">

            <!-- Input: Correo -->
            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Correo</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" placeholder="ejemplo@universidad.edu" required>
                    <div class="invalid-feedback">Ingresa un correo electrónico válido.</div>
                </div>
            </div>

            <!-- Input: Contraseña -->
            <div class="text-start mb-2">
                <label class="form-label text-secondary small fw-semibold mb-1">Contraseña</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" placeholder="••••••••" required>
                    <div class="invalid-feedback">La contraseña es obligatoria.</div>
                </div>
            </div>

            <!-- Enlace Recuperar Contraseña -->
            <div class="text-end mb-4">
                <a href="${pageContext.request.contextPath}/views/sesion/recuperarContra.jsp" class="small text-navy fw-semibold text-decoration-none">
                    ¿Olvidaste tu contraseña?
                </a>
            </div>

            <!-- Botón Iniciar Sesión con Icono -->
            <button type="submit" id="btnIniciarSesion" class="btn btn-navy w-100 py-2.5 fw-semibold d-flex align-items-center justify-content-center gap-2 mb-4 rounded-3">
                Iniciar Sesión <i class="bi bi-box-arrow-in-right fs-5"></i>
            </button>

            <hr class="text-muted opacity-25 my-4">

            <!-- Enlace alternativo centrado -->
            <p class="mb-0 small text-secondary text-center">
                ¿Aún no se ha registrado? <a href="${pageContext.request.contextPath}/views/sesion/registro.jsp" class="text-navy fw-bold text-decoration-none">Regístrate aquí</a>
            </p>
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
<script src="${pageContext.request.contextPath}/js/sesion/inicioSecion.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>