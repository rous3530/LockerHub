<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="mx.edu.utez.locker.model.Administrador" %>
<%@ page import="mx.edu.utez.locker.dao.DaoSolicitud" %>
<%@ page import="mx.edu.utez.locker.model.EdificioDto" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sesion = request.getSession(false);
    Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

    // Instanciar DAO para cargar los edificios
    DaoSolicitud daoEdificio = new DaoSolicitud();
    List<EdificioDto> listaEdificios = daoEdificio.obtenerEdificios();
    // Guardar en request para que el EL (Expression Language) lo pueda usar
    request.setAttribute("listaEdificios", listaEdificios);

    // Validar que la sesión exista y que el usuario esté logueado
    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }

    if (request.getAttribute("listaPreAceptados") == null && request.getParameter("redirected") == null) {
        response.sendRedirect(request.getContextPath() + "/views/admin/pre-aceptacion?redirected=true");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Gestión de Pre-aceptados</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Hojas de Estilo Externas -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css">
</head>
<body class="d-flex flex-column min-vh-100">

<!-- Header / Navigation -->
<nav class="navbar-admin shadow-sm">
    <a class="navbar-brand fw-bold fs-4 m-0 text-white text-decoration-none" href="#">LockerHub</a>

    <div class="nav-links-center">
        <a href="${pageContext.request.contextPath}/views/admin/inicio.jsp" class="nav-link">SOLICITUDES</a>
        <a href="${pageContext.request.contextPath}/views/admin/pre-aceptacion.jsp" class="nav-link active">PRE-ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/views/admin/aceptados" class="nav-link">ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/admin/gestion-lockers" class="nav-link">GESTION LOCKER</a>
    </div>
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
<div class="container py-4 flex-grow-1" style="max-width: 1140px;">

    <!-- CABECERA SUPERIOR -->
    <header class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h2 class="h4 fw-bold mb-1" style="color: #1a365d;">Gestión de Pre-aceptados</h2>
            <p class="text-muted small mb-0">Revisa y confirma la lista de estudiantes para la asignación final de casilleros.</p>
        </div>

        <div class="d-flex align-items-center gap-2 flex-wrap">
            <div class="d-flex align-items-center gap-2 px-3 bg-white" style="border: 1px solid #cbd5e1; border-radius: 8px; width: 280px; height: 38px;">
                <i class="bi bi-search text-muted" style="font-size: 0.9rem;"></i>
                <input type="text" id="searchInput" placeholder="Buscar estudiante o matrícula..." onkeyup="filtrarTabla()" style="border: none; outline: none; font-size: 0.85rem; width: 100%; background: transparent;">
            </div>
            <button class="btn btn-sm btn-success fw-semibold px-3 d-flex align-items-center gap-1 shadow-sm" style="background-color: #16a34a; border: none; border-radius: 8px; height: 38px;" onclick="ejecutarAsignacionMasivaLockers()">
                <i class="bi bi-check-circle-fill"></i> Asignar Lockers
            </button>
            <button class="btn btn-sm btn-success fw-semibold px-3 d-flex align-items-center gap-1 shadow-sm" style="background-color: #16a34a; border: none; border-radius: 8px; height: 38px;" onclick="intentarAceptarTodos()">
                <i class="bi bi-check-circle-fill"></i> Aceptar Todos
            </button>
        </div>
    </header>

    <!-- TABLA DE PRE-ACEPTADOS -->
    <div class="card-table shadow-sm mb-4 bg-white" style="border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden;">
        <div class="table-responsive">
            <table class="table custom-table align-middle m-0" id="preAceptadosTable">
                <thead>
                <tr style="background-color: #f8fafc; border-bottom: 1px solid #e2e8f0;">
                    <th scope="col" class="py-3 ps-4" style="font-size: 0.75rem; color: #475569; font-weight: 700; width: 30%;">ESTUDIANTE</th>
                    <th scope="col" class="py-3 text-center" style="font-size: 0.75rem; color: #475569; font-weight: 700; width: 15%;">MATRÍCULA</th>
                    <th scope="col" class="py-3 text-center" style="font-size: 0.75rem; color: #475569; font-weight: 700; width: 15%;">CUATRIMESTRE</th>
                    <th scope="col" class="py-3 text-center" style="font-size: 0.75rem; color: #475569; font-weight: 700; width: 12%;">GRUPO</th>
                    <th scope="col" class="py-3 text-center" style="font-size: 0.75rem; color: #475569; font-weight: 700; width: 13%;">CASILLERO</th>
                    <th scope="col" class="py-3 text-end pe-4" style="font-size: 0.75rem; color: #475569; font-weight: 700; width: 15%;">ACCIONES</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty listaPreAceptados}">
                        <c:forEach var="item" items="${listaPreAceptados}">
                            <tr class="item-row" style="border-bottom: 1px solid #f1f5f9;">
                                <td class="ps-4 py-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="avatar-circle d-flex align-items-center justify-content-center fw-bold" style="width: 38px; height: 38px; background-color: #dbeafe; color: #1e40af; border-radius: 50%; font-size: 0.85rem; flex-shrink: 0;">
                                                ${item.nombreCompleto.substring(0,2).toUpperCase()}
                                        </div>
                                        <div>
                                            <div class="student-name fw-bold text-dark" style="font-size: 0.9rem; line-height: 1.2;">${item.nombreCompleto}</div>
                                            <div class="student-career text-muted" style="font-size: 0.75rem; margin-top: 2px;">${item.carrera}</div>
                                        </div>
                                    </div>
                                </td>

                                <td class="text-center text-secondary small font-monospace student-matricula py-3">${item.matricula}</td>

                                <td class="text-center py-3">
                                    <span style="font-size: 0.8rem; color: #334155;">${item.cuatrimestre}</span>
                                </td>

                                <td class="text-center text-secondary small fw-semibold py-3">${item.grupo}</td>

                                <td class="text-center py-3">
                                    <span class="${item.casilleroCodigo eq 'Sin asignar' ? 'text-danger fw-semibold small' : 'fw-semibold text-dark'}" style="font-size: 0.85rem;">
                                            ${item.casilleroCodigo}
                                    </span>
                                </td>

                                <td class="pe-4 text-end py-3">
                                    <c:choose>
                                        <c:when test="${item.casilleroCodigo ne 'Sin asignar'}">
                                            <button type="button" onclick="abrirModalQuitarCasillero('${item.idSolicitud}', '${item.nombreCompleto}', '${item.casilleroCodigo}')"
                                                    class="text-danger bg-transparent border-0 text-decoration-none fw-semibold d-inline-flex align-items-center justify-content-end gap-1 p-0" style="font-size: 0.8rem;">
                                                <i class="bi bi-scissors"></i> Quitar casillero
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="d-flex flex-column align-items-end gap-1">
                                                <button type="button" onclick="abrirModalAsignar('${item.idSolicitud}', '${item.nombreCompleto}', '${item.matricula}', '${item.carrera}')"
                                                        class="btn btn-sm fw-semibold px-3 py-1 d-inline-flex align-items-center gap-1 text-primary bg-white border border-primary shadow-sm rounded-2" style="font-size: 0.75rem;">
                                                    <i class="bi bi-plus-circle"></i> Asignar
                                                </button>
                                                <button type="button" onclick="abrirModalQuitarLista('${item.idSolicitud}', '${item.nombreCompleto}')"
                                                        class="text-danger bg-transparent border-0 text-decoration-none fw-semibold d-inline-flex align-items-center gap-1 p-0" style="font-size: 0.75rem;">
                                                    <i class="bi bi-person-dash"></i> Quitar de lista
                                                </button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-secondary fw-semibold small">
                                <i class="bi bi-check-circle text-secondary fs-2 d-block mb-2"></i> Ya no tiene pendientes de pre-aceptados
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <div class="card-footer bg-white border-0 py-3 px-4 d-flex justify-content-between align-items-center">
            <span class="text-muted small">Mostrando ${listaPreAceptados != null ? listaPreAceptados.size() : 0} pre-aceptados</span>
            <ul class="pagination pagination-sm m-0 gap-1 align-items-center">
                <li class="page-item disabled"><a class="page-link rounded-2 text-secondary" href="#"><i class="bi bi-chevron-left"></i></a></li>
                <li class="page-item active"><a class="page-link rounded-2 text-white" href="#" style="background-color: #1a365d; border-color: #1a365d;">1</a></li>
                <li class="page-item"><a class="page-link rounded-2 text-dark" href="#">2</a></li>
                <li class="page-item"><a class="page-link rounded-2 text-dark" href="#">3</a></li>
                <li class="page-item disabled"><span class="page-link border-0 text-secondary">...</span></li>
                <li class="page-item"><a class="page-link rounded-2 text-dark" href="#">29</a></li>
                <li class="page-item"><a class="page-link rounded-2 text-dark" href="#"><i class="bi bi-chevron-right"></i></a></li>
            </ul>
        </div>
    </div>

    <!-- TARJETAS DE MÉTRICAS INFERIORES -->
    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.25rem; margin-bottom: 2rem;">
        <div class="card shadow-sm p-4 bg-white" style="border-radius: 12px; border: 1px solid #e2e8f0; display: flex; flex-direction: row; align-items: center; gap: 1rem;">
            <div style="width: 48px; height: 48px; border-radius: 10px; background-color: #eff6ff; color: #3b82f6; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; flex-shrink: 0;">
                <i class="bi bi-people-fill"></i>
            </div>
            <div>
                <div style="font-size: 1.75rem; font-weight: 700; color: #1e293b; line-height: 1.1;">${totalEstudiantes != null ? totalEstudiantes : 0}</div>
                <span style="font-size: 0.75rem; color: #64748b; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; display: block; margin-top: 0.2rem;">Estudiantes en lista</span>
            </div>
        </div>

        <div class="card shadow-sm p-4 bg-white" style="border-radius: 12px; border: 1px solid #e2e8f0; display: flex; flex-direction: row; align-items: center; gap: 1rem;">
            <div style="width: 48px; height: 48px; border-radius: 10px; background-color: #f0fdf4; color: #16a34a; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; flex-shrink: 0;">
                <i class="bi bi-lock-fill"></i>
            </div>
            <div>
                <div style="font-size: 1.75rem; font-weight: 700; color: #1e293b; line-height: 1.1;">${casillerosDisponibles != null ? casillerosDisponibles : 0}</div>
                <span style="font-size: 0.75rem; color: #64748b; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; display: block; margin-top: 0.2rem;">Casilleros disponibles</span>
            </div>
        </div>

        <div class="card shadow-sm p-4 bg-white" style="border-radius: 12px; border: 1px solid #e2e8f0; display: flex; flex-direction: row; align-items: center; gap: 1rem;">
            <div style="width: 48px; height: 48px; border-radius: 10px; background-color: #fef2f2; color: #dc2626; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; flex-shrink: 0;">
                <i class="bi bi-exclamation-triangle-fill"></i>
            </div>
            <div>
                <div style="font-size: 1.75rem; font-weight: 700; color: #1e293b; line-height: 1.1;">${esperaCupo != null ? esperaCupo : 0}</div>
                <span style="font-size: 0.75rem; color: #64748b; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; display: block; margin-top: 0.2rem;">Estudiantes en espera de cupo</span>
            </div>
        </div>
    </div>
