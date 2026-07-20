<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Simplifica tu vida Universitaria</title>
    <link href="css/bootstrap.css" rel="stylesheet">
    <link href="css/bootstrap-icons-1.13.1/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css">

    <style>
        /* Estilos personalizados para ajustar detalles específicos de la imagen */
        .bg-navy { background-color: #1a365d; }
        .text-navy { color: #1a365d; }
        .btn-navy { background-color: #1a3c73; color: white; }
        .btn-navy:hover { background-color: #112952; color: white; }
        .step-card { border: 1px solid #e2e8f0; border-radius: 8px; background-color: #ffffff; }
        .step-icon { width: 50px; height: 50px; background-color: #e0e7ff; color: #4f46e5; display: inline-flex; align-items: center; justify-content: center; border-radius: 50%; font-size: 1.5rem; }
        .bg-light-blue { background-color: #f0f4ff; border-radius: 12px; }
        .line-under { border-bottom: 3px solid #1a365d; display: inline-block; padding-bottom: 5px; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-navy py-3">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="#">LockerHub</a>
        <div class="d-flex gap-3">
            <a href="#" class="text-white text-decoration-underline small">Inicio</a>
            <a href="${pageContext.request.contextPath}/views/sesion/registro.jsp" class="text-white text-decoration-none small opacity-75">Registro</a>
            <a href="${pageContext.request.contextPath}/views/sesion/IniciarSesion.jsp" class="text-white text-decoration-none small opacity-75">Iniciar sesión</a>

        </div>
    </div>
</nav>

<section class="bg-white py-5">
    <div class="container py-4">
        <div class="row align-items-center g-5">
            <div class="col-md-6">
                <img src="img/lockers.png"
                     alt="Lockers" class="img-fluid rounded-3 shadow-sm">
            </div>
            <div class="col-md-6">
                <h1 class="display-5 fw-bold text-navy mb-3">
                    Simplifica tu vida Universitaria con LockerHub
                </h1>
                <p class="text-muted mb-4 lead fs-6">
                    La solución inteligente para el resguardo de tus pertenencias. Gestiona tu espacio personal de forma rápida, segura y 100% digital.
                </p>
                <button class="btn btn-navy px-4 py-2 fw-semibold">Comenzar ahora</button>
            </div>
        </div>
    </div>
</section>

<section class="py-5" style="background-color: #f8fafc; border-top: 1px solid #e2e8f0;">
    <div class="container text-center py-3">
        <h2 class="fw-bold text-navy mb-5">¿Cómo <span class="line-under">Funciona</span>?</h2>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="p-4 step-card h-100 shadow-sm">
                    <div class="step-icon mb-3">
                        <i class="bi bi-person-check"></i>
                    </div>
                    <h4 class="fw-bold text-navy h5">Regístrate</h4>
                    <p class="text-muted small mb-0">Usa tu matrícula para acceder de forma segura a nuestra plataforma.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-4 step-card h-100 shadow-sm">
                    <div class="step-icon mb-3">
                        <i class="bi bi-file-earmark-text"></i>
                    </div>
                    <h4 class="fw-bold text-navy h5">Solicita</h4>
                    <p class="text-muted small mb-0">Rellena el formulario de solicitud en línea en menos de dos minutos.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-4 step-card h-100 shadow-sm">
                    <div class="step-icon mb-3">
                        <i class="bi bi-door-closed"></i>
                    </div>
                    <h4 class="fw-bold text-navy h5">Obtén tu Locker</h4>
                    <p class="text-muted small mb-0">Recibe tu locker asignado y disfruta de tu espacio personal en el campus.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="py-5 bg-white">
    <div class="container">
        <div class="p-5 bg-light-blue shadow-sm">
            <h3 class="fw-bold text-navy mb-3">Gestión en tiempo real</h3>
            <p class="text-secondary mb-4">
                Visualiza la disponibilidad de lockers por edificios y pisos. Nuestro sistema te permite realizar tus solicitudes de espacio de forma digital para su posterior aprobación, sin filas ni complicaciones burocráticas.
            </p>
            <div class="d-flex gap-2">
                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-2 fw-semibold">45 Disponibles</span>
                <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-2 fw-semibold">2 Mantenimiento</span>
            </div>
        </div>
    </div>
</section>

<footer class="bg-light py-4 border-top">
    <div class="container text-muted small">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                <span class="fw-bold text-dark">LockerHub</span><br>
                <span style="font-size: 0.75rem;">© 2024 Servicios Universitarios LockerHub. Todos los derechos reservados.</span>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-muted text-decoration-none mx-2">Política de Privacidad</a>
                <a href="#" class="text-muted text-decoration-none mx-2">Términos de Servicio</a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>