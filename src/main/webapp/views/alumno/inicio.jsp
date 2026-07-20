<%--
  Created by IntelliJ IDEA.
  User: josef
  Date: 7/2/2026
  Time: 11:49 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Portal Universitario</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght=300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerAlumno.css">
</head>
<body class="bg-page">

<nav class="navbar navbar-expand-lg bg-white border-bottom py-2 mb-4">
    <div class="container-fluid px-4">
        <div class="row w-100 align-items-center m-0" style="justify-content: space-between;">

            <!-- Columna Izquierda: Logo y Mensaje de Bienvenida -->
            <div class="col-4 d-flex justify-content-start align-items-center p-0">
                <a class="navbar-brand d-flex align-items-center fw-bold text-navy-brand m-0" href="#">
                    LockerHub
                </a>
                <span class="text-muted d-none d-md-inline border-start ps-3 ms-3 small">Bienvenido, Estudiante</span>
            </div>

            <!-- Columna Derecha: Configuración, Salida y Perfil -->
            <div class="col-4 d-flex justify-content-end align-items-center gap-3 p-0">
                <!-- Reemplaza el botón de la tuerca en tu navbar por este enlace -->
                <a href="${pageContext.request.contextPath}/views/alumno/editarPerfil.jsp" class="btn btn-link text-muted p-1">
                    <i class="bi bi-gear fs-5"></i>
                </a>
                <button class="btn btn-link text-muted p-1 border-end pe-3" onclick="location.href='${pageContext.request.contextPath}/logout'"><i class="bi bi-box-arrow-right fs-5"></i></button>
                <div class="d-flex align-items-center gap-2 ps-2">
                    <div class="text-end d-none d-sm-block lh-1">
                        <div class="fw-bold text-dark small mb-1">Carlos Mendoza</div>
                        <span class="text-muted text-micro">ID: 2023-0452</span>
                    </div>
                    <img src="https://ui-avatars.com/api/?name=Carlos+Mendoza&background=1a365d&color=fff&size=100" class="rounded-circle border" width="36" height="36" alt="Avatar">
                </div>
            </div>

        </div>
    </div>
</nav>