</div>

<!-- MODAL ASIGNAR -->
<div id="modalAsignar" class="modal">
    <div class="modal-content large">
        <span class="close-btn" onclick="cerrarModal('modalAsignar')">&times;</span>
        <h3>Asignar Casillero</h3>
        <div class="user-info-card">
            <strong id="modalEstudianteNombre"></strong>
            <p><span id="modalEstudianteMatricula"></span> | <span id="modalEstudianteCarrera"></span></p>
        </div>

        <!-- Filtros actualizados -->
        <div class="filters-row">
            <input type="text" id="buscarLockerInput" placeholder="Ej. 101" onkeyup="filtrarLockersModal()">

            <select id="filtroEdificio" onchange="filtrarLockersModal()">
                <option value="">Todos los edificios</option>
                <c:forEach var="edif" items="${listaEdificios}">
                    <%-- Aquí debe ir idEdificio, no el nombre --%>
                    <option value="${edif.idEdificio}">${edif.nombre}</option>
                </c:forEach>
            </select>

            <select id="filtroPiso" onchange="filtrarLockersModal()">
                <option value="">Todas las plantas</option>
                <option value="PLANTA BAJA">PLANTA BAJA</option>
                <option value="PLANTA ALTA">PLANTA ALTA</option>
            </select>
        </div>

        <div class="lockers-grid" id="lockersGrid"></div>

        <div class="modal-footer" style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #e2e8f0; padding-top: 1rem; margin-top: 1rem;">
            <span>Seleccionado: <strong id="lockerSeleccionadoTexto">Ninguno</strong></span>
            <div style="display: flex; gap: 0.5rem;">
                <button class="btn btn-secondary" onclick="cerrarModal('modalAsignar')">Cancelar</button>
                <button class="btn btn-primary" id="btnConfirmarAsignacion" disabled onclick="confirmarSeleccionLocker()">Confirmar Asignación</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL ALERTA -->
<div id="modalAlerta" class="modal">
    <div class="modal-content centered" style="text-align: center;">
        <div class="modal-icon" id="alertaIcono"></div>
        <h3 id="alertaTitulo"></h3>
        <p id="alertaMensaje"></p>
        <div class="modal-footer-centered" id="alertaBotones" style="display: flex; justify-content: center; gap: 0.75rem; margin-top: 1rem;"></div>
    </div>
</div>

<footer class="bg-white py-3 border-top mt-auto">
    <div class="container px-4 text-muted" style="font-size: 0.75rem; max-width: 1140px;">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                © 2026 LockerHub Administrative Management System. Universidad Tecnológica.
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-muted text-decoration-none mx-2">Términos y Condiciones</a>
                <a href="#" class="text-muted text-decoration-none mx-2">Soporte Técnico</a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/admin/pre-aceptacion.js"></script>
</body>
</html>