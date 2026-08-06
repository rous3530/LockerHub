<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>LockerHub - Estudiantes Aceptados</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

<main class="container">
    <!-- Encabezado de Sección -->
    <header class="header-section">
        <div>
            <h2>Estudiantes Aceptados</h2>
            <p>Gestión de usuarios con lockers asignados.</p>
        </div>
    </header>

    <!-- Tarjetas de Métricas Superiores -->
    <section class="metrics-grid-top">
        <div class="card-metric">
            <span class="metric-title">TOTAL ACEPTADOS</span>
            <span class="metric-value">${totalAceptados != null ? totalAceptados : '1,248'}</span>
            <span class="metric-trend text-success">↗️ +12% este mes</span>
        </div>

        <div class="card-metric">
            <span class="metric-title">LOCKERS USO</span>
            <span class="metric-value">${porcentajeUso != null ? porcentajeUso : '85%'}</span>
            <div class="progress-bar-container">
                <div class="progress-bar-fill" style="width: ${porcentajeUso != null ? porcentajeUso : '85%'};"></div>
            </div>
        </div>
    </section>

    <!-- Contenedor Principal de Tabla y Buscador -->
    <section class="table-card">
        <!-- Buscador Superior -->
        <div class="search-bar-container">
            <div class="search-input-wrapper">
                <span class="search-icon">🔍</span>
                <input type="text" id="searchInput" placeholder="Buscar por matrícula o nombre..." onkeyup="filtrarTablaAceptados()">
            </div>
        </div>

        <!-- Tabla de Aceptados -->
        <table id="aceptadosTable" class="data-table">
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
                                <div class="user-cell">
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
                                <span class="badge-status success">● Aceptado</span>
                            </td>
                            <td>
                                <button class="btn-action-report" onclick="abrirModalReporte('${item.id}', '${item.nombre}')">
                                    📄 Reporte
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Datos de prueba estáticos por defecto -->
                    <tr>
                        <td>
                            <div class="user-cell">
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
                        <td><span class="badge-status success">● Aceptado</span></td>
                        <td>
                            <button class="btn-action-report" onclick="abrirModalReporte('1', 'Alejandro Rivera')">
                                📄 Reporte
                            </button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="user-cell">
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
                        <td><span class="badge-status success">● Aceptado</span></td>
                        <td>
                            <button class="btn-action-report" onclick="abrirModalReporte('2', 'Mariana Cervantes')">
                                📄 Reporte
                            </button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="user-cell">
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
                        <td><span class="badge-status success">● Aceptado</span></td>
                        <td>
                            <button class="btn-action-report" onclick="abrirModalReporte('3', 'Daniel Salazar')">
                                📄 Reporte
                            </button>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>

        <!-- Paginador e Info -->
        <footer class="table-footer">
            <span class="text-muted">Mostrando 1–10 de 1,248</span>
            <div class="pagination-controls">
                <button class="btn-page" disabled>&lt;</button>
                <button class="btn-page active">1</button>
                <button class="btn-page">2</button>
                <button class="btn-page">3</button>
                <button class="btn-page">&gt;</button>
            </div>
        </footer>
    </section>
</main>

<!-- MODAL: Generar Reporte Adjunto -->
<div id="modalReporte" class="modal">
    <div class="modal-content centered">
        <h3 class="modal-title-blue">Reporte</h3>
        <p class="modal-subtitle">
            Aquí se generará el reporte que se le adjuntará al estudiante <strong id="modalEstudianteNombre">Eduardo Flores</strong>
        </p>

        <form id="formReporte" onsubmit="adjuntarReporte(event)">
            <input type="hidden" id="modalEstudianteId" name="estudianteId">

            <div class="form-group text-left">
                <label for="textoReporte" class="input-label">Escribir Reporte</label>
                <textarea
                        id="textoReporte"
                        name="reporte"
                        rows="4"
                        class="form-control-textarea"
                        placeholder="Ej. No cumple con los requisitos"
                        required></textarea>
            </div>

            <div class="modal-buttons-row">
                <button type="button" class="btn btn-navy" onclick="cerrarModalReporte()">REGRESAR</button>
                <button type="submit" class="btn btn-dark-green">ADJUNTAR</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/aceptados.js"></script>
</body>
</html>