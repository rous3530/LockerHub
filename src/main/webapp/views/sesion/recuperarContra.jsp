<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    String stepParam = request.getParameter("step");
    int step = (stepParam != null) ? Integer.parseInt(stepParam) : 1;
    String correo = request.getParameter("correo") != null ? request.getParameter("correo") : "";
    String token = request.getParameter("token") != null ? request.getParameter("token") : "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Recuperar Contraseña</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css">
</head>
<body style="min-height: 100vh; display: flex; flex-direction: column;">

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-navy py-3 shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center gap-2" href="#">LockerHub</a>
        <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-white text-decoration-none small opacity-75">Inicio</a>
            <a href="${pageContext.request.contextPath}/views/sesion/registro.jsp" class="text-white text-decoration-none small opacity-75">Registro</a>
        </div>
    </div>
</nav>

<!-- CONTENEDOR CENTRAL -->
<div class="container d-flex flex-grow-1 justify-content-center align-items-center py-5">
    <div class="register-container p-4 p-md-5 shadow-sm">

        <h2 class="fw-bold text-navy h3 mb-2 text-center text-decoration-none">Recuperar Contraseña</h2>

        <!-- MENSAJES DE ERROR -->
        <% if ("correo_no_encontrado".equals(request.getParameter("status"))) { %>
        <div class="alert alert-danger p-2 small text-center mb-3">El correo ingresado no está registrado.</div>
        <% } else if ("token_invalido".equals(request.getParameter("status"))) { %>
        <div class="alert alert-danger p-2 small text-center mb-3">El código es incorrecto o ya expiró.</div>
        <% } %>

        <!-- PASO 1: Ingresar Correo -->
        <% if (step == 1) { %>
        <p class="text-muted small mb-4 text-center">Ingresa tu correo institucional para recibir el código de verificación.</p>
        <form action="${pageContext.request.contextPath}/recuperar-contrasena" method="POST" novalidate>
            <input type="hidden" name="accion" value="solicitar">

            <div class="text-start mb-4">
                <label class="form-label text-secondary small fw-semibold mb-1">Correo Institucional</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="correo" class="form-control" placeholder="usuario@universidad.edu" required>
                </div>
            </div>

            <button type="submit" class="btn btn-navy w-100 py-2.5 fw-semibold d-flex align-items-center justify-content-center gap-2 mb-4 rounded-3 text-uppercase">
                Enviar instrucciones
            </button>
        </form>
        <% } %>

        <!-- PASO 2: Ingresar Token de Verificación -->
        <% if (step == 2) { %>
        <p class="text-muted small mb-4 text-center">Hemos enviado un código de 6 dígitos a <strong><%= correo %></strong>.</p>
        <form action="${pageContext.request.contextPath}/recuperar-contrasena" method="POST" novalidate>
            <input type="hidden" name="accion" value="verificar">
            <input type="hidden" name="correo" value="<%= correo %>">

            <div class="text-start mb-4">
                <label class="form-label text-secondary small fw-semibold mb-1">Código de Verificación</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                    <input type="text" name="token" maxlength="6" class="form-control text-center fw-bold fs-5" placeholder="123456" required>
                </div>
            </div>

            <button type="submit" class="btn btn-navy w-100 py-2.5 fw-semibold d-flex align-items-center justify-content-center gap-2 mb-4 rounded-3 text-uppercase">
                Validar Código
            </button>
        </form>
        <% } %>

        <!-- PASO 3: Ingresar Nueva Contraseña -->
        <% if (step == 3) { %>
        <p class="text-muted small mb-4 text-center">Código verificado. Ingresa tu nueva contraseña.</p>
        <form action="${pageContext.request.contextPath}/recuperar-contrasena" method="POST" novalidate>
            <input type="hidden" name="accion" value="restablecer">
            <input type="hidden" name="correo" value="<%= correo %>">
            <input type="hidden" name="token" value="<%= token %>">

            <div class="text-start mb-4">
                <label class="form-label text-secondary small fw-semibold mb-1">Contraseña</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <!-- Agregamos el pattern para exigir letras y números, y minlength para los 8 caracteres -->
                    <input type="password" name="contrasena" class="form-control has-end-icon" placeholder="••••••••" required minlength="8" pattern="(?=.*\d)(?=.*[A-Za-z]).{8,}" title="Debe contener al menos 8 caracteres, una letra y un número">
                    <span class="input-group-text end-icon" style="cursor: pointer;"><i class="bi bi-eye"></i></span>
                    <div class="invalid-feedback">La contraseña debe tener al menos 8 caracteres, incluir letras y números.</div>
                </div>
            </div>

            <button type="submit" class="btn btn-navy w-100 py-2.5 fw-semibold d-flex align-items-center justify-content-center gap-2 mb-4 rounded-3 text-uppercase">
                Cambiar Contraseña
            </button>
        </form>
        <% } %>

        <hr class="text-muted opacity-25 my-4">

        <div class="text-center">
            <a href="${pageContext.request.contextPath}/views/sesion/IniciarSesion.jsp" class="back-to-login text-decoration-none d-inline-flex align-items-center gap-2">
                <i class="bi bi-arrow-left fs-5"></i> Volver al inicio de sesión
            </a>
        </div>

    </div>
</div>

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
<!-- Coloca esto en tu vista de IniciarSesion.jsp donde quieras mostrar la alerta -->
<%
    String error = request.getParameter("error");
    if ("sin_permiso".equals(error)) {
%>
<div class="alert alert-danger alert-dismissible fade show text-center py-2 small" role="alert">
    <i class="bi bi-exclamation-triangle-fill me-1"></i> No tienes permiso para ver esta página. Inicia sesión para continuar.
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<%
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>