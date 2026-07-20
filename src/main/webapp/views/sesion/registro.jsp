<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Registro</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css">
</head>
<body class="bg-light" style="min-height: 100vh; display: flex; flex-direction: column;">

<nav class="navbar navbar-dark bg-navy py-3 shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="#">LockerHub</a>
        <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-white text-decoration-none small opacity-75">Inicio</a>
            <a href="#" class="text-white text-decoration-underline small fw-bold">Registro</a>
        </div>
    </div>
</nav>

<div class="container d-flex flex-grow-1 justify-content-center align-items-center py-5">
    <div class="register-container p-5 shadow-sm text-center">

        <h2 class="fw-bold text-navy h3 mb-2">Registro</h2>
        <p class="text-muted small mb-4">Crea tu cuenta institucional para gestionar tus lockers.</p>

        <form novalidate>

            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Nombre completo</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" placeholder="Ej. Juan Pérez" required>
                    <div class="invalid-feedback">Este campo es obligatorio.</div>
                </div>
            </div>

            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Correo Institucional</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-at"></i></span>
                    <input type="email" class="form-control" placeholder="usuario@universidad.edu" required>
                    <div class="invalid-feedback">Ingresa un correo institucional válido (@universidad.edu).</div>
                </div>
            </div>

            <div class="text-start mb-4">
                <label class="form-label text-secondary small fw-semibold mb-1">Contraseña</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control has-end-icon" placeholder="••••••••" required minlength="8">
                    <span class="input-group-text end-icon"><i class="bi bi-eye"></i></span>
                    <div class="invalid-feedback">La contraseña debe tener al menos 8 caracteres.</div>
                </div>
            </div>

            <button type="submit" class="btn btn-navy w-100 py-2.5 fw-semibold d-flex align-items-center justify-content-center gap-2 mb-4 rounded-3">
                Registrarse <i class="bi bi-arrow-right fs-5"></i>
            </button>

            <hr class="text-muted opacity-25 my-4">

            <p class="mb-0 small text-secondary">
                ¿Ya tienes una cuenta? <a href="${pageContext.request.contextPath}/views/sesion/IniciarSesion.jsp" class="text-navy fw-bold text-decoration-none">Inicia sesión aquí</a>
            </p>
        </form>

    </div>
</div>

<footer class="bg-white py-4 border-top mt-auto">
    <div class="container text-muted" style="font-size: 0.75rem;">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                <span class="fw-semibold text-dark">LockerHub</span> &nbsp; | &nbsp; <a href="#" class="text-muted text-decoration-none">Privacy Policy</a> &nbsp; <a href="#" class="text-muted text-decoration-none">Terms of Service</a> &nbsp; <a href="#" class="text-muted text-decoration-none">Help Center</a>
            </div>
            <div class="col-md-6 text-center text-md-end">
                © 2024 LockerHub University Services
            </div>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/sesion/registro.js"></script>
</body>
</html>