<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Historial de Solicitudes</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerAlumno.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
        }

        .text-navy-brand {
            color: #1a365d !important;
        }

        .nav-link-custom {
            font-weight: 500;
            color: #64748b;
            padding: 0.5rem 1rem;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .nav-link-custom:hover {
            color: #1a365d;
        }

        .nav-link-custom.active {
            color: #1a365d;
            border-bottom: 2px solid #1a365d;
            font-weight: 600;
        }

        /* Botón azul principal */
        .btn-navy-primary {
            background-color: #1a365d;
            color: #ffffff;
            font-weight: 600;
            border-radius: 8px;
            padding: 0.65rem 1.25rem;
            border: none;
            transition: background-color 0.2s;
        }

        .btn-navy-primary:hover {
            background-color: #112542;
            color: #ffffff;
        }

        /* Barra de búsqueda y Filtros */
        .filter-card {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
        }

        .search-input-group {
            background-color: #f1f5f9;
            border-radius: 8px;
            padding: 0.2rem 0.75rem;
            border: 1px solid transparent;
        }

        .search-input-group:focus-within {
            border-color: #cbd5e1;
            background-color: #ffffff;
        }

        .search-input-group input {
            background: transparent;
            border: none;
            outline: none;
            color: #334155;
            font-size: 0.9rem;
            width: 100%;
        }

        .select-filter {
            background-color: #f1f5f9;
            border: 1px solid transparent;
            border-radius: 8px;
            font-size: 0.88rem;
            font-weight: 500;
            color: #334155;
            padding: 0.5rem 1rem;
            cursor: pointer;
        }

        /* Card Periodo Actual */
        .current-period-card {
            background-color: #1a365d;
            border-radius: 12px;
            color: #ffffff;
            padding: 0.85rem 1.25rem;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Tabla de Solicitudes */
        .card-table-wrapper {
            background-color: #ffffff;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        .table-custom-requests {
            width: 100%;
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }

        .table-custom-requests thead th {
            background-color: #eef2ff;
            color: #475569;
            font-size: 0.8rem;
            font-weight: 600;
            padding: 0.85rem 1.25rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .table-custom-requests tbody td {
            padding: 1.1rem 1.25rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            font-size: 0.9rem;
        }

        .folio-link {
            color: #1a365d;
            font-weight: 700;
            text-decoration: none;
        }

        /* Badges de Estado */
        .badge-status-pill {
            border-radius: 50px;
            padding: 0.35rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .badge-assigned {
            background-color: #dcfce7;
            color: #15803d;
        }

        .badge-pending {
            background-color: #fef3c7;
            color: #b45309;
        }

        .badge-expired {
            background-color: #fee2e2;
            color: #b91c1c;
        }

        .badge-rejected {
            background-color: #ffedd5;
            color: #c2410c;
        }

        /* Botones de acción dentro de la tabla */
        .btn-table-action {
            color: #64748b;
            text-decoration: none;
            font-size: 1.1rem;
            transition: color 0.2s;
        }

        .btn-table-action:hover {
            color: #1a365d;
        }

        /* Footer de Paginación */
        .table-pagination-footer {
            background-color: #eef2ff;
            padding: 0.75rem 1.25rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .pagination-custom .page-item-custom {
            width: 28px;
            height: 28px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            text-decoration: none;
            color: #475569;
            margin: 0 2px;
        }

        .pagination-custom .page-item-custom.active {
            background-color: #1a365d;
            color: #ffffff;
        }

        .pagination-custom .page-item-custom:hover:not(.active) {
            background-color: #cbd5e1;
        }

        /* Banner de Ayuda Inferior */
        .card-help-banner {
            background-color: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
        }

        .icon-help-box {
            width: 42px;
            height: 42px;
            background-color: #dbeafe;
            color: #1d4ed8;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .text-micro {
            font-size: 0.75rem;
        }
    </style>
</head>
<body class="bg-page">

<!-- Navbar simétrica de 3 columnas -->
<nav class="navbar navbar-expand-lg bg-white border-bottom py-2 mb-4">
    <div class="container-fluid px-4">
        <div class="row w-100 align-items-center m-0">

            <!-- Columna Izquierda: Logo -->
            <div class="col-4 d-flex justify-content-start p-0">
                <a class="navbar-brand d-flex align-items-center fw-bold text-navy-brand m-0" href="#">
                     LockerHub
                </a>
            </div>

            <!-- Columna Central: Enlaces de Navegación -->
            <div class="col-4 d-flex justify-content-center p-0">
                <div class="d-none d-lg-flex gap-2">
                    <a href="${pageContext.request.contextPath}/views/alumno/inicio.jsp" class="nav-link-custom">Inicio</a>
                    <a href="${pageContext.request.contextPath}/views/alumno/HistorialSolicitud.jsp" class="nav-link-custom active">Solicitudes</a>
                </div>
            </div>

            <!-- Columna Derecha: Notificación, Configuración y Perfil -->
            <div class="col-4 d-flex justify-content-end align-items-center gap-3 p-0">
                <button class="btn btn-link text-muted p-1"><i class="bi bi-bell fs-5"></i></button>
                <a href="${pageContext.request.contextPath}/views/alumno/solicitarLocker.jsp" class="btn btn-link text-muted p-1">
                    <i class="bi bi-gear fs-5"></i>
                </a>
                <button class="btn btn-link text-muted p-1 border-end pe-3" onclick="location.href='${pageContext.request.contextPath}/logout'"><i class="bi bi-box-arrow-right fs-5"></i></button>
                <div class="d-flex align-items-center gap-2 ps-2">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100" class="rounded-circle border" width="36" height="36" alt="Avatar">
                </div>
            </div>

        </div>
    </div>
</nav>

<div class="content-wrapper">
    <div class="container-fluid px-4" style="max-width: 1200px;">

        <!-- Enlace Volver al Dashboard -->
        <div class="mb-2">
            <a href="${pageContext.request.contextPath}/alumno/dashboard.jsp" class="text-decoration-none text-muted small fw-medium d-inline-flex align-items-center gap-1">
                <i class="bi bi-arrow-left"></i> Volver al Dashboard
            </a>
        </div>

        <!-- Header de la vista con Botón "Nueva Solicitud" -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h1 class="fw-bold text-navy-brand m-0" style="font-size: 2.2rem; letter-spacing: -0.5px;">Historial de Solicitudes</h1>
                <p class="text-muted mb-0 small">Consulta el estado y los detalles de todas tus solicitudes de casilleros.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/views/alumno/solicitarLocker.jsp" class="btn btn-navy-primary d-inline-flex align-items-center gap-2">
                    <i class="bi bi-plus-lg"></i> Nueva Solicitud
                </a>
            </div>
        </div>

        <!-- Fila Filtros y Card Periodo Actual -->
        <div class="row g-3 mb-4 align-items-center">

            <!-- Buscador y Filtros -->
            <div class="col-lg-8">
                <div class="filter-card d-flex flex-column flex-sm-row align-items-center justify-content-between gap-3">
                    <div class="search-input-group d-flex align-items-center w-100 me-2">
                        <i class="bi bi-search text-muted me-2"></i>
                        <input type="text" placeholder="Buscar por Folio o Casillero...">
                    </div>
                    <div class="d-flex align-items-center gap-2 flex-shrink-0 w-100 w-sm-auto">
                        <span class="text-muted small fw-medium">Filtrar por:</span>
                        <select class="select-filter form-select-sm">
                            <option selected>Todos los Estados</option>
                            <option value="ASIGNADO">Asignado</option>
                            <option value="PENDIENTE">Pendiente</option>
                            <option value="EXPIRADO">Expirado</option>
                            <option value="RECHAZADO">Rechazado</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Widget Periodo Actual -->
            <div class="col-lg-4">
                <div class="current-period-card">
                    <div>
                        <span class="text-white-50 d-block text-micro fw-medium mb-1">Periodo Actual</span>
                        <h5 class="fw-bold m-0" style="font-size: 1.1rem;">Enero – Junio 2024</h5>
                    </div>
                    <i class="bi bi-calendar3 fs-2 opacity-50"></i>
                </div>
            </div>
        </div>

        <!-- Tabla Principal de Solicitudes -->
        <div class="card-table-wrapper mb-4 shadow-sm">
            <div class="table-responsive">
                <table class="table table-custom-requests align-middle">
                    <thead>
                    <tr>
                        <th>Folio</th>
                        <th>Fecha de Solicitud</th>
                        <th>Referencia Casillero</th>
                        <th>Periodo</th>
                        <th>Estado</th>
                        <th class="text-end">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- Registro 1: Asignado -->
                    <tr>
                        <td><a href="#" class="folio-link">#LH-82910</a></td>
                        <td class="text-muted">15 Feb, 2024</td>
                        <td>
                            <div class="fw-bold text-navy-brand">Edificio C - Piso 2</div>
                            <div class="text-muted text-micro">Locker #245</div>
                        </td>
                        <td class="fw-medium text-dark">ENE-JUN 2024</td>
                        <td>
                                <span class="badge-status-pill badge-assigned">
                                    <i class="bi bi-check-circle-fill"></i> Asignado
                                </span>
                        </td>
                        <td class="text-end">
                            <a href="#" class="btn-table-action" title="Ver Detalles"><i class="bi bi-eye"></i></a>
                        </td>
                    </tr>

                    <!-- Registro 2: Pendiente -->
                    <tr>
                        <td><a href="#" class="folio-link">#LH-79012</a></td>
                        <td class="text-muted">10 Feb, 2024</td>
                        <td>
                            <div class="fw-bold text-navy-brand">Edificio A - Planta Baja</div>
                            <div class="text-muted text-micro">Locker #012</div>
                        </td>
                        <td class="fw-medium text-dark">ENE-JUN 2024</td>
                        <td>
                                <span class="badge-status-pill badge-pending">
                                    <i class="bi bi-clock-fill"></i> Pendiente
                                </span>
                        </td>
                        <td class="text-end">
                            <a href="#" class="btn-table-action" title="Editar Solicitud"><i class="bi bi-pencil"></i></a>
                        </td>
                    </tr>

                    <!-- Registro 3: Expirado -->
                    <tr>
                        <td><a href="#" class="folio-link">#LH-55234</a></td>
                        <td class="text-muted">20 Ago, 2023</td>
                        <td>
                            <div class="fw-bold text-navy-brand">Biblioteca Central</div>
                            <div class="text-muted text-micro">Locker #B-44</div>
                        </td>
                        <td class="fw-medium text-dark">AGO-DIC 2023</td>
                        <td>
                                <span class="badge-status-pill badge-expired">
                                    <i class="bi bi-arrow-counterclockwise"></i> Expirado
                                </span>
                        </td>
                        <td class="text-end">
                            <a href="#" class="btn-table-action" title="Ver Comprobante"><i class="bi bi-file-earmark-text"></i></a>
                        </td>
                    </tr>

                    <!-- Registro 4: Rechazado -->
                    <tr>
                        <td><a href="#" class="folio-link">#LH-54110</a></td>
                        <td class="text-muted">15 Ago, 2023</td>
                        <td>
                            <div class="fw-bold text-navy-brand">Edificio E - Gimnasio</div>
                            <div class="text-muted text-micro">Locker #G-12</div>
                        </td>
                        <td class="fw-medium text-dark">AGO-DIC 2023</td>
                        <td>
                                <span class="badge-status-pill badge-rejected">
                                    <i class="bi bi-x-circle-fill"></i> Rechazado
                                </span>
                        </td>
                        <td class="text-end">
                            <a href="#" class="btn-table-action" title="Motivo de Rechazo"><i class="bi bi-info-circle"></i></a>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <!-- Footer Paginación -->
            <div class="table-pagination-footer">
                <span class="text-muted small">Mostrando 4 de 12 solicitudes</span>
                <div class="pagination-custom d-flex align-items-center">
                    <a href="#" class="page-item-custom"><i class="bi bi-chevron-left"></i></a>
                    <a href="#" class="page-item-custom active">1</a>
                    <a href="#" class="page-item-custom">2</a>
                    <a href="#" class="page-item-custom">3</a>
                    <a href="#" class="page-item-custom"><i class="bi bi-chevron-right"></i></a>
                </div>
            </div>
        </div>

        <!-- Banner Informativo Inferior con activador de Modal -->
        <div class="card-help-banner d-flex align-items-start gap-3 mb-5">
            <div class="icon-help-box">
                <i class="bi bi-question-lg"></i>
            </div>
            <div>
                <h5 class="fw-bold text-navy-brand mb-1 fs-6">¿Tienes dudas con tu estado?</h5>
                <p class="text-muted small mb-2">Consulta nuestra guía de asignación para entender los criterios de aprobación y rechazo.</p>

                <!-- Enlace que abre el Modal -->
                <a href="#" class="fw-bold text-navy-brand text-decoration-none small" data-bs-toggle="modal" data-bs-target="#modalSignificadoEstados">
                    Ver Preguntas Frecuentes
                </a>
            </div>
        </div>

    </div>
</div>

<footer class="bg-white border-top py-3 mt-auto">
    <div class="container-fluid px-4 d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
        <span class="text-muted-light text-micro">© 2024 LockerHub University Services. All rights reserved.</span>
        <div class="d-flex gap-4 text-micro">
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Privacy Policy</a>
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Terms of Service</a>
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Support</a>
        </div>
    </div>
</footer>

<!-- Modal: Significado de Estados -->
<div class="modal fade" id="modalSignificadoEstados" tabindex="-1" aria-labelledby="modalSignificadoEstadosLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 480px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px; overflow: hidden;">

            <!-- Encabezado del Modal -->
            <div class="modal-header border-bottom px-4 pt-4 pb-3">
                <h5 class="modal-title fw-bold text-navy-brand fs-5" id="modalSignificadoEstadosLabel">Significado de Estados</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <!-- Cuerpo del Modal -->
            <div class="modal-body p-4">
                <div class="d-flex flex-column gap-3">

                    <!-- Estado: Asignado -->
                    <div class="d-flex align-items-center justify-content-between gap-3">
                        <span class="badge-status-pill badge-assigned flex-shrink-0" style="min-width: 110px; justify-content: center;">
                            <i class="bi bi-check-circle-fill"></i> ASIGNADO
                        </span>
                        <span class="text-muted small">El casillero ha sido otorgado exitosamente.</span>
                    </div>

                    <!-- Estado: Pendiente -->
                    <div class="d-flex align-items-center justify-content-between gap-3">
                        <span class="badge-status-pill badge-pending flex-shrink-0" style="min-width: 110px; justify-content: center;">
                            <i class="bi bi-clock-fill"></i> PENDIENTE
                        </span>
                        <span class="text-muted small">La solicitud está en revisión administrativa.</span>
                    </div>

                    <!-- Estado: Expirado -->
                    <div class="d-flex align-items-center justify-content-between gap-3">
                        <span class="badge-status-pill badge-expired flex-shrink-0" style="min-width: 110px; justify-content: center;">
                            <i class="bi bi-arrow-counterclockwise"></i> EXPIRADO
                        </span>
                        <span class="text-muted small">El periodo de uso ha concluido.</span>
                    </div>

                    <!-- Estado: Rechazado -->
                    <div class="d-flex align-items-center justify-content-between gap-3">
                        <span class="badge-status-pill badge-rejected flex-shrink-0" style="min-width: 110px; justify-content: center;">
                            <i class="bi bi-x-circle-fill"></i> RECHAZADO
                        </span>
                        <span class="text-muted small">La solicitud no fue aprobada.</span>
                    </div>

                </div>
            </div>

            <!-- Pie del Modal -->
            <div class="modal-footer border-0 bg-light px-4 py-3 justify-content-end">
                <button type="button" class="btn btn-navy-primary px-4 py-2" data-bs-dismiss="modal" style="font-size: 0.9rem;">Cerrar</button>
            </div>

        </div>
    </div>
</div>


<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>