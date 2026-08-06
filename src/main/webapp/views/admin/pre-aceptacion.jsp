<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Gestión de Pre-aceptados</title>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css">
</head>
<body>

<nav class="navbar-admin">
    <div class="navbar-brand">LockerHub</div>

    <div class="nav-links-center">
        <a href="${pageContext.request.contextPath}/views/admin/inicio.jsp" class="nav-link">SOLICITUDES</a>
        <a href="${pageContext.request.contextPath}/views/admin/pre-aceptacion.jsp" class="nav-link active">PRE-ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/views/admin/aceptados.jsp" class="nav-link">ACEPTADOS</a>
    </div>

    <!-- Iconos de usuario y perfil a la derecha -->
    <div class="nav-actions-right">
        <i class="bi bi-bell"></i>
        <i class="bi bi-gear"></i>
        <i class="bi bi-question-circle"></i>
        <div class="user-avatar-nav">
            <img src="https://ui-avatars.com/api/?name=Admin+User&background=3b82f6&color=fff" alt="Perfil">
        </div>
    </div>
</nav>

<main class="container">
    <!-- Encabezado y Acciones Principales -->
    <header class="header-section">
        <div class="header-title">
            <h2>Gestión de Pre-aceptados</h2>
            <p>Revisa y confirma la lista de estudiantes para la asignación final de casilleros.</p>
        </div>

        <div class="header-actions">
            <div class="search-box">
                <i class="bi bi-search"></i>
                <input type="text" id="searchInput" placeholder="Buscar estudiante o matrícula..." onkeyup="filtrarTabla()">
            </div>
            <button class="btn btn-success" onclick="asignarLockersAutomatico()">
                <i class="bi bi-check-circle-fill"></i> Asignar Lockers
            </button>
            <button class="btn btn-success" onclick="intentarAceptarTodos()">
                <i class="bi bi-check-circle-fill"></i> Aceptar Todos
            </button>
        </div>
    </header>

    <!-- Tabla de Estudiantes Pre-aceptados -->
    <section class="table-container">
        <table id="preAceptadosTable">
            <thead>
            <tr>
                <th>ESTUDIANTE</th>
                <th>MATRÍCULA</th>
                <th>CUATRIMESTRE</th>
                <th>GRUPO</th>
                <th>CASILLERO</th>
                <th>ACCIONES</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty listaPreAceptados}">
                    <c:forEach var="item" items="${listaPreAceptados}">
                        <tr data-id="${item.estudiante.id}">
                            <td>
                                <!-- Avatar con Iniciales + Datos -->
                                <div class="student-cell">
                                    <div class="avatar-circle">
                                            ${item.estudiante.nombre.substring(0,2).toUpperCase()}
                                    </div>
                                    <div>
                                        <strong>${item.estudiante.nombre}</strong>
                                        <small class="text-muted" style="display:block;">${item.estudiante.carrera}</small>
                                    </div>
                                </div>
                            </td>
                            <td>${item.estudiante.matricula}</td>
                            <td>${item.estudiante.cuatrimestre}</td>
                            <td>${item.estudiante.grupo}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.casilleroCodigo}">
                                        <strong>${item.casilleroCodigo}</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Sin asignar</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.casilleroCodigo}">
                                        <button class="btn-link text-danger" onclick="abrirModalQuitarCasillero('${item.estudiante.id}', '${item.estudiante.nombre}', '${item.casilleroCodigo}')">
                                            <i class="bi bi-scissors"></i> Quitar casillero
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="display:flex; flex-direction:column; gap:0.2rem;">
                                            <button class="btn-link text-primary" onclick="abrirModalAsignar('${item.estudiante.id}', '${item.estudiante.nombre}', '${item.estudiante.matricula}', '${item.estudiante.carrera}')">
                                                <i class="bi bi-plus-circle"></i> Asignar
                                            </button>
                                            <button class="btn-link text-danger" onclick="abrirModalQuitarLista('${item.estudiante.id}', '${item.estudiante.nombre}')">
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
                        <td colspan="6" style="text-align: center; padding: 2.5rem; color: #64748b;">
                            ✓ Ya no tiene pendientes de pre-aceptados
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>

        <!-- Paginador Integrado en Tabla -->
        <div class="table-pagination">
            <span>Mostrando 5 de ${totalEstudiantes != null ? totalEstudiantes : 0} pre-aceptados</span>
            <div class="pagination-controls">
                <a href="#" class="page-btn"><i class="bi bi-chevron-left"></i></a>
                <a href="#" class="page-btn active">1</a>
                <a href="#" class="page-btn">2</a>
                <a href="#" class="page-btn">3</a>
                <span style="padding: 0 0.2rem;">...</span>
                <a href="#" class="page-btn">29</a>
                <a href="#" class="page-btn"><i class="bi bi-chevron-right"></i></a>
            </div>
        </div>
    </section>

    <!-- Tarjetas de Métricas -->
    <section class="metrics-grid">
        <div class="card card-blue">
            <div class="card-icon-box">
                <i class="bi bi-people-fill"></i>
            </div>
            <div>
                <span class="metric-number">${totalEstudiantes != null ? totalEstudiantes : 0}</span>
                <span class="metric-label">Estudiantes en lista</span>
            </div>
        </div>
        <div class="card card-green">
            <div class="card-icon-box">
                <i class="bi bi-lock-fill"></i>
            </div>
            <div>
                <span class="metric-number">${casillerosDisponibles != null ? casillerosDisponibles : 0}</span>
                <span class="metric-label">Casilleros disponibles</span>
            </div>
        </div>
        <div class="card card-red">
            <div class="card-icon-box">
                <i class="bi bi-exclamation-triangle-fill"></i>
            </div>
            <div>
                <span class="metric-number">${esperaCupo != null ? esperaCupo : 0}</span>
                <span class="metric-label">Estudiantes en espera de cupo</span>
            </div>
        </div>
    </section>
