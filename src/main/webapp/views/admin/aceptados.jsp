<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Estudiantes Aceptados</title>
    <!-- CSS Bootstrap y Customer -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/customer.css" rel="stylesheet">
    <!-- Iconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

<!-- BARRA DE NAVEGACIÓN SUPERIOR (CABECERA) -->
<header class="navbar-admin">
    <div class="navbar-brand">LockerHub</div>

    <nav class="nav-links-center">
        <a href="${pageContext.request.contextPath}/views/admin/inicio.jsp" class="nav-link">SOLICITUDES</a>
        <a href="${pageContext.request.contextPath}/views/admin/pre-aceptacion.jsp" class="nav-link">PRE-ACEPTADOS</a>
        <a href="${pageContext.request.contextPath}/views/admin/aceptados.jsp" class="nav-link active">ACEPTADOS</a>
    </nav>

    <div class="nav-actions-right">
        <i class="bi bi-bell"></i>
        <i class="bi bi-gear"></i>
        <i class="bi bi-question-circle"></i>
        <div class="user-avatar-nav ms-2">
            <img src="${pageContext.request.contextPath}/img/avatar.png" alt="Usuario" onerror="this.src='https://ui-avatars.com/api/?name=Admin&background=0d6efd&color=fff'">
        </div>
    </div>
</header>

<main class="container mt-4">
    <!-- Encabezado de Sección con Buscador Alineado -->
    <header class="header-section">
        <div class="header-title">
            <h2>Estudiantes Aceptados</h2>
            <p>Gestión de usuarios con lockers asignados.</p>
        </div>
        <div class="header-actions">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Buscar por matrícula o nombre..." onkeyup="filtrarTablaAceptados()">
            </div>
        </div>
    </header>

    <!-- Tarjetas de Métricas Superiores -->
    <section class="metrics-grid">
        <div class="card card-blue">
            <div class="card-icon-box">
                p
            </div>
            <div>
                <span class="metric-number">${totalAceptados != null ? totalAceptados : '1,248'}</span>
                <span class="metric-label">TOTAL ACEPTADOS <span class="text-success ms-1"><i class="bi bi-arrow-up-right"></i> +12% este mes</span></span>
            </div>
        </div>

        <div class="card card-green">
            <div class="card-icon-box">
                <i class="bi bi-door-closed-fill"></i>
            </div>
            <div class="w-100">
                <span class="metric-number">${porcentajeUso != null ? porcentajeUso : '85%'}</span>
                <span class="metric-label">LOCKERS EN USO</span>
                <div class="progress mt-2" style="height: 6px;">
                    <div class="progress-bar bg-success" role="progressbar" style="width: ${porcentajeUso != null ? porcentajeUso : '85%'};" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contenedor Principal de Tabla -->
    <section class="table-container">
        <!-- Tabla de Aceptados -->
        <table id="preAceptadosTable">
            <thead>
            <tr>
                <th>ESTUDIANTE</th>
                <th>MATRÍCULA</th>
                <th>CUATRIMESTRE</th>
                <th>GRUPO</th>
                <th>STATUS</th>
                <th>ACCIONES</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty listaAceptados}">
                    <c:forEach var="item" items="${listaAceptados}">
                        <tr>
                            <td>
                                <div class="student-cell">
                                    <div class="avatar-circle">${item.iniciales}</div>
                                    <div>
                                        <strong>${item.nombre}</strong><br>
                                        <small class="text-muted">${item.email}</small>
                                    </div>
                                </div>
                            </td>
                            <td>${item.matricula}</td>
                            <td>${item.cuatrimestre}</td>
                            <td>${item.grupo}</td>
                            <td>
                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill">
                                    ● Aceptado
                                </span>
                            </td>
                            <td>
                                <button type="button" class="btn-link text-primary" onclick="abrirModalReporte('${item.id}', '${item.nombre}')">
                                    <i class="bi bi-file-earmark-text"></i> Reporte
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Datos de prueba estáticos por defecto -->
                    <tr>
                        <td>
                            <div class="student-cell">
                                <div class="avatar-circle">AR</div>
                                <div>
                                    <strong>Alejandro Rivera</strong><br>
                                    <small class="text-muted">arivera@univ.edu</small>
                                </div>
                            </div>
                        </td>
                        <td>20210345</td>
                        <td>7mo</td>
                        <td>IT-701</td>
                        <td>
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill">
                                ● Aceptado
                            </span>
                        </td>
                        <td>
                            <button type="button" class="btn-link text-primary" onclick="abrirModalReporte('1', 'Alejandro Rivera')">
                                <i class="bi bi-file-earmark-text"></i> Reporte
                            </button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="student-cell">
                                <div class="avatar-circle">MC</div>
                                <div>
                                    <strong>Mariana Cervantes</strong><br>
                                    <small class="text-muted">mcervantes@univ.edu</small>
                                </div>
                            </div>
                        </td>
                        <td>20210219</td>
                        <td>4to</td>
                        <td>LG-402</td>
                        <td>
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill">
                                ● Aceptado
                            </span>
                        </td>
                        <td>
                            <button type="button" class="btn-link text-primary" onclick="abrirModalReporte('2', 'Mariana Cervantes')">
                                <i class="bi bi-file-earmark-text"></i> Reporte
                            </button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="student-cell">
                                <div class="avatar-circle">DS</div>
                                <div>
                                    <strong>Daniel Salazar</strong><br>
                                    <small class="text-muted">dsalazar@univ.edu</small>
                                </div>
                            </div>
                        </td>
                        <td>20220110</td>
                        <td>2do</td>
                        <td>IM-203</td>
                        <td>
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill">
                                ● Aceptado
                            </span>
                        </td>
                        <td>
                            <button type="button" class="btn-link text-primary" onclick="abrirModalReporte('3', 'Daniel Salazar')">
                                <i class="bi bi-file-earmark-text"></i> Reporte
                            </button>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>

        <!-- Paginador e Info -->
        <footer class="table-pagination">
            <span class="text-muted">Mostrando 1–10 de 1,248</span>
            <div class="pagination-controls">
                <a href="#" class="page-btn disabled">&lt;</a>
                <a href="#" class="page-btn active">1</a>
                <a href="#" class="page-btn">2</a>
                <a href="#" class="page-btn">3</a>
                <a href="#" class="page-btn">&gt;</a>
            </div>
        </footer>
    </section>
</main>

<!-- MODAL: Generar Reporte Adjunto -->
<div id="modalReporte" class="modal">
    <div class="register-container p-4 mx-auto my-auto">
        <h3 class="text-navy fw-bold h4 mb-1">Reporte</h3>
        <p class="text-secondary small mb-3">
            Aquí se generará el reporte que se le adjuntará al estudiante <strong id="modalEstudianteNombre">Eduardo Flores</strong>
        </p>

        <form id="formReporte" onsubmit="adjuntarReporte(event)">
            <input type="hidden" id="modalEstudianteId" name="estudianteId">

            <div class="mb-3 text-start">
                <label for="textoReporte" class="form-label text-secondary fw-semibold small">Escribir Reporte</label>
                <textarea
                        id="textoReporte"
                        name="reporte"
                        rows="4"
                        class="form-control"
                        placeholder="Ej. No cumple con los requisitos"
                        required></textarea>
            </div>

            <div class="d-flex justify-content-end gap-2 mt-4">
                <button type="button" class="btn btn-secondary bg-secondary text-white" onclick="cerrarModalReporte()">REGRESAR</button>
                <button type="submit" class="btn btn-success">ADJUNTAR</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/aceptados.js"></script>
</body>
</html>