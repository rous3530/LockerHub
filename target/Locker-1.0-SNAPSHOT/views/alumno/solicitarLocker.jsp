<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        /* Card Izquierda del Stepper */
        .stepper-card {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 2rem 1.5rem;
        }

        .step-item {
            display: flex;
            align-items: flex-start;
            gap: 0.85rem;
        }

        .step-number {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background-color: #e2e8f0;
            color: #64748b;
            font-weight: 700;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .step-item.active .step-number {
            background-color: #1a365d;
            color: #ffffff;
        }

        .step-item.completed .step-number {
            background-color: #1a365d;
            color: #ffffff;
        }

        .step-title {
            font-size: 0.9rem;
            font-weight: 700;
            color: #334155;
            line-height: 1.2;
        }

        .step-item.active .step-title,
        .step-item.completed .step-title {
            color: #1a365d;
        }

        .step-desc {
            font-size: 0.75rem;
            color: #64748b;
            margin-top: 2px;
        }

        /* Formulario y Tarjeta Principal */
        .form-card {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 2rem;
        }

        .form-label-custom {
            font-size: 0.85rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 0.4rem;
        }

        .form-control-custom {
            background-color: #f1f5f9;
            border: 1px solid transparent;
            border-radius: 8px;
            padding: 0.65rem 1rem;
            font-size: 0.9rem;
            color: #1e293b;
            width: 100%;
            transition: all 0.2s ease;
        }

        .form-control-custom:focus {
            background-color: #ffffff;
            border-color: #1a365d;
            outline: none;
            box-shadow: 0 0 0 2px rgba(26, 54, 93, 0.1);
        }

        .sync-text {
            font-size: 0.72rem;
            color: #64748b;
            display: flex;
            align-items: center;
            gap: 4px;
            margin-top: 0.3rem;
        }

        /* Alertas de Error y Éxito */
        .alert-danger-custom {
            background-color: #fef2f2;
            border: 1px solid #fca5a5;
            color: #b91c1c;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-success-custom {
            background-color: #dcfce7;
            border: 1px solid #86efac;
            color: #15803d;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-size: 0.85rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .has-error .form-control-custom {
            border-color: #ef4444 !important;
            background-color: #f1f5f9;
        }

        .error-feedback {
            color: #dc2626;
            font-size: 0.75rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 4px;
            margin-top: 0.35rem;
        }

        /* Cuadro de Reglamento */
        .terms-box {
            background-color: #f1f5f9;
            border-radius: 8px;
            padding: 1.25rem;
            font-size: 0.85rem;
            color: #334155;
            line-height: 1.6;
        }

        .checkbox-box {
            background-color: #f1f5f9;
            border-radius: 8px;
            padding: 1rem 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        /* Botón de Acción Principal */
        .btn-navy-action {
            background-color: #1a365d;
            color: #ffffff;
            font-weight: 600;
            border-radius: 8px;
            padding: 0.65rem 1.75rem;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.2s;
        }

        .btn-navy-action:hover {
            background-color: #112542;
            color: #ffffff;
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

            <div class="col-4 d-flex justify-content-start p-0">
                <a class="navbar-brand d-flex align-items-center fw-bold text-navy-brand m-0" href="#">
                    <i class="bi bi-shield-lock-fill text-navy-brand me-2 fs-4"></i> LockerHub
                </a>
            </div>

            <div class="col-4 d-flex justify-content-center p-0">
                <div class="d-none d-lg-flex gap-2">
                    <a href="${pageContext.request.contextPath}/alumno/dashboard.jsp" class="nav-link-custom">Inicio</a>
                    <a href="#" class="nav-link-custom active">Solicitud</a>
                </div>
            </div>

            <div class="col-4 d-flex justify-content-end align-items-center gap-3 p-0">
                <button class="btn btn-link text-muted p-1"><i class="bi bi-bell fs-5"></i></button>
                <a href="${pageContext.request.contextPath}/alumno/configuracion.jsp" class="btn btn-link text-muted p-1">
                    <i class="bi bi-gear fs-5"></i>
                </a>
                <div class="d-flex align-items-center gap-2 ps-2">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100" class="rounded-circle border" width="36" height="36" alt="Avatar">
                </div>
            </div>

        </div>
    </div>
</nav>

<div class="content-wrapper">
    <div class="container-fluid px-4" style="max-width: 1200px;">

        <div class="row g-4 mb-5">

            <!-- Sidebar Izquierda: Stepper dinámico -->
            <div class="col-lg-4">
                <div class="stepper-card shadow-sm">
                    <h3 class="fw-bold text-navy-brand fs-4 mb-2">Solicitud de Locker</h3>
                    <p class="text-muted small mb-4 lh-sm">Optimiza tu día en el campus. Solicita un espacio seguro para tus pertenencias en solo tres pasos.</p>

                    <div class="d-flex flex-column gap-4">
                        <!-- Paso 1 -->
                        <div class="step-item active" id="stepperPaso1">
                            <div class="step-number" id="numPaso1">1</div>
                            <div>
                                <div class="step-title">Información Personal</div>
                                <div class="step-desc">Confirmación de datos pre-llenados.</div>
                            </div>
                        </div>

                        <!-- Paso 2 -->
                        <div class="step-item" id="stepperPaso2">
                            <div class="step-number">2</div>
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

                    <!-- ========================================== -->
                    <!-- VISTA: PASO 1 (DATOS E IDENTIFICACIÓN)     -->
                    <!-- ========================================== -->
                    <div id="vistaPaso1">
                        <!-- Alerta global de error -->
                        <div id="alertErrorGlobal" class="alert-danger-custom mb-4 d-none">
                            <i class="bi bi-exclamation-circle fs-5"></i>
                            <span>Se han encontrado errores en el formulario. Por favor, revisa los campos marcados en rojo.</span>
                        </div>

                        <div class="d-flex align-items-center gap-2 mb-4">
                            <i class="bi bi-person-badge fs-5 text-navy-brand"></i>
                            <h4 class="fw-bold text-navy-brand fs-5 m-0">Paso 1: Identificación Estudiantil</h4>
                        </div>

                        <form id="formPaso1" onsubmit="event.preventDefault(); validarYContinuar();">
                            <div class="row g-3 mb-4">
                                <!-- Nombre Completo -->
                                <div class="col-md-6" id="fieldNombre">
                                    <label class="form-label-custom">Nombre Completo</label>
                                    <input type="text" class="form-control-custom" id="inputNombre" placeholder="Ej. Alejandro Martínez Silva">
                                    <div class="sync-text" id="syncTextNombre">
                                        <i class="bi bi-lock"></i> Dato sincronizado con servicios universitarios
                                    </div>
                                    <div class="error-feedback d-none">
                                        <i class="bi bi-exclamation-circle"></i> Favor de llenar este campo.
                                    </div>
                                </div>

                                <!-- Matrícula -->
                                <div class="col-md-6" id="fieldMatricula">
                                    <label class="form-label-custom">Matrícula / ID</label>
                                    <input type="text" class="form-control-custom" id="inputMatricula" placeholder="Ej. 2024–0012354">
                                    <div class="error-feedback d-none">
                                        <i class="bi bi-exclamation-circle"></i> Favor de llenar este campo.
                                    </div>
                                </div>

                                <!-- Carrera -->
                                <div class="col-md-6" id="fieldCarrera">
                                    <label class="form-label-custom">Carrera</label>
                                    <input type="text" class="form-control-custom" id="inputCarrera" placeholder="Ej. Ingeniería en Software">
                                    <div class="error-feedback d-none">
                                        <i class="bi bi-exclamation-circle"></i> Favor de llenar este campo.
                                    </div>
                                </div>

                                <!-- Cuatrimestre -->
                                <div class="col-md-6" id="fieldCuatrimestre">
                                    <label class="form-label-custom">Cuatrimestre</label>
                                    <input type="text" class="form-control-custom" id="inputCuatrimestre" placeholder="Ej. 4to Cuatrimestre">
                                    <div class="error-feedback d-none">
                                        <i class="bi bi-exclamation-circle"></i> Favor de llenar este campo.
                                    </div>
                                </div>

                                <!-- Grupo -->
                                <div class="col-md-6" id="fieldGrupo">
                                    <label class="form-label-custom">Grupo</label>
                                    <input type="text" class="form-control-custom" id="inputGrupo" placeholder="Ej. G-101">
                                    <div class="error-feedback d-none">
                                        <i class="bi bi-exclamation-circle"></i> Favor de llenar este campo.
                                    </div>
                                </div>

                                <!-- Docencia -->
                                <div class="col-md-6" id="fieldDocencia">
                                    <label class="form-label-custom">Docencia</label>
                                    <input type="text" class="form-control-custom" id="inputDocencia" placeholder="Ej. D1">
                                    <div class="error-feedback d-none">
                                        <i class="bi bi-exclamation-circle"></i> Favor de llenar este campo.
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn-navy-action">
                                    Continuar <i class="bi bi-arrow-right"></i>
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- ========================================== -->
                    <!-- VISTA: PASO 2 (TÉRMINOS Y CONDICIONES)     -->
                    <!-- ========================================== -->
                    <div id="vistaPaso2" class="d-none">
                        <!-- Alerta de éxito enviada -->
                        <div id="alertExitoGlobal" class="alert-success-custom mb-4 d-none">
                            <i class="bi bi-check-circle fs-5"></i>
                            <span>¡Solicitud enviada con éxito! Por favor, mantente al pendiente de la respuesta en tu correo institucional y en este portal.</span>
                        </div>

                        <div class="d-flex align-items-center gap-2 mb-4">
                            <i class="bi bi-shield-check fs-5 text-navy-brand"></i>
                            <h4 class="fw-bold text-navy-brand fs-5 m-0">Paso 2: Términos y condiciones</h4>
                        </div>

                        <!-- Recuadro del Reglamento -->
                        <div class="terms-box mb-4">
                            <h6 class="fw-bold text-navy-brand mb-3" style="font-size: 0.85rem;">REGLAMENTO DE USO DE LOCKERS UNIVERSITARIOS</h6>
                            <ol class="ps-3 mb-0 d-flex flex-column gap-2" style="font-size: 0.82rem;">
                                <li><strong>Uso Personal:</strong> El locker asignado es exclusivamente para uso personal del estudiante registrado. Queda prohibida la cesión o subarrendamiento del mismo.</li>
                                <li><strong>Responsabilidad:</strong> La universidad no se hace responsable por la pérdida, robo o daño de los objetos almacenados en el locker. Se recomienda no guardar objetos de alto valor.</li>
                                <li><strong>Mantenimiento:</strong> El estudiante debe mantener el locker limpio y en buen estado. No se permite pegar calcomanías ni realizar inscripciones en la superficie.</li>
                                <li><strong>Artículos Prohibidos:</strong> Queda estrictamente prohibido almacenar sustancias ilegales.</li>
                            </ol>
                        </div>

                        <!-- Checkbox Aceptación -->
                        <div class="checkbox-box mb-4">
                            <input class="form-check-input flex-shrink-0" type="checkbox" id="checkTerminos" style="width: 18px; height: 18px; cursor: pointer;">
                            <label class="form-check-label text-muted small fw-medium mb-0" for="checkTerminos" style="cursor: pointer;">
                                He leído y acepto el <a href="#" class="text-navy-brand fw-bold text-decoration-none">Reglamento de Uso de Lockers</a> y me comprometo a cumplir con todas las normativas establecidas.
                            </label>
                        </div>

                        <!-- Botón Enviar Solicitud -->
                        <div class="w-100">
                            <button type="button" class="btn-navy-action w-100 justify-content-center py-2" onclick="enviarSolicitudFinal()">
                                Enviar Solicitud <i class="bi bi-send-fill ms-1" style="font-size: 0.85rem;"></i>
                            </button>
                        </div>
                    </div>

                </div>
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

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

<script src="${pageContext.request.contextPath}/js/alumnos/solictudLocker.js"></script>
</body>
</html>