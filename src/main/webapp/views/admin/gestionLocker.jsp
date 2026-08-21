<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="mx.edu.utez.locker.model.Administrador" %>
<%@ page import="mx.edu.utez.locker.dao.DaoSolicitud" %>
<%@ page import="mx.edu.utez.locker.model.EdificioDto" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%

    DaoSolicitud daoEdificio = new DaoSolicitud();
    List<EdificioDto> listaEdificios = daoEdificio.obtenerEdificios();
    HttpSession sesion = request.getSession(false);
    Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }
    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Gestión de Casilleros</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css">

    <style>
        :root {
            --lh-navy: #1b365d;
            --lh-navy-dark: #112440;
            --lh-green: #086328;
            --lh-red: #8b0000;
            --lh-bg-light: #f4f6fb;
            --lh-table-header: #eef2ff;
        }

        body {
            background-color: var(--lh-bg-light);
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
        }

        .bg-navy { background-color: var(--lh-navy) !important; }

        .metric-card {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background-color: #ffffff;
        }
        .metric-title {
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            color: #64748b;
        }

        /* Estilo unificado para la barra de filtros y búsqueda superior */
        .filter-bar-container {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
        }
        .search-box-custom {
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 8px 14px;
            background-color: #fff;
            flex: 1;
            min-width: 260px;
        }
        .search-box-custom input {
            border: none;
            outline: none;
            font-size: 0.875rem;
            width: 100%;
        }
        .filter-controls-custom {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<!-- Header / Navigation -->
<nav class="navbar-admin shadow-sm">
    <a class="navbar-brand fw-bold fs-4 m-0 text-white text-decoration-none" href="#">LockerHub</a>

    <div class="nav-links-center">
        <a href="${pageContext.request.contextPath}/views/admin/inicio.jsp" class="nav-link">SOLICITUDES</a>
        <a href="${pageContext.request.contextPath}/views/admin/pre-aceptacion.jsp" class="nav-link">PRE-ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/views/admin/aceptados" class="nav-link">ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/views/admin/gestionLocker.jsp" class="nav-link active">GESTION LOCKER</a>
    </div>

    <div class="nav-actions-right d-flex align-items-center gap-3 text-white">
        <a href="${pageContext.request.contextPath}/cerrar-sesion" class="btn btn-link text-muted p-1 border-end pe-3">
            <i class="bi bi-box-arrow-right fs-5"></i>
        </a>
        <div class="user-avatar-nav d-flex align-items-center">
            <img src="https://ui-avatars.com/api/?name=Admin+User&background=3b82f6&color=fff" alt="Perfil" style="width: 32px; height: 32px; border-radius: 50%;">
        </div>
    </div>
</nav>

<!-- Main Container -->
<main class="container-fluid px-4 py-4 flex-grow-1">

    <!-- Encabezado de Sección -->
    <header class="mb-4">
        <h2 class="h4 fw-bold text-navy mb-1">Gestión de Casilleros</h2>
        <p class="text-muted small mb-0">Visualice y gestione la disponibilidad de casilleros por edificio y nivel dentro de la red LockerHub.</p>
    </header>

    <!-- Tarjetas de Métricas / Resumen -->
    <section class="row g-4 mb-4">
        <!-- Total Casilleros -->
        <div class="col-md-3">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">TOTAL DE CASILLEROS</span>
                    <i class="bi bi-lock text-navy fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1">${totalCasilleros != null ? totalCasilleros : '1,248'}</h2>
                <p class="text-muted small mb-0">Capacidad instalada</p>
            </div>
        </div>

        <!-- Ocupados -->
        <div class="col-md-3">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">OCUPADOS</span>
                    <i class="bi bi-lock-fill text-danger fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1">${ocupados != null ? ocupados : '1,061'}</h2>
                <div class="progress mt-2" style="height: 6px;">
                    <div class="progress-bar bg-danger" role="progressbar" style="width: 85%;"></div>
                </div>
            </div>
        </div>

        <!-- Disponibles -->
        <div class="col-md-3">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">DISPONIBLES</span>
                    <i class="bi bi-check-circle text-success fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1">${disponibles != null ? disponibles : '120'}</h2>
                <p class="text-success small mb-0 fw-semibold">12% Libre</p>
            </div>
        </div>

        <!-- En Mantenimiento -->
        <div class="col-md-3">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">EN MANTENIMIENTO</span>
                    <i class="bi bi-tools text-primary fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1">${mantenimiento != null ? mantenimiento : '67'}</h2>
                <p class="text-muted small mb-0">Revisión técnica</p>
            </div>
        </div>
    </section>

    <!-- Barra de Filtros y Buscador Corregida -->
    <section class="filter-bar-container mb-4">
        <div class="search-box-custom">
            <i class="bi bi-search text-muted"></i>
            <input type="text" id="inputBuscarCasillero" placeholder="Buscar casillero..." onkeyup="aplicarFiltros()">
        </div>

        <div class="filter-controls-custom">
            <select id="selectEdificio" class="form-select form-select-sm" style="width: 160px;" onchange="aplicarFiltros()">
                <option value="">Edificio (Todos)</option>
                <%
                    // Asegúrate de importar la lista y el DTO correspondiente arriba en tu JSP si es necesario
                    List<EdificioDto> listaEdificios = (List<EdificioDto>) request.getAttribute("listaEdificios");
                    if (listaEdificios != null) {
                        for (EdificioDto ed : listaEdificios) {
                %>
                <option value="<%= ed.getNombre() %>"><%= ed.getNombre() %></option>
                <%
                        }
                    }
                %>
            </select>

            <select id="selectPiso" class="form-select form-select-sm" style="width: 140px;" onchange="aplicarFiltros()">
                <option value="">Piso (Todos)</option>
                <option value="Planta Baja">Planta Baja</option>
                <option value="Planta Alta">Planta Alta</option>
            </select>

            <button class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-1 px-3 py-1" title="Filtros avanzados">
                <i class="bi bi-gear"></i> Filtros
            </button>
        </div>
    </section>

    <!-- Grid de Tarjetas de Casilleros (Limpiado y conectado al Backend) -->
    <section id="gridCasilleros" class="lockers-grid mb-4">
        <c:choose>
            <c:when test="${not empty listaCasilleros}">
                <c:forEach var="casillero" items="${listaCasilleros}">
                    <div class="card-locker" data-codigo="${casillero.codigo}" data-edificio="${casillero.edificio}" data-piso="${casillero.piso}">
                        <div class="card-locker-header">
                            <h3 class="locker-code">${casillero.codigo}</h3>
                            <c:choose>
                                <c:when test="${casillero.estado == 'DISPONIBLE'}">
                                    <span class="badge-status success">● DISPONIBLE</span>
                                </c:when>
                                <c:when test="${casillero.estado == 'OCUPADO'}">
                                    <span class="badge-status danger">🔒 OCUPADO</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status info">🔧 MANTENIMIENTO</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-locker-body">
                            <p>🏢 ${casillero.edificio}</p>
                            <p>📍 ${casillero.piso}</p>
                        </div>
                        <div class="card-locker-footer">
                            <c:choose>
                                <c:when test="${casillero.estado == 'DISPONIBLE'}">
                                    <button class="btn-outline-primary" onclick="verDetalles('${casillero.codigo}')">Ver Detalles</button>
                                </c:when>
                                <c:when test="${casillero.estado == 'OCUPADO'}">
                                    <button class="btn-outline-primary" onclick="gestionarCasillero('${casillero.codigo}')">Gestionar</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn-outline-primary" onclick="verEstadoMantenimiento('${casillero.codigo}')">Ver Estado</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 w-100 text-muted">
                    <p class="fw-semibold small mb-0">No hay casilleros registrados o disponibles con los criterios seleccionados.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

</main>

<footer class="bg-white py-3 border-top mt-auto">
    <div class="container-fluid px-4 text-muted" style="font-size: 0.75rem;">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                © 2026 LockerHub Administrative Management System.
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-muted text-decoration-none mx-2">Términos y Condiciones</a>
                <a href="#" class="text-muted text-decoration-none mx-2">Soporte Técnico</a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/admin/gestionLocker.js"></script>
</body>
</html>