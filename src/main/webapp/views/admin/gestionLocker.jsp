<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="mx.edu.utez.locker.model.Administrador" %>
<%
    HttpSession sesion = request.getSession(false);
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
        }

        body {
            background-color: var(--lh-bg-light);
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
        }

        .bg-navy { background-color: var(--lh-navy) !important; }
        .text-navy { color: var(--lh-navy) !important; }

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
        <a href="${pageContext.request.contextPath}/admin/gestionLocker" class="nav-link active">GESTION LOCKER</a>
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

    <header class="mb-4">
        <h2 class="h4 fw-bold text-navy mb-1">Gestión de Casilleros</h2>
        <p class="text-muted small mb-0">Visualice y gestione la disponibilidad de casilleros por edificio y nivel dentro de la red LockerHub.</p>
    </header>

    <!-- Tarjetas de Métricas -->
    <section class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">TOTAL DE CASILLEROS</span>
                    <i class="bi bi-lock text-navy fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1">${totalCasilleros}</h2>
                <p class="text-muted small mb-0">Capacidad instalada</p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">OCUPADOS</span>
                    <i class="bi bi-lock-fill text-danger fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1">${ocupados}</h2>
                <div class="progress mt-2" style="height: 6px;">
                    <div class="progress-bar bg-danger" role="progressbar" style="width: ${totalCasilleros > 0 ? (ocupados * 100 / totalCasilleros) : 0}%;"></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">DISPONIBLES</span>
                    <i class="bi bi-check-circle text-success fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1">${disponibles}</h2>
                <p class="text-success small mb-0 fw-semibold">
                    ${porcentajeLibre}% Libre
                </p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">EN MANTENIMIENTO</span>
                    <i class="bi bi-tools text-primary fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1">${mantenimiento}</h2>
                <p class="text-muted small mb-0">Revisión técnica</p>
            </div>
        </div>
    </section>

    <!-- Barra de Filtros y Buscador -->
    <section class="filter-bar-container mb-4">
        <div class="search-box-custom">
            <i class="bi bi-search text-muted"></i>
            <input type="text" id="inputBuscarCasillero" placeholder="Buscar casillero..." onkeyup="aplicarFiltros()">
        </div>

        <div class="filter-controls-custom">
            <select id="selectEstado" class="form-select form-select-sm" style="width: 150px;" onchange="aplicarFiltros()">
                <option value="">Estado (Todos)</option>
                <option value="DISPONIBLE">Disponible</option>
                <option value="OCUPADO">Ocupado</option>
                <option value="MANTENIMIENTO">Mantenimiento</option>
            </select>

            <select id="selectEdificio" class="form-select form-select-sm" style="width: 160px;" onchange="aplicarFiltros()">
                <option value="">Edificio (Todos)</option>
                <c:forEach var="ed" items="${listaEdificios}">
                    <option value="${ed.nombre}">${ed.nombre}</option>
                </c:forEach>
            </select>

            <select id="selectPiso" class="form-select form-select-sm" style="width: 140px;" onchange="aplicarFiltros()">
                <option value="">Piso (Todos)</option>
                <option value="Planta Baja">Planta Baja</option>
                <option value="Planta Alta">Planta Alta</option>
            </select>
        </div>
    </section>

    <!-- Grid de Tarjetas de Casilleros -->
    <section id="gridCasilleros" class="mb-4">
        <c:choose>
            <c:when test="${not empty listaCasilleros}">
                <div class="row row-cols-1 row-cols-md-3 row-cols-lg-5 g-3">
                    <c:forEach var="casillero" items="${listaCasilleros}">
                        <div class="col card-locker-wrapper"
                             data-codigo="${casillero.codigo}"
                             data-edificio="${casillero.edificio}"
                             data-piso="${casillero.piso}"
                             data-estado="${casillero.estado}"
                             data-alumno="${casillero.nombreAlumno}"
                             data-matricula="${casillero.matriculaAlumno}">
                            <div class="card h-100 shadow-sm border-0 p-3" style="border-radius: 12px; border: 1px solid #e2e8f0 !important;">
                                <div class="card-body p-1 d-flex flex-column justify-content-between">

                                    <div>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <h5 class="fw-bold text-navy m-0" style="font-size: 1.05rem;">${casillero.codigo}</h5>
                                            <c:choose>
                                                <c:when test="${casillero.estado == 'DISPONIBLE'}">
                                                    <span class="badge bg-success bg-opacity-10 text-success fw-semibold" style="font-size: 0.65rem;">● DISPONIBLE</span>
                                                </c:when>
                                                <c:when test="${casillero.estado == 'OCUPADO'}">
                                                    <span class="badge bg-danger bg-opacity-10 text-danger fw-semibold" style="font-size: 0.65rem;">🔒 OCUPADO</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-primary bg-opacity-10 text-primary fw-semibold" style="font-size: 0.65rem;">🔧 MANTENIMIENTO</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="text-secondary small mb-3" style="font-size: 0.8rem;">
                                            <div class="d-flex align-items-center gap-2 mb-1">
                                                <i class="bi bi-building"></i> <span>${casillero.edificio}</span>
                                            </div>
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="bi bi-layers"></i> <span>${casillero.piso}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div>
                                        <!-- CORRECTO: Solo llama a tu función de JavaScript -->
                                        <button type="button" class="btn btn-outline-primary btn-sm w-100 fw-semibold py-1"
                                                onclick="abrirModalGestion('${casillero.codigo}', '${casillero.edificio}', '${casillero.piso}', '${casillero.estado}', '${casillero.nombreAlumno}', '${casillero.matriculaAlumno}')">
                                            Gestionar
                                        </button>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 w-100 text-muted bg-white rounded-3 border">
                    <p class="fw-semibold small mb-0">No hay casilleros registrados o disponibles con los criterios seleccionados.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

