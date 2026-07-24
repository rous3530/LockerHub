<%--
  Created by IntelliJ IDEA.
  User: josef
  Date: 7/2/2026
  Time: 11:48 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Panel de Administración</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        /* Estilos personalizados para el Dashboard */
        .bg-navy { background-color: #1a365d; }
        .text-navy { color: #1a365d; }
        .bg-navy-dark { background-color: #112952; }

        /* Ajustes de navegación activa */
        .nav-link-custom {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            padding-bottom: 4px;
        }
        .nav-link-custom:hover { color: #fff; }
        .nav-link-custom.active {
            color: #fff;
            border-bottom: 2px solid #fff;
        }

        /* Tarjetas de métricas */
        .metric-card {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background-color: #ffffff;
            transition: transform 0.2s;
        }
        .metric-icon {
            color: #1a365d;
            font-size: 1.25rem;
        }

        /* Contenedor Principal de la Tabla */
        .table-container {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background-color: #ffffff;
            overflow: hidden;
        }
        .table-header-bg {
            background-color: #eef2ff;
        }
        .table-th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 700;
            padding: 15px 20px;
        }
        .empty-state {
            padding: 60px 20px;
            color: #64748b;
        }
        .table-footer-bg {
            background-color: #eef2ff;
            border-top: 1px solid #e2e8f0;
            padding: 15px 20px;
        }

        /* Buscador */
        .search-input-group {
            max-width: 280px;
        }
        .search-input-group .form-control {
            border-radius: 8px;
            font-size: 0.9rem;
        }

        /* Ajuste de avatar de usuario */
        .avatar-circle {
            width: 32px;
            height: 32px;
            background-color: #475569;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.85rem;
        }
    </style>
</head>
<body class="bg-light" style="min-height: 100vh; display: flex; flex-direction: column;">

<nav class="navbar navbar-dark bg-navy py-3 shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold fs-4 m-0" href="#">LockerHub</a>

        <div class="d-flex gap-4 mx-auto">
            <a href="#" class="nav-link-custom active">Solicitudes</a>
            <a href="#" class="nav-link-custom">Pre-Aceptados</a>
            <a href="#" class="nav-link-custom">Aceptados</a>
        </div>

        <div class="d-flex align-items-center gap-3">
            <a href="#" class="text-white opacity-75"><i class="bi bi-bell fs-5"></i></a>
            <a href="#" class="text-white opacity-75"><i class="bi bi-gear fs-5"></i></a>
            <div class="avatar-circle fw-bold">U</div>
        </div>
    </div>
</nav>

<div class="container-fluid px-4 py-4 flex-grow-1">

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="text-muted fw-bold text-uppercase" style="font-size: 0.75rem; letter-spacing: 0.05em;">Total de Lockers</span>
                    <i class="bi bi-lock metric-icon"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy m-0">1,000</h2>
                <p class="text-muted small mb-3">Capacidad total instalada</p>
                <div class="progress" style="height: 6px;">
                    <div class="progress-bar bg-navy" role="progressbar" style="width: 100%;"></div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="text-muted fw-bold text-uppercase" style="font-size: 0.75rem; letter-spacing: 0.05em;">Disponibles</span>
                    <i class="bi bi-check-circle metric-icon"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy m-0">120</h2>
                <p class="text-muted small mb-3">Disponibilidad inmediata (12%)</p>
                <div class="progress" style="height: 6px;">
                    <div class="progress-bar bg-navy" role="progressbar" style="width: 12%;"></div>
                    <div class="progress-bar bg-light" role="progressbar" style="width: 88%;"></div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="p-4 metric-card shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="text-muted fw-bold text-uppercase" style="font-size: 0.75rem; letter-spacing: 0.05em;">Solicitudes Pendientes</span>
                    <i class="bi bi-clipboard-check metric-icon"></i>
                </div>
                <h2 class="display-6 fw-bold text-navy m-0">0</h2>
                <p class="text-muted small mb-3">Requieren revisión administrativa</p>
                <div class="progress" style="height: 6px;">
                    <div class="progress-bar bg-navy" role="progressbar" style="width: 30%;"></div>
                    <div class="progress-bar bg-light" role="progressbar" style="width: 70%;"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="table-container shadow-sm mb-4">
        <div class="p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h3 class="h5 fw-bold text-navy mb-1">Listado de Solicitudes</h3>
                <p class="text-muted small mb-0">Gestión de trámites pendientes de asignación</p>
            </div>
            <div class="search-input-group">
                <div class="input-group">
                    <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-person-search"></i></span>
                    <input type="text" class="form-control border-start-0 ps-0" placeholder="Buscar estudiante...">
                </div>
            </div>
        </div>

        <div class="table-header-bg border-top border-bottom">
            <div class="row m-0">
                <div class="col-3 table-th">Estudiante</div>
                <div class="col-2 table-th text-center">Matrícula</div>
                <div class="col-3 table-th text-center">Cuatrimestre</div>
                <div class="col-2 table-th text-center">Grupo</div>
                <div class="col-2 table-th text-end">Acciones</div>
            </div>
        </div>

        <div class="empty-state text-center">
            <div class="mb-2">
                <i class="bi bi-check-circle text-muted" style="font-size: 1.5rem;"></i>
            </div>
            <p class="mb-0 small text-secondary fw-semibold">Ya no tiene pendientes de pre-aceptados</p>
        </div>

        <div class="table-footer-bg d-flex justify-content-between align-items-center flex-wrap gap-2">
            <span class="text-muted small fw-semibold">Mostrando 3 de 45 solicitudes</span>

            <nav>
                <ul class="pagination pagination-sm m-0 gap-1">
                    <li class="page-item">
                        <a class="page-link rounded text-dark border-0 bg-light" href="#"><i class="bi bi-chevron-left"></i></a>
                    </li>
                    <li class="page-item active">
                        <a class="page-link rounded border-0 bg-navy text-white" href="#">1</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link rounded text-dark border-0 bg-light" href="#">2</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link rounded text-dark border-0 bg-light" href="#">3</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link rounded text-dark border-0 bg-light" href="#"><i class="bi bi-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>

</div>

<footer class="bg-white py-4 border-top mt-auto">
    <div class="container-fluid px-4 text-muted" style="font-size: 0.75rem;">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                © 2024 LockerHub Administrative Management System. Universidad Politécnica.
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-muted text-decoration-none mx-2">Términos y Condiciones</a>
                <a href="#" class="text-muted text-decoration-none mx-2">Soporte Técnico</a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>