<div class="content-wrapper">
    <div class="container-fluid px-4 main-layout">

        <div class="card card-custom p-4 mb-3 bg-gradient-profile">
            <div class="d-flex flex-column flex-md-row align-items-center gap-4">
                <div class="position-relative">
                    <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150" class="rounded-circle border border-2 border-white shadow-sm" width="100" height="100" alt="Avatar Alumna">
                    <a href="${pageContext.request.contextPath}/views/alumno/editarPerfil.jsp"
                       class="btn btn-navy position-absolute bottom-0 end-0 rounded-circle edit-avatar-btn d-inline-flex align-items-center justify-content-center"
                       style="width: 32px; height: 32px; padding: 0;">
                        <i class="bi bi-pencil-fill text-white" style="font-size: 0.85rem;"></i>
                    </a>
                </div>
                <div class="text-center text-md-start">
                    <h2 class="fw-bold text-navy-title mb-1">Carlos Enrique Mendoza Ruiz</h2>
                    <p class="text-muted-dark mb-3 fw-medium">Matrícula: 2023-0452 <span class="mx-1 text-muted-light">•</span> Ingeniería en Software</p>
                    <div class="d-flex flex-wrap justify-content-center justify-content-md-start gap-2">
                        <span class="badge-pill-custom bg-pill-blue text-pill-blue"><i class="bi bi-shield-check"></i> Cuenta Activa</span>
                        <span class="badge-pill-custom bg-pill-indigo text-pill-indigo"><i class="bi bi-calendar-event"></i> Cuatrimestre: Mayo - Agosto</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-3">

            <div class="col-lg-4">
                <div class="card card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="fw-bold text-navy-title m-0 fs-5">Mi Locker Actual</h4>
                            <span class="badge badge-status bg-status-success text-status-success">ACTIVO</span>
                        </div>

                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div class="bg-icon-box rounded-3 text-navy-brand icon-container-box">
                                <i class="bi bi-lock-fill fs-1 text-primary" style="color: #1a365d !important;"></i>
                            </div>
                            <div>
                                <span class="text-muted-light text-micro text-uppercase d-block fw-semibold tracking-wider mb-1">ID DEL LOCKER</span>
                                <span class="fw-bold text-navy-title fs-4 d-block lh-1 mb-1">Locker D1-13</span>
                                <span class="text-muted small">Ubicación Estratégica</span>
                            </div>
                        </div>
                    </div>

                    <div class="bg-light-blue p-3">
                        <div class="row g-2">
                            <div class="col-6 border-end border-light-divider">
                                <span class="text-muted-light text-micro text-uppercase d-block fw-semibold mb-1">EDIFICIO</span>
                                <span class="fw-bold text-navy-title small">Docencia 1</span>
                            </div>
                            <div class="col-6 ps-3">
                                <span class="text-muted-light text-micro text-uppercase d-block fw-semibold mb-1">PISO</span>
                                <span class="fw-bold text-navy-title small">2 (Nivel Central)</span>
                            </div>
                            <div class="col-12 border-top border-light-divider pt-2 mt-2">
                                <span class="text-muted-light text-micro text-uppercase d-block fw-semibold mb-1">PERIODO VIGENTE</span>
                                <span class="fw-bold text-navy-title small">Mayo - Agosto 2024</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="fw-bold text-navy-title m-0 fs-5">Mis Solicitudes</h4>
                            <a href="${pageContext.request.contextPath}/views/alumno/HistorialSolicitud.jsp" class="small-link text-decoration-none fw-bold text-navy-link">Ver Historial Completo</a>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-custom align-middle m-0">
                                <thead>
                                <tr>
                                    <th>SOLICITUD / TIPO</th>
                                    <th>LOCKER REF.</th>
                                    <th>ESTADO</th>
                                    <th class="text-end">PERIODO</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td>
                                        <div class="fw-bold text-navy-title">Solicitud Activa</div>
                                        <div class="text-muted-light text-micro">Folio: #S-88219</div>
                                    </td>
                                    <td class="fw-bold text-navy-title">Locker D1-13</td>
                                    <td><span class="badge badge-status bg-status-success text-status-success">ASIGNADO</span></td>
                                    <td class="text-end text-muted-dark small fw-medium">Mayo - Agosto</td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="fw-bold text-muted-row">Solicitud Pasada</div>
                                        <div class="text-muted-light text-micro">Folio: #S-44102</div>
                                    </td>
                                    <td class="fw-bold text-muted-row">Locker D4-7</td>
                                    <td><span class="badge badge-status bg-status-gray text-status-gray">EXPIRADO</span></td>
                                    <td class="text-end text-muted-dark small fw-medium">Enero - Abril</td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="fw-bold text-muted-row">Solicitud Pasada</div>
                                        <div class="text-muted-light text-micro">Folio: #S-12005</div>
                                    </td>
                                    <td class="fw-bold text-muted-row">Locker B2-11</td>
                                    <td><span class="badge badge-status bg-status-indigo text-status-indigo">FINALIZADO</span></td>
                                    <td class="text-end text-muted-dark small fw-medium">Sept - Dic 2023</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="text-center pt-3 border-top border-light-divider">
                        <span class="text-muted-light text-micro fw-medium">Mostrando 3 de 8 registros históricos.</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Fila de Accesos Rápidos (Botones Inferiores con Squircle containers) -->
        <div class="row g-3">
            <!-- Botón 1: Solicitar Locker -->
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/alumno/solicitarLocker.jsp" class="step-card text-decoration-none">
                    <div class="step-icon">
                        <i class="bi bi-plus-circle"></i>
                    </div>
                    <div class="step-text-container">
                        <h5 class="small-title">Solicitar Locker</h5>
                        <p class="step-desc">Inicia el trámite para obtener un nuevo espacio.</p>
                    </div>
                </a>
            </div>

            <!-- Botón 2: Fechas Importantes (Redirecciona a tu nueva vista) -->
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/views/alumno/fechasImportantes.jsp" class="step-card text-decoration-none">
                    <div class="step-icon">
                        <i class="bi bi-calendar3"></i>
                    </div>
                    <div class="step-text-container">
                        <h5 class="small-title">Fechas Importantes</h5>
                        <p class="step-desc">Consulta el calendario de trámites y renovaciones.</p>
                    </div>
                </a>
            </div>

            <!-- Botón 3: Reglamento de Uso -->
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/views/alumno/reglamento.jsp" class="step-card text-decoration-none">
                    <div class="step-icon bg-status-danger-light">
                        <i class="bi bi-shield-exclamation"></i>
                    </div>
                    <div class="step-text-container">
                        <h5 class="small-title">Reglamento de Uso</h5>
                        <p class="step-desc">Consulta las normas de convivencia y seguridad.</p>
                    </div>
                </a>
            </div>
        </div>
    </div>
</div>
<div style="padding: 2.5rem 0rem"></div>
<footer class="bg-white border-top py-3 mt-auto">
    <div class="container-fluid px-4 d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
        <span class="text-muted-light text-micro">© 2024 LockerHub - Portal Universitario</span>
        <div class="d-flex gap-4 text-micro">
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Términos y Condiciones</a>
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Política de Privacidad</a>
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Soporte Técnico</a>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>