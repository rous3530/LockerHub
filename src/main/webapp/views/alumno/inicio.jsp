<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mx.edu.utez.locker.model.Alumno" %>
<%@ page import="mx.edu.utez.locker.model.AlumnoDashboardDto" %>
<%@ page import="mx.edu.utez.locker.model.SolicitudDto" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sesion = request.getSession(false);
    Alumno alumnoSesion = (sesion != null) ? (Alumno) sesion.getAttribute("usuario") : null;

    if (alumnoSesion == null) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }
    // Validar que la sesión exista y que el usuario esté logueado
    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }

    AlumnoDashboardDto dashboard = (AlumnoDashboardDto) request.getAttribute("dashboard");
    List<SolicitudDto> historial = (List<SolicitudDto>) request.getAttribute("historial");

    String nombre = (dashboard != null && dashboard.getNombreCompleto() != null) ? dashboard.getNombreCompleto() : alumnoSesion.getNombres();
    String matricula = (dashboard != null && dashboard.getMatricula() != null) ? dashboard.getMatricula() : alumnoSesion.getMatricula();
    String carrera = (dashboard != null && dashboard.getCarrera() != null) ? dashboard.getCarrera() : "Carrera no asignada";
%>
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

<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-white border-bottom py-2 mb-4">
    <div class="container-fluid px-4">
        <div class="row w-100 align-items-center m-0" style="justify-content: space-between;">
            <div class="col-4 d-flex justify-content-start align-items-center p-0">
                <a class="navbar-brand d-flex align-items-center fw-bold text-navy-brand m-0" href="#">LockerHub</a>
                <span class="text-muted d-none d-md-inline border-start ps-3 ms-3 small">Bienvenido, Estudiante</span>
            </div>

            <div class="col-4 d-flex justify-content-end align-items-center gap-3 p-0">
                <a href="${pageContext.request.contextPath}/views/alumno/editarPerfil.jsp" class="btn btn-link text-muted p-1">
                    <i class="bi bi-gear fs-5"></i>
                </a>
                <a href="${pageContext.request.contextPath}/cerrar-sesion" class="btn btn-link text-muted p-1 border-end pe-3">
                    <i class="bi bi-box-arrow-right fs-5"></i>
                </a>
                <div class="d-flex align-items-center gap-2 ps-2">
                    <div class="text-end d-none d-sm-block lh-1">
                        <div class="fw-bold text-dark small mb-1"><%= nombre %></div>
                        <span class="text-muted text-micro">ID: <%= matricula %></span>
                    </div>
                    <img src="https://ui-avatars.com/api/?name=<%= nombre.replace(" ", "+") %>&background=1a365d&color=fff&size=100" class="rounded-circle border" width="36" height="36" alt="Avatar">
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="content-wrapper">
    <div class="container-fluid px-4 main-layout">

        <!-- Banner de Perfil -->
        <div class="card card-custom p-4 mb-3 bg-gradient-profile">
            <div class="d-flex flex-column flex-md-row align-items-center gap-4">
                <div class="position-relative">
                    <img src="https://ui-avatars.com/api/?name=<%= nombre.replace(" ", "+") %>&background=1a365d&color=fff&size=150" class="rounded-circle border border-2 border-white shadow-sm" width="100" height="100" alt="Avatar Alumno">
                    <a href="${pageContext.request.contextPath}/views/alumno/editarPerfil.jsp"
                       class="btn btn-navy position-absolute bottom-0 end-0 rounded-circle edit-avatar-btn d-inline-flex align-items-center justify-content-center"
                       style="width: 32px; height: 32px; padding: 0;">
                        <i class="bi bi-pencil-fill text-white" style="font-size: 0.85rem;"></i>
                    </a>
                </div>
                <div class="text-center text-md-start">
                    <h2 class="fw-bold text-navy-title mb-1"><%= nombre %></h2>
                    <p class="text-muted-dark mb-3 fw-medium">Matrícula: <%= matricula %> <span class="mx-1 text-muted-light">•</span> <%= carrera %></p>
                    <div class="d-flex flex-wrap justify-content-center justify-content-md-start gap-2">
                        <span class="badge-pill-custom bg-pill-blue text-pill-blue"><i class="bi bi-shield-check"></i> Cuenta Activa</span>
                        <span class="badge-pill-custom bg-pill-indigo text-pill-indigo"><i class="bi bi-calendar-event"></i> Cuatrimestre: <%= (dashboard != null && dashboard.getCuatrimestreActual() != null) ? dashboard.getCuatrimestreActual() : "Vigente" %></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-3">

            <!-- Card: Mi Locker Actual -->
            <div class="col-lg-4">
                <div class="card card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="fw-bold text-navy-title m-0 fs-5">Mi Locker Actual</h4>
                            <span class="badge badge-status <%= (dashboard != null && "ASIGNADO".equalsIgnoreCase(dashboard.getEstatusLocker())) ? "bg-status-success text-status-success" : "bg-status-gray text-status-gray" %>">
                                <%= (dashboard != null && dashboard.getEstatusLocker() != null) ? dashboard.getEstatusLocker() : "SIN ASIGNAR" %>
                            </span>
                        </div>

                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div class="bg-icon-box rounded-3 text-navy-brand icon-container-box">
                                <i class="bi bi-lock-fill fs-1 text-primary" style="color: #1a365d !important;"></i>
                            </div>
                            <div>
                                <span class="text-muted-light text-micro text-uppercase d-block fw-semibold tracking-wider mb-1">ID DEL LOCKER</span>
                                <span class="fw-bold text-navy-title fs-4 d-block lh-1 mb-1">
                                    <%= (dashboard != null && dashboard.getIdLocker() != null) ? dashboard.getIdLocker() : "N/A" %>
                                </span>
                                <span class="text-muted small">Ubicación Asignada</span>
                            </div>
                        </div>
                    </div>

                    <div class="bg-light-blue p-3">
                        <div class="row g-2">
                            <div class="col-6 border-end border-light-divider">
                                <span class="text-muted-light text-micro text-uppercase d-block fw-semibold mb-1">EDIFICIO</span>
                                <span class="fw-bold text-navy-title small"><%= (dashboard != null && dashboard.getEdificio() != null) ? dashboard.getEdificio() : "-" %></span>
                            </div>
                            <div class="col-6 ps-3">
                                <span class="text-muted-light text-micro text-uppercase d-block fw-semibold mb-1">PISO</span>
                                <span class="fw-bold text-navy-title small"><%= (dashboard != null && dashboard.getPiso() != null) ? dashboard.getPiso() : "-" %></span>
                            </div>
                            <div class="col-12 border-top border-light-divider pt-2 mt-2">
                                <span class="text-muted-light text-micro text-uppercase d-block fw-semibold mb-1">PERIODO VIGENTE</span>
                                <span class="fw-bold text-navy-title small"><%= (dashboard != null && dashboard.getPeriodoVigente() != null) ? dashboard.getPeriodoVigente() : "-" %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card: Mis Solicitudes -->
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
                                <% if (historial != null && !historial.isEmpty()) {
                                    for (SolicitudDto sol : historial) { %>
                                <tr>
                                    <td>
                                        <div class="fw-bold text-navy-title">Solicitud #<%= sol.getIdSolicitud() %></div>
                                    </td>
                                    <td class="fw-bold text-navy-title"><%= (sol.getGrupo() != null) ? sol.getGrupo() : "Pendiente" %></td>
                                    <td>
                                        <span class="badge badge-status <%= "ASIGNADO".equalsIgnoreCase(sol.getEstado()) ? "bg-status-success text-status-success" : "bg-status-indigo text-status-indigo" %>">
                                            <%= sol.getEstado() %>
                                        </span>
                                    </td>
                                    <td class="text-end text-muted-dark small fw-medium"><%= (sol.getCuatrimestre() != null) ? sol.getCuatrimestre() : "-" %></td>
                                </tr>
                                <%   }
                                } else { %>
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-3">No cuentas con solicitudes registradas.</td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="text-center pt-3 border-top border-light-divider">
                        <span class="text-muted-light text-micro fw-medium">Historial sincronizado con la base de datos.</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Fila de Accesos Rápidos -->
        <div class="row g-3">
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/views/alumno/solicitarLocker.jsp" class="step-card text-decoration-none">
                    <div class="step-icon">
                        <i class="bi bi-plus-circle"></i>
                    </div>
                    <div class="step-text-container">
                        <h5 class="small-title">Solicitar Locker</h5>
                        <p class="step-desc">Inicia el trámite para obtener un nuevo espacio.</p>
                    </div>
                </a>
            </div>

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

<footer class="bg-white border-top py-3 mt-auto">
    <div class="container-fluid px-4 d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
        <span class="text-muted-light text-micro">© 2026 LockerHub - Portal Universitario</span>
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