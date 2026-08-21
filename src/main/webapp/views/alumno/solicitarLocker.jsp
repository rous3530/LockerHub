<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mx.edu.utez.locker.model.AlumnoDashboardDto" %>
<%@ page import="mx.edu.utez.locker.dao.DaoSolicitud" %>
<%@ page import="mx.edu.utez.locker.model.EdificioDto" %>
<%@ page import="mx.edu.utez.locker.model.Alumno" %>
<%@ page import="java.util.List" %>
<%
    // Instanciar DAO y consultar edificios una sola vez al inicio
    DaoSolicitud daoEdificio = new DaoSolicitud();
    List<EdificioDto> listaEdificios = daoEdificio.obtenerEdificios();

    // Traza de control en consola del servidor
    System.out.println("[JSP] Cantidad de edificios obtenidos: " + (listaEdificios != null ? listaEdificios.size() : "NULL"));

    HttpSession sesion = request.getSession(false);
    Alumno alumnoSesion = (sesion != null) ? (Alumno) sesion.getAttribute("usuario") : null;

    // Verificamos si existe el usuario en sesión
    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }

    String nombre = (alumnoSesion != null) ? alumnoSesion.getNombres() : "Sin nombre";
    String matricula = (alumnoSesion != null) ? alumnoSesion.getMatricula() : "Sin matrícula";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Solicitud de Locker</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerAlumno.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
        }
        .text-navy-brand { color: #1a365d !important; }
        .nav-link-custom {
            font-weight: 500; color: #64748b; padding: 0.5rem 1rem; text-decoration: none; transition: color 0.2s ease;
        }
        .nav-link-custom:hover { color: #1a365d; }
        .nav-link-custom.active { color: #1a365d; border-bottom: 2px solid #1a365d; font-weight: 600; }
        .stepper-card { background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 2rem 1.5rem; }
        .step-item { display: flex; align-items: flex-start; gap: 0.85rem; }
        .step-number { width: 28px; height: 28px; border-radius: 50%; background-color: #e2e8f0; color: #64748b; font-weight: 700; font-size: 0.85rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .step-item.active .step-number, .step-item.completed .step-number { background-color: #1a365d; color: #ffffff; }
        .step-title { font-size: 0.9rem; font-weight: 700; color: #334155; line-height: 1.2; }
        .step-item.active .step-title, .step-item.completed .step-title { color: #1a365d; }
        .step-desc { font-size: 0.75rem; color: #64748b; margin-top: 2px; }
        .form-card { background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 2rem; }
        .form-label-custom { font-size: 0.85rem; font-weight: 600; color: #475569; margin-bottom: 0.4rem; }
        .form-control-custom { background-color: #f1f5f9; border: 1px solid transparent; border-radius: 8px; padding: 0.65rem 1rem; font-size: 0.9rem; color: #1e293b; width: 100%; transition: all 0.2s ease; }
        .form-control-custom:focus { background-color: #ffffff; border-color: #1a365d; outline: none; box-shadow: 0 0 0 2px rgba(26, 54, 93, 0.1); }
        .sync-text { font-size: 0.72rem; color: #64748b; display: flex; align-items: center; gap: 4px; margin-top: 0.3rem; }
        .alert-danger-custom { background-color: #fef2f2; border: 1px solid #fca5a5; color: #b91c1c; border-radius: 8px; padding: 0.75rem 1rem; font-size: 0.85rem; font-weight: 500; display: flex; align-items: center; gap: 0.5rem; }
        .alert-success-custom { background-color: #dcfce7; border: 1px solid #86efac; color: #15803d; border-radius: 8px; padding: 0.75rem 1rem; font-size: 0.85rem; font-weight: 600; display: flex; align-items: center; gap: 0.5rem; }
        .terms-box { background-color: #f1f5f9; border-radius: 8px; padding: 1.25rem; font-size: 0.85rem; color: #334155; line-height: 1.6; }
        .checkbox-box { background-color: #f1f5f9; border-radius: 8px; padding: 1rem 1.25rem; display: flex; align-items: center; gap: 0.75rem; }
        .btn-navy-action { background-color: #1a365d; color: #ffffff; font-weight: 600; border-radius: 8px; padding: 0.65rem 1.75rem; border: none; display: inline-flex; align-items: center; gap: 0.5rem; transition: background-color 0.2s; }
        .btn-navy-action:hover { background-color: #112542; color: #ffffff; }
        .text-micro { font-size: 0.75rem; }
    </style>
</head>
<body class="bg-page">

<nav class="navbar navbar-expand-lg bg-white border-bottom py-2 mb-4">
    <div class="container-fluid px-4">
        <div class="row w-100 align-items-center m-0">
            <div class="col-4 d-flex justify-content-start p-0">
                <a class="navbar-brand d-flex align-items-center fw-bold text-navy-brand m-0" href="#">LockerHub</a>
            </div>
            <div class="col-4 d-flex justify-content-center p-0">
                <div class="d-none d-lg-flex gap-2">
                    <a href="${pageContext.request.contextPath}/views/alumno/inicio.jsp" class="nav-link-custom">Inicio</a>
                    <a href="#" class="nav-link-custom active">Solicitud</a>
                </div>
            </div>
            <div class="col-4 d-flex justify-content-end align-items-center gap-3 p-0">
                <a href="${pageContext.request.contextPath}/views/alumno/editarPerfil.jsp" class="btn btn-link text-muted p-1">
                    <i class="bi bi-gear fs-5"></i>
                </a>
                <a href="${pageContext.request.contextPath}/cerrar-sesion" class="btn btn-link text-muted p-1 border-end pe-3">
                    <i class="bi bi-box-arrow-right fs-5"></i>
                </a>
                <div class="d-flex align-items-center gap-2 ps-2">
                    <div class="text-end d-none d-sm-block lh-1">
                        <div class="fw-bold text-dark small mb-1"><%= nombre %></div>
                        <span class="text-muted text-micro">ID: <%= matricula %></span>
                    </div>
                    <img src="https://ui-avatars.com/api/?name=<%= nombre.replace(" ", "+") %>&background=1a365d&color=fff&size=100" class="rounded-circle border" width="36" height="36" alt="Avatar">
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="content-wrapper">
    <div class="container-fluid px-4" style="max-width: 1200px;">
        <div class="row g-4 mb-5">

            <!-- Sidebar Izquierda: Stepper -->
            <div class="col-lg-4">
                <div class="stepper-card shadow-sm">
                    <h3 class="fw-bold text-navy-brand fs-4 mb-2">Solicitud de Locker</h3>
                    <p class="text-muted small mb-4 lh-sm">Optimiza tu día en el campus. Solicita un espacio seguro para tus pertenencias en solo dos pasos.</p>
                    <div class="d-flex flex-column gap-4">
                        <div class="step-item active" id="stepperPaso1">
                            <div class="step-number" id="numPaso1">1</div>
                            <div>
                                <div class="step-title">Información Personal</div>
                                <div class="step-desc">Confirmación de datos y selección de edificio.</div>
                            </div>
                        </div>
                        <div class="step-item" id="stepperPaso2">
                            <div class="step-number" id="numPaso2">2</div>
                            <div>
                                <div class="step-title">Finalizar</div>
                                <div class="step-desc">Términos y condiciones.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Panel Derecho Principal -->
            <div class="col-lg-8">
                <div class="form-card shadow-sm">
                    <form id="formSolicitud" action="${pageContext.request.contextPath}/solicitud-locker" method="POST">
                        <input type="hidden" name="idPeriodoCuatri" value="1">

                        <!-- VISTA: PASO 1 -->
                        <div id="vistaPaso1">
                            <div class="d-flex align-items-center gap-2 mb-4">
                                <i class="bi bi-person-badge fs-5 text-navy-brand"></i>
                                <h4 class="fw-bold text-navy-brand fs-5 m-0">Paso 1: Identificación Estudiantil</h4>
                            </div>

                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label-custom">Nombre Completo</label>
                                    <input type="text" class="form-control-custom" name="nombreCompleto" value="<%= nombre %>" readonly>
                                    <div class="sync-text"><i class="bi bi-lock"></i> Dato sincronizado con servicios universitarios</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Matrícula / ID</label>
                                    <input type="text" class="form-control-custom" name="matricula" value="<%= matricula %>" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Carrera</label>
                                    <input type="text" class="form-control-custom" name="carrera" placeholder="Ej. Ingeniería en Software" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Cuatrimestre</label>
                                    <input type="number" class="form-control-custom" name="cuatrimestre" placeholder="Ej. 4" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Grupo</label>
                                    <input type="text" class="form-control-custom" name="grupo" placeholder="Ej. A, B, C" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Docencia / Edificio de Preferencia</label>
                                    <% if (listaEdificios == null || listaEdificios.isEmpty()) { %>
                                    <div class="text-danger small mb-1 fw-bold">
                                        <i class="bi bi-exclamation-triangle"></i> No se pudieron cargar los edificios desde la BD.
                                    </div>
                                    <% } %>
                                    <select class="form-control-custom" id="inputDocencia" name="idEdificio" required>
                                        <option value="" disabled selected>Selecciona un edificio...</option>
                                        <%
                                            if (listaEdificios != null) {
                                                for (EdificioDto ed : listaEdificios) {
                                        %>
                                        <option value="<%= ed.getIdEdificio() %>"><%= ed.getNombre() %></option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end">
                                <button type="button" class="btn-navy-action" onclick="validarYContinuar()">
                                    Continuar <i class="bi bi-arrow-right"></i>
                                </button>
                            </div>
                        </div>

                        <!-- VISTA: PASO 2 -->
                        <div id="vistaPaso2" class="d-none">
                            <div id="alertErrorTerminos" class="alert-danger-custom mb-4 d-none">
                                <i class="bi bi-exclamation-circle fs-5"></i>
                                <span>Debes aceptar el Reglamento de Uso de Lockers para enviar la solicitud.</span>
                            </div>

                            <div class="d-flex align-items-center gap-2 mb-4">
                                <i class="bi bi-shield-check fs-5 text-navy-brand"></i>
                                <h4 class="fw-bold text-navy-brand fs-5 m-0">Paso 2: Términos y condiciones</h4>
                            </div>

                            <div class="terms-box mb-4">
                                <h6 class="fw-bold text-navy-brand mb-3" style="font-size: 0.85rem;">REGLAMENTO DE USO DE LOCKERS UNIVERSITARIOS</h6>
                                <ol class="ps-3 mb-0 d-flex flex-column gap-2" style="font-size: 0.82rem;">
                                    <li><strong>Uso Personal:</strong> El locker asignado es exclusivamente para uso personal del estudiante registrado. Queda prohibida la cesión o subarrendamiento.</li>
                                    <li><strong>Responsabilidad:</strong> La universidad no se hace responsable por la pérdida, robo o daño de los objetos. No guardes objetos de alto valor.</li>
                                    <li><strong>Mantenimiento:</strong> El estudiante debe mantener el locker limpio y en buen estado. No se permite pegar calcomanías.</li>
                                    <li><strong>Asignación:</strong> La administración designará el número de locker específico basado en la disponibilidad del edificio seleccionado.</li>
                                </ol>
                            </div>

                            <div class="checkbox-box mb-4">
                                <input class="form-check-input flex-shrink-0" type="checkbox" id="checkTerminos" style="width: 18px; height: 18px; cursor: pointer;">
                                <label class="form-check-label text-muted small fw-medium mb-0" for="checkTerminos" style="cursor: pointer;">
                                    He leído y acepto el <a href="#" class="text-navy-brand fw-bold text-decoration-none">Reglamento de Uso de Lockers</a> y me comprometo a cumplir con todas las normativas establecidas.
                                </label>
                            </div>

                            <div class="d-flex justify-content-between align-items-center gap-3">
                                <button type="button" class="btn btn-outline-secondary px-3 py-2 fw-semibold rounded-3 text-sm" onclick="volverPaso1()">
                                    <i class="bi bi-arrow-left"></i> Regresar
                                </button>
                                <button type="button" class="btn-navy-action py-2" onclick="enviarSolicitudFinal()">
                                    Enviar Solicitud <i class="bi bi-send-fill ms-1"></i>
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<footer class="bg-white border-top py-3" style="margin-top: 10.5rem">
    <div class="container-fluid px-4 d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
        <span class="text-muted-light text-micro">© 2026 LockerHub University Services. All rights reserved.</span>
    </div>
</footer>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    function validarYContinuar() {
        let edificio = document.getElementById("inputDocencia").value;
        if(edificio === "") {
            alert("Por favor, selecciona un edificio antes de continuar.");
            return;
        }

        document.getElementById("vistaPaso1").classList.add("d-none");
        document.getElementById("vistaPaso2").classList.remove("d-none");
        document.getElementById("stepperPaso1").classList.remove("active");
        document.getElementById("stepperPaso1").classList.add("completed");
        document.getElementById("stepperPaso2").classList.add("active");
    }

    function volverPaso1() {
        document.getElementById("vistaPaso2").classList.add("d-none");
        document.getElementById("vistaPaso1").classList.remove("d-none");
        document.getElementById("stepperPaso2").classList.remove("active");
        document.getElementById("stepperPaso1").classList.remove("completed");
        document.getElementById("stepperPaso1").classList.add("active");
        document.getElementById("alertErrorTerminos").classList.add("d-none");
    }

    function enviarSolicitudFinal() {
        let checkbox = document.getElementById("checkTerminos");
        if (!checkbox.checked) {
            document.getElementById("alertErrorTerminos").classList.remove("d-none");
        } else {
            document.getElementById("alertErrorTerminos").classList.add("d-none");
            document.getElementById("formSolicitud").submit();
        }
    }
</script>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>