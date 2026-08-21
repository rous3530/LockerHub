<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="mx.edu.utez.locker.model.SolicitudDto" %>
<%@ page import="mx.edu.utez.locker.model.Administrador" %>
<%
    HttpSession sesion = request.getSession(false);
    Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }

    if (request.getAttribute("solicitudes") == null && request.getParameter("redirected") == null) {
        response.sendRedirect(request.getContextPath() + "/views/admin/inicio?redirected=true");
        return;
    }
    // Validar que la sesión exista y que el usuario esté logueado
    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }

    @SuppressWarnings("unchecked")
    List<SolicitudDto> solicitudes = (List<SolicitudDto>) request.getAttribute("solicitudes");
    Integer totalLockers = (Integer) request.getAttribute("totalLockers");
    Integer disponibles = (Integer) request.getAttribute("lockersDisponibles");
    Integer pendientes = (Integer) request.getAttribute("pendientesCount");

    if (totalLockers == null) totalLockers = 0;
    if (disponibles == null) disponibles = 0;
    if (pendientes == null) pendientes = (solicitudes != null) ? solicitudes.size() : 0;

    double porcentajeDisponible = (totalLockers > 0) ? ((double) disponibles / totalLockers) * 100 : 0;
    boolean bajoInventario = porcentajeDisponible <= 10.0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Solicitudes</title>
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
        .badge-cuatri {
            background-color: var(--lh-badge-blue);
            color: var(--lh-badge-text);
            font-weight: 600;
            font-size: 0.75rem;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .btn-preaprobar {
            background-color: var(--lh-green);
            color: white;
            font-weight: 600;
            font-size: 0.8rem;
            border-radius: 6px;
            border: none;
            padding: 6px 14px;
        }
        .btn-preaprobar:hover { background-color: #064e1e; color: white; }

        .btn-rechazar {
            background-color: var(--lh-red);
            color: white;
            font-weight: 600;
            font-size: 0.8rem;
            border-radius: 6px;
            border: none;
            padding: 6px 14px;
        }
        .btn-rechazar:hover { background-color: #6a0000; color: white; }

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

        /* Fuerza la desactivación de backdrops dinámicos duplicados */
        .modal-backdrop {
            display: none !important;
        }

        /* Asegura que el modal de customer.css se encargue del fondo sin acumular z-index */
        .modal.show {
            background-color: rgba(0, 0, 0, 0.5) !important;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<!-- Header / Navigation -->
<nav class="navbar-admin shadow-sm">
    <a class="navbar-brand fw-bold fs-4 m-0 text-white text-decoration-none" href="#">LockerHub</a>

    <div class="nav-links-center">
        <a href="${pageContext.request.contextPath}/views/admin/inicio.jsp" class="nav-link active">SOLICITUDES</a>
        <a href="${pageContext.request.contextPath}/views/admin/pre-aceptacion.jsp" class="nav-link ">PRE-ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/views/admin/aceptados" class="nav-link">ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/views/admin/gestionLocker" class="nav-link">GESTION LOCKER</a>
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
<div class="container-fluid px-4 py-4 flex-grow-1">

    <% if ("success".equals(request.getParameter("status"))) { %>
    <div class="alert alert-success d-flex align-items-center alert-dismissible fade show mb-4" role="alert">
        <i class="bi bi-check-circle-fill fs-5 me-2"></i>
        <div>
            <% if ("preaprobar".equals(request.getParameter("action"))) { %>
            Estudiante pre-aprobado exitosamente.
            <% } else { %>
            La solicitud ha sido rechazada.
            <% } %>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <% if (bajoInventario) { %>
    <div class="alert alert-primary border-0 mb-4" style="background-color: #dbeafe; color: #1e3a8a; border-radius: 8px;">
        <div class="d-flex align-items-center">
            <i class="bi bi-exclamation-triangle-fill fs-5 me-3 text-primary"></i>
            <div>
                <strong>¡Atención!</strong><br>
                <span class="small">El inventario de casilleros disponibles es bajo (<%= String.format("%.1f", porcentajeDisponible) %>%). Por favor, revise las asignaciones.</span>
            </div>
        </div>
    </div>
    <% } %>

    <!-- TARJETAS DE MÉTRICAS -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">TOTAL DE LOCKERS</span>
                    <i class="bi bi-lock text-navy fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1"><%= totalLockers %></h2>
                <p class="text-muted small mb-3">Capacidad total instalada</p>
                <div class="progress" style="height: 6px;">
                    <div class="progress-bar bg-navy" role="progressbar" style="width: 100%;"></div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">DISPONIBLES</span>
                    <i class="bi bi-exclamation-triangle <%= bajoInventario ? "text-danger" : "text-success" %> fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1"><%= disponibles %></h2>
                <p class="text-muted small mb-3">Disponibilidad (<%= String.format("%.1f", porcentajeDisponible) %>%)</p>
                <div class="progress" style="height: 6px;">
                    <div class="progress-bar <%= bajoInventario ? "bg-danger" : "bg-success" %>" role="progressbar" style="width: <%= porcentajeDisponible %>%;"></div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="metric-title text-uppercase">SOLICITUDES PENDIENTES</span>
                    <i class="bi bi-journal-check text-navy fs-5"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy mb-1"><%= pendientes %></h2>
                <p class="text-muted small mb-3">Requieren revisión administrativa</p>
                <div class="progress" style="height: 6px;">
                    <div class="progress-bar bg-navy" role="progressbar" style="width: <%= Math.min(pendientes * 5, 100) %>%;"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- TABLA -->
    <div class="table-container shadow-sm mb-4">
        <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h3 class="h5 fw-bold text-navy mb-1">Listado de Solicitudes</h3>
                <p class="text-muted small mb-0">Gestión de trámites pendientes de asignación</p>
            </div>
            <div class="search-box d-flex align-items-center gap-2">
                <i class="bi bi-search text-muted"></i>
                <input type="text" id="searchInput" placeholder="Buscar estudiante..." onkeyup="filtrarTabla()">
            </div>
        </div>

        <div class="table-header-bg">
            <div class="row m-0">
                <div class="col-3 table-th">ESTUDIANTE</div>
                <div class="col-2 table-th text-center">MATRÍCULA</div>
                <div class="col-3 table-th text-center">CUATRIMESTRE</div>
                <div class="col-2 table-th text-center">GRUPO</div>
                <div class="col-2 table-th text-center">ACCIONES</div>
            </div>
        </div>

        <div id="tableBody">
            <% if (solicitudes != null && !solicitudes.isEmpty()) {
                for (SolicitudDto sol : solicitudes) { %>
            <div class="row m-0 table-row align-items-center item-row" id="row-<%= sol.getMatricula() %>">
                <div class="col-3 d-flex align-items-center gap-3">
                    <div class="avatar-initials"><%= sol.getIniciales() %></div>
                    <div>
                        <div class="fw-bold text-dark small student-name"><%= sol.getNombreCompleto() %></div>
                        <div class="text-muted" style="font-size: 0.75rem;"><%= sol.getCarrera() %></div>
                    </div>
                </div>
                <div class="col-2 text-center text-secondary small font-monospace student-matricula"><%= sol.getMatricula() %></div>
                <div class="col-3 text-center">
                    <span class="badge badge-cuatri"><%= sol.getCuatrimestre() %></span>
                </div>
                <div class="col-2 text-center text-secondary small fw-semibold"><%= sol.getGrupo() %></div>
                <div class="col-2 text-center d-flex justify-content-center gap-2">
                    <button class="btn btn-preaprobar d-flex align-items-center gap-1" onclick="ejecutarAccion('<%= sol.getMatricula() %>', 'preaprobar')">
                        <i class="bi bi-check-circle"></i> Pre-aprobar
                    </button>
                    <button class="btn btn-rechazar d-flex align-items-center gap-1" onclick="abrirModalRechazo('<%= sol.getMatricula() %>', '<%= sol.getNombreCompleto() %>')">
                        <i class="bi bi-x-circle"></i> Rechazar
                    </button>
                </div>
            </div>
            <%   }
            } %>
        </div>

        <div id="emptyState" class="text-center py-5 <%= (solicitudes != null && !solicitudes.isEmpty()) ? "d-none" : "" %>">
            <div class="mb-2">
                <i class="bi bi-check-circle text-secondary fs-2"></i>
            </div>
            <p class="mb-0 text-secondary fw-semibold small">Ya no tiene pendientes de pre-aceptados</p>
        </div>

    </div>

</div>

<!-- FORMULARIO OCULTO POST -->
<form id="actionForm" action="${pageContext.request.contextPath}/views/admin/inicio" method="POST" class="d-none">
    <input type="hidden" name="accion" id="formAccion">
    <input type="hidden" name="matricula" id="formMatricula">
</form>

<!-- MODAL DE CONFIRMACIÓN -->
<div class="modal fade" id="modalRechazar" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px;">
            <div class="modal-body text-center p-4">
                <h4 class="fw-bold text-navy mb-3 px-2" id="modalRechazarTitle">
                    ¿Estás seguro de RECHAZAR esta solicitud?
                </h4>
                <p class="text-muted small mb-4">
                    Al rechazar esta solicitud ya no se visualizará en el listado de solicitudes pendientes.
                </p>
                <div class="d-flex justify-content-center gap-3">
                    <button type="button" class="btn btn-navy px-4 py-2 text-white fw-semibold" style="background-color: var(--lh-navy); border-radius: 8px;" data-bs-dismiss="modal">
                        REGRESAR
                    </button>
                    <button type="button" class="btn btn-danger px-4 py-2 fw-semibold" style="background-color: var(--lh-red); border-radius: 8px;" id="btnConfirmarRechazo">
                        RECHAZAR
                    </button>
                </div>
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
    let matriculaSeleccionada = null;
    let modalRechazarInstance = null;

    document.addEventListener('DOMContentLoaded', function () {
        const modalElement = document.getElementById('modalRechazar');
        if (modalElement) {
            // backdrop: false evita que Bootstrap inserte su propia capa .modal-backdrop extra
            modalRechazarInstance = new bootstrap.Modal(modalElement, {
                backdrop: false,
                keyboard: true
            });
        }
    });

    function ejecutarAccion(matricula, accion) {
        document.getElementById('formMatricula').value = matricula;
        document.getElementById('formAccion').value = accion;
        document.getElementById('actionForm').submit();
    }

    function abrirModalRechazo(matricula, nombre) {
        matriculaSeleccionada = matricula;
        document.getElementById('modalRechazarTitle').innerText = '¿Estás seguro de RECHAZAR a ' + nombre + '?';

        if (modalRechazarInstance) {
            modalRechazarInstance.show();
        }
    }

    document.getElementById('btnConfirmarRechazo').addEventListener('click', function() {
        if (matriculaSeleccionada) {
            ejecutarAccion(matriculaSeleccionada, 'rechazar');
        }
    });

    function filtrarTabla() {
        const input = document.getElementById('searchInput').value.toLowerCase();
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
</script>
</body>
</html>