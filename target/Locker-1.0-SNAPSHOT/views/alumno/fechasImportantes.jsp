<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Fechas Importantes</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/fechasImportantes.css">
</head>
<body>

<div class="content-wrapper">

    <nav class="navbar navbar-expand-lg bg-white border-bottom py-3">
        <div class="container-fluid px-4 d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
                <span class="fs-4 fw-bold text-navy-brand"><i class="bi bi-shield-lock-fill"></i> LockerHub</span>
                <span class="text-muted border-start ps-3 d-none d-sm-inline font-sub">Bienvenido, Estudiante</span>
            </div>

            <div class="d-flex gap-3 align-items-center">
                <a href="${pageContext.request.contextPath}/views/alumno/inicio.jsp" class="nav-link-custom">Inicio</a>
                <a href="#" class="nav-link-custom active">Calendario</a>
            </div>

            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-link text-secondary p-1 fs-5"><i class="bi bi-bell"></i></button>
                <button class="btn btn-link text-secondary p-1 fs-5"><i class="bi bi-gear"></i></button>
                <div class="d-flex align-items-center gap-2">
                    <img src="${pageContext.request.contextPath}/img/avatar-estudiante.png"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/default-avatar.png';"
                         alt="Avatar"
                         class="rounded-circle"
                         style="width: 32px; height: 32px; object-fit: cover;">
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-link text-secondary p-1 fs-5">
                        <i class="bi bi-box-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <main class="container main-layout flex-grow-1 d-flex flex-column justify-content-center align-items-center py-5">

        <div class="w-100 max-container-width mb-4">
            <a href="${pageContext.request.contextPath}/views/alumno/inicio.jsp" class="text-navy-link d-inline-flex align-items-center gap-2">
                <i class="bi bi-arrow-left"></i> Volver
            </a>
        </div>

        <div class="text-center max-container-width mb-5">
            <h1 class="text-navy-title mb-3">Fechas Importantes</h1>
            <p class="text-muted-dark mx-auto" style="max-width: 650px; font-size: 0.95rem; line-height: 1.6;">
                Mantente al tanto del calendario académico de gestión de lockers. No pierdas los plazos críticos para asegurar tu espacio de almacenamiento este semestre.
            </p>
        </div>

        <div class="card-custom calendar-card max-container-width p-4 p-md-5 w-100">
            <div class="d-flex flex-column gap-5">

                <div class="d-flex align-items-start gap-4">
                    <div class="circle-icon circle-green">
                        <i class="bi bi-clock"></i>
                    </div>
                    <div>
                        <h3 class="date-title">Fecha de despojo</h3>
                        <p class="date-range">17 de Agosto - 21 de Agosto</p>
                    </div>
                </div>

                <div class="d-flex align-items-start gap-4">
                    <div class="circle-icon circle-red">
                        <i class="bi bi-clock"></i>
                    </div>
                    <div>
                        <h3 class="date-title">Límite de renovación</h3>
                        <p class="date-range">1 de Septiembre - 4 de Septiembre</p>
                    </div>
                </div>

                <div class="d-flex align-items-start gap-4">
                    <div class="circle-icon circle-blue">
                        <i class="bi bi-calendar-event"></i>
                    </div>
                    <div>
                        <h3 class="date-title">Inicio de solicitud</h3>
                        <p class="date-range">11 de Septiembre - 15 de Septiembre</p>
                    </div>
                </div>

            </div>
        </div>

    </main>
</div>

<footer class="py-3 border-top bg-white w-100">
    <div class="container-fluid px-4 d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
        <span class="text-muted-light">© 2024 LockerHub University Services. Todos los derechos reservados.</span>
        <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/politica-privacidad.jsp">Política de Privacidad</a>
            <a href="${pageContext.request.contextPath}/terminos.jsp">Términos de Servicio</a>
            <a href="${pageContext.request.contextPath}/soporte.jsp">Soporte</a>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>