</main>

<!-- MODAL 1: Asignar Casillero -->
<div id="modalAsignar" class="modal">
    <div class="modal-content large">
        <span class="close-btn" onclick="cerrarModal('modalAsignar')">&times;</span>
        <h3>Asignar Casillero</h3>
        <div class="user-info-card">
            <strong id="modalEstudianteNombre"></strong>
            <p><span id="modalEstudianteMatricula"></span> | <span id="modalEstudianteCarrera"></span></p>
        </div>

        <div class="filters-row">
            <input type="text" id="buscarLockerInput" placeholder="Ej. A-042" onkeyup="filtrarLockersModal()">
            <select id="filtroEdificio" onchange="filtrarLockersModal()">
                <option value="">Todos los edificios</option>
                <option value="Edif. A">Edificio A</option>
                <option value="Edif. B">Edificio B</option>
            </select>
            <select id="filtroPiso" onchange="filtrarLockersModal()">
                <option value="">Todos los pisos</option>
                <option value="PB">Planta Baja</option>
                <option value="Piso 1">Piso 1</option>
            </select>
        </div>

        <div class="lockers-grid" id="lockersGrid">
            <!-- Se cargan dinámicamente vía JS -->
        </div>

        <div class="modal-footer" style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #e2e8f0; padding-top: 1rem; margin-top: 1rem;">
            <span>Seleccionado: <strong id="lockerSeleccionadoTexto">Ninguno</strong></span>
            <div style="display: flex; gap: 0.5rem;">
                <button class="btn btn-secondary" onclick="cerrarModal('modalAsignar')">Cancelar</button>
                <button class="btn btn-primary" id="btnConfirmarAsignacion" disabled onclick="confirmarSeleccionLocker()">Confirmar Asignación</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL 2: Alertas / Confirmaciones Genéricas -->
<div id="modalAlerta" class="modal">
    <div class="modal-content centered" style="text-align: center;">
        <div class="modal-icon" id="alertaIcono"></div>
        <h3 id="alertaTitulo"></h3>
        <p id="alertaMensaje"></p>
        <div class="modal-footer-centered" id="alertaBotones" style="display: flex; justify-content: center; gap: 0.75rem; margin-top: 1rem;">
            <!-- Botones dinámicos -->
        </div>
    </div>
</div>

<footer style="margin-top: 3rem; padding: 1.5rem; text-align: center; color: #94a3b8; font-size: 0.8rem; border-top: 1px solid #e2e8f0; background: #ffffff;">
    © 2026 LockerHub Administrative Management System. Universidad Politécnica.
</footer>

<script src="${pageContext.request.contextPath}/js/admin/pre-aceptacion.js"></script>
</body>
</html>