</main>

<!-- Modal Único de Gestión Interactivo -->
<div class="modal fade" id="modalGestionCasillero" tabindex="-1" aria-labelledby="modalGestionLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow" style="border-radius: 14px;">

            <form id="formGestionCasillero" action="${pageContext.request.contextPath}/admin/gestionLocker" method="POST">
                <div class="modal-header bg-navy text-white" style="border-top-left-radius: 14px; border-top-right-radius: 14px;">
                    <h5 class="modal-title fw-bold fs-6" id="modalGestionLabel">Gestión del Casillero: <span id="modalCodigoCasillero">---</span></h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <!-- Campo oculto para enviar el código del casillero -->
                    <input type="hidden" name="codigoCasillero" id="inputCodigoCasillero">

                    <!-- Información de Ubicación -->
                    <div class="mb-3 p-3 bg-light rounded-3 border">
                        <p class="mb-1 small text-muted"><strong>Edificio:</strong> <span id="modalEdificio">---</span></p>
                        <p class="mb-0 small text-muted"><strong>Piso:</strong> <span id="modalPiso">---</span></p>
                    </div>

                    <!-- Sección de Alumno Asignado (Detalle extendido que se muestra si está ocupado) -->
                    <div id="seccionAlumno" class="mb-4 p-3 rounded-3 border border-danger bg-danger bg-opacity-10 d-none">
                        <h6 class="text-danger fw-bold small mb-2"><i class="bi bi-person-fill"></i> Alumno Asignado</h6>
                        <p class="mb-1 small text-dark"><strong>Nombre:</strong> <span id="modalNombreAlumno">---</span></p>
                        <p class="mb-0 small text-dark"><strong>Matrícula:</strong> <span id="modalMatriculaAlumno">---</span></p>
                    </div>

                    <!-- Selector para cambiar el estado del casillero -->
                    <div class="mb-3">
                        <label for="selectNuevoEstado" class="form-label fw-bold text-navy small">Cambiar Estado del Casillero</label>
                        <select class="form-select form-select-sm" name="nuevoEstado" id="selectNuevoEstado" required>
                            <option value="DISPONIBLE">Disponible</option>
                            <option value="OCUPADO">Ocupado</option>
                            <option value="MANTENIMIENTO">Mantenimiento</option>
                        </select>
                    </div>
                </div>

                <!-- FOOTER DEL MODAL ACTUALIZADO CON EL BOTÓN DE LIBERAR CASILLERO -->
                <div class="modal-footer bg-light px-4 py-3 d-flex justify-content-between" style="border-bottom-left-radius: 14px; border-bottom-right-radius: 14px;">
                    <button type="button" class="btn btn-outline-danger btn-sm px-3" onclick="liberarCasilleroAlumno()">
                        <i class="bi bi-unlock"></i> Liberar Casillero
                    </button>

                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-secondary btn-sm px-3" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary btn-sm px-4 fw-semibold bg-navy">Guardar Cambios</button>
                    </div>
                </div>
            </form>

        </div>
    </div>
</div>

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
<script>
    function abrirModalGestion(codigo, edificio, piso, estado, nombreAlumno, matriculaAlumno) {
        console.log("--- ABRIENDO MODAL ---");
        console.log("Código:", codigo);
        console.log("Estado:", estado);
        console.log("Nombre Alumno:", nombreAlumno);
        console.log("Matrícula Alumno:", matriculaAlumno);

        // 1. Asignar textos básicos
        document.getElementById("modalCodigoCasillero").innerText = codigo;
        document.getElementById("inputCodigoCasillero").value = codigo;
        document.getElementById("modalEdificio").innerText = edificio;
        document.getElementById("modalPiso").innerText = piso;

        // 2. Gestionar la sección del alumno asignado
        const seccionAlumno = document.getElementById("seccionAlumno");

        if (estado && estado.toUpperCase() === "OCUPADO" && nombreAlumno && nombreAlumno !== "null" && nombreAlumno !== "Sin asignar" && nombreAlumno.trim() !== "") {
            document.getElementById("modalNombreAlumno").innerText = nombreAlumno;
            document.getElementById("modalMatriculaAlumno").innerText = matriculaAlumno;
            seccionAlumno.classList.remove("d-none"); // Muestra el cuadro
        } else {
            seccionAlumno.classList.add("d-none");    // Oculta el cuadro
        }

        document.getElementById("selectNuevoEstado").value = estado;

        // 3. Abrir el modal limpiando cualquier backdrop duplicado
        document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
        var modalElement = document.getElementById('modalGestionCasillero');
        var myModal = bootstrap.Modal.getOrCreateInstance(modalElement);
        myModal.show();
    }

    // Limpieza automática al cerrar
    document.addEventListener('DOMContentLoaded', function () {
        const modalEl = document.getElementById('modalGestionCasillero');
        if (modalEl) {
            modalEl.addEventListener('hidden.bs.modal', function () {
                document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
                document.body.classList.remove('modal-open');
                document.body.style.removeProperty('overflow');
                document.body.style.removeProperty('padding-right');
            });
        }
    });
</script>
</body>
</html>