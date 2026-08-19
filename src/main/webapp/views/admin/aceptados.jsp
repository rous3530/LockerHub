<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="mx.edu.utez.locker.model.Administrador" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    HttpSession sesion = request.getSession(false);
    Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
        return;
    }

    // Variables recibidas por atributos desde el Servlet
    Integer totalAceptados = (Integer) request.getAttribute("totalAceptados");
    String porcentajeUso = (String) request.getAttribute("porcentajeUso");

    if (totalAceptados == null) totalAceptados = 0;
    if (porcentajeUso == null) porcentajeUso = "0%";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Estudiantes Aceptados</title>
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
            --lh-badge-blue: #e0e7ff;
            --lh-badge-text: #3730a3;
        }

        body {
            background-color: var(--lh-bg-light);
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
        }

        .bg-navy { background-color: var(--lh-navy) !important; }
        .nav-link-custom {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.03em;
            padding-bottom: 4px;
        }
        .nav-link-custom:hover { color: #fff; }
        .nav-link-custom.active {
            color: #fff;
            border-bottom: 2px solid #fff;
        }

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

        .table-container {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background-color: #ffffff;
            overflow: hidden;
        }
        .table-header-bg {
            background-color: var(--lh-table-header);
            border-bottom: 1px solid #e2e8f0;
        }
        .table-th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #475569;
            font-weight: 700;
            padding: 14px 20px;
        }
        .table-row {
            border-bottom: 1px solid #f1f5f9;
            padding: 14px 20px;
            align-items: center;
        }

        .avatar-initials {
            width: 36px;
            height: 36px;
            background-color: #dbeafe;
            color: #1e40af;
            font-weight: 700;
            font-size: 0.85rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .search-box {
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 6px 12px;
            max-width: 300px;
            background-color: #fff;
        }
        .search-box input {
            border: none;
            outline: none;
            font-size: 0.875rem;
            width: 100%;
        }

        .modal-backdrop { display: none !important; }
        .modal.show { background-color: rgba(0, 0, 0, 0.5) !important; }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<!-- Header / Navigation -->
<nav class="navbar-admin shadow-sm">
    <a class="navbar-brand fw-bold fs-4 m-0 text-white text-decoration-none" href="#">LockerHub</a>

    <div class="nav-links-center">
        <a href="${pageContext.request.contextPath}/views/admin/inicio.jsp" class="nav-link">SOLICITUDES</a>
        <a href="${pageContext.request.contextPath}/views/admin/pre-aceptacion.jsp" class="nav-link">PRE-ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/views/admin/aceptados" class="nav-link active">ACEPTADOS</a>
    </div>

    <div class="nav-actions-right d-flex align-items-center gap-3 text-white">
        <i class="bi bi-bell" style="cursor: pointer;"></i>
        <i class="bi bi-gear" style="cursor: pointer;"></i>
        <i class="bi bi-question-circle" style="cursor: pointer;"></i>
        <div class="user-avatar-nav d-flex align-items-center">
            <img src="https://ui-avatars.com/api/?name=Admin+User&background=3b82f6&color=fff" alt="Perfil" style="width: 32px; height: 32px; border-radius: 50%;">
        </div>
    </div>
</nav>

<!-- Main Container -->
<div class="container-fluid px-4 py-4 flex-grow-1">

    <!-- Encabezado de Sección -->
    <div class="mb-4">
        <h2 class="h4 fw-bold text-navy mb-1">Estudiantes Aceptados</h2>
        <p class="text-muted small mb-0">Gestión de usuarios con lockers asignados.</p>
    </div>

    <!-- TARJETAS DE MÉTRICAS -->
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">TOTAL ACEPTADOS</span>
                    <i class="bi bi-people text-navy fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1"><%= totalAceptados %></h2>
                <p class="text-muted small mb-3"><span class="text-success"><i class="bi bi-arrow-up-right"></i> Actualizado</span></p>
                <div class="progress" style="height: 6px;">
                    <div class="progress-bar bg-navy" role="progressbar" style="width: 100%;"></div>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">LOCKERS EN USO</span>
                    <i class="bi bi-door-closed-fill text-success fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1"><%= porcentajeUso %></h2>
                <p class="text-muted small mb-3">Capacidad ocupada actual</p>
                <div class="progress" style="height: 6px;">
                    <div class="progress-bar bg-success" role="progressbar" style="width: <%= porcentajeUso.replace("%", "") %>%;"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- TABLA -->
    <div class="table-container shadow-sm mb-4">
        <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h3 class="h5 fw-bold text-navy mb-1">Directorio de Estudiantes</h3>
                <p class="text-muted small mb-0">Listado general con casillero activo</p>
            </div>
            <div class="search-box d-flex align-items-center gap-2">
                <i class="bi bi-search text-muted"></i>
                <input type="text" id="searchInput" placeholder="Buscar por matrícula o nombre..." onkeyup="filtrarTablaAceptados()">
            </div>
        </div>

        <div class="table-header-bg">
            <div class="row m-0">
                <div class="col-3 table-th">ESTUDIANTE</div>
                <div class="col-2 table-th text-center">MATRÍCULA</div>
                <div class="col-2 table-th text-center">CUATRIMESTRE</div>
                <div class="col-2 table-th text-center">GRUPO</div>
                <div class="col-1 table-th text-center">STATUS</div>
                <div class="col-2 table-th text-center">ACCIONES</div>
            </div>
        </div>

        <div id="tableBody">
            <c:choose>
                <c:when test="${not empty listaAceptados}">
                    <c:forEach var="item" items="${listaAceptados}">
                        <div class="row m-0 table-row align-items-center item-row">
                            <div class="col-3 d-flex align-items-center gap-3">
                                <div class="avatar-initials">${item.iniciales}</div>
                                <div>
                                    <div class="fw-bold text-dark small student-name">${item.nombreCompleto}</div>
                                    <div class="text-muted" style="font-size: 0.75rem;">${item.email}</div>
                                </div>
                            </div>
                            <div class="col-2 text-center text-secondary small font-monospace student-matricula">${item.matricula}</div>
                            <div class="col-2 text-center text-secondary small">${item.cuatrimestre}</div>
                            <div class="col-2 text-center text-secondary small fw-semibold">${item.grupo}</div>
                            <div class="col-1 text-center">
                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill" style="font-size: 0.7rem;">
                                    ● Aceptado
                                </span>
                            </div>
                            <div class="col-2 text-center">
                                <button type="button" class="btn btn-link text-primary text-decoration-none p-0 small fw-bold" onclick="abrirModalReporte('${item.idSolicitud}', '${item.nombreCompleto}')">
                                    <i class="bi bi-file-earmark-text"></i> Reporte
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <p class="mb-0 text-secondary fw-semibold small">No hay estudiantes aceptados registrados actualmente.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="emptyState" class="text-center py-5 d-none">
            <p class="mb-0 text-secondary fw-semibold small">No se encontraron registros coincidentes</p>
        </div>

    </div>

</div>

<!-- MODAL: Generar Reporte Adjunto -->
<div class="modal fade" id="modalReporte" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg p-3" style="border-radius: 16px;">
            <div class="modal-body">
                <h3 class="text-navy fw-bold h5 mb-1">Reporte</h3>
                <p class="text-secondary small mb-3">
                    Aquí se generará el reporte que se le adjuntará al estudiante <strong id="modalEstudianteNombre">Estudiante</strong>
                </p>

                <form id="formReporte" onsubmit="adjuntarReporte(event)">
                    <input type="hidden" id="modalEstudianteId" name="estudianteId">

                    <div class="mb-3 text-start">
                        <label for="textoReporte" class="form-label text-secondary fw-semibold small">Escribir Reporte</label>
                        <textarea id="textoReporte" name="reporte" rows="4" class="form-control" placeholder="Ej. No cumple con los requisitos" required></textarea>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <button type="button" class="btn btn-secondary text-white px-3 py-2 fw-semibold" style="border-radius: 8px;" onclick="cerrarModalReporte()">REGRESAR</button>
                        <button type="submit" class="btn btn-success px-3 py-2 fw-semibold" style="background-color: var(--lh-green); border-radius: 8px;">ADJUNTAR</button>
                    </div>
                </form>
            </div>
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

<script>
    let estudianteSeleccionado = { id: null, nombre: '' };
    let modalReporteInstance = null;

    document.addEventListener('DOMContentLoaded', function () {
        const modalElement = document.getElementById('modalReporte');
        if (modalElement) {
            modalReporteInstance = new bootstrap.Modal(modalElement, {
                backdrop: false,
                keyboard: true
            });
        }
    });

    function filtrarTablaAceptados() {
        const input = document.getElementById('searchInput').value.toLowerCase().trim();
        const rows = document.querySelectorAll('.item-row');
        let visibles = 0;

        rows.forEach(row => {
            const nombre = row.querySelector('.student-name').innerText.toLowerCase();
            const matricula = row.querySelector('.student-matricula').innerText.toLowerCase();

            if (nombre.includes(input) || matricula.includes(input)) {
                row.style.display = 'flex';
                visibles++;
            } else {
                row.style.display = 'none';
            }
        });

        const emptyState = document.getElementById('emptyState');
        if (visibles === 0) {
            emptyState.classList.remove('d-none');
        } else {
            emptyState.classList.add('d-none');
        }
    }

    function abrirModalReporte(idEstudiante, nombreEstudiante) {
        estudianteSeleccionado.id = idEstudiante;
        estudianteSeleccionado.nombre = nombreEstudiante;

        document.getElementById('modalEstudianteId').value = idEstudiante;
        document.getElementById('modalEstudianteNombre').innerText = nombreEstudiante;
        document.getElementById('textoReporte').value = '';

        if (modalReporteInstance) {
            modalReporteInstance.show();
        }
    }

    function cerrarModalReporte() {
        if (modalReporteInstance) {
            modalReporteInstance.hide();
        }
    }

    function adjuntarReporte(event) {
        event.preventDefault();

        const id = document.getElementById('modalEstudianteId').value;
        const reporteTexto = document.getElementById('textoReporte').value.trim();

        if (!reporteTexto) {
            alert('Por favor, escribe un motivo o detalle para el reporte.');
            return;
        }

        cerrarModalReporte();
        alert(`Reporte adjuntado con éxito a ${estudianteSeleccionado.nombre}.`);
    }
</script>
</body>
</html>