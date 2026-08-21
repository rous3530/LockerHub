<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Solicitud de Locker</title>

    <!-- Google Fonts: Inter (Para un aspecto moderno y limpio como en tu diseño) -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons (Para los íconos de la barra y el formulario) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <style>
        body {
            background-color: #f4f5f7;
            font-family: 'Inter', sans-serif;
            color: #1f2937;
        }

        /* NAVBAR STYLES */
        .navbar { background-color: #ffffff; padding: 0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .navbar-brand { font-weight: 700; color: #1a2538 !important; font-size: 1.3rem; padding: 15px 0; }
        .nav-link { color: #6b7280; font-weight: 500; padding: 20px 15px !important; font-size: 0.95rem; }
        .nav-link.active { color: #1a2538; border-bottom: 3px solid #1a2538; font-weight: 600; }

        /* AVATAR & HEADER USER */
        .header-icon { font-size: 1.2rem; color: #6b7280; margin-right: 15px; cursor: pointer; }
        .user-info { text-align: right; margin-right: 12px; line-height: 1.2; }
        .user-name { font-weight: 700; font-size: 0.85rem; color: #1a2538; }
        .user-id { font-size: 0.75rem; color: #9ca3af; }
        .avatar-circle { width: 38px; height: 38px; background-color: #1a2538; color: #ffffff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 0.85rem; }

        /* CARDS */
        .card { border: none; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .card-title-main { color: #1a2538; font-weight: 700; font-size: 1.4rem; }

        /* STEPS (COLUMNA IZQUIERDA) */
        .step-container { display: flex; align-items: flex-start; margin-bottom: 25px; }
        .step-circle { width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 0.85rem; margin-right: 15px; flex-shrink: 0; }
        .step-active { background-color: #1a2538; color: #ffffff; }
        .step-inactive { background-color: #e5e7eb; color: #9ca3af; }
        .step-title { font-weight: 700; font-size: 0.95rem; color: #1a2538; margin-bottom: 2px; }
        .step-desc { font-size: 0.8rem; color: #6b7280; }

        /* FORMULARIO (COLUMNA DERECHA) */
        .form-section-title { color: #1a2538; font-weight: 700; font-size: 1.15rem; }
        .form-label { font-weight: 600; color: #6b7280; font-size: 0.85rem; margin-bottom: 6px; }

        /* INPUTS ESTILO "BURBUJA GRIS" (Sin bordes) */
        .custom-input {
            background-color: #f3f4f6;
            border: none;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 0.95rem;
            color: #4b5563;
            width: 100%;
            outline: none;
        }
        .custom-input:focus { background-color: #e5e7eb; box-shadow: none; }
        .custom-input:read-only { background-color: #f3f4f6; color: #9ca3af; cursor: not-allowed; }
        select.custom-input { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236b7280' class='bi bi-chevron-down' viewBox='0 0 16 16'%3E%3Cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 1rem center; background-size: 12px; }

        .sync-text { font-size: 0.75rem; color: #9ca3af; margin-top: 6px; display: block; }

        /* BOTÓN CONTINUAR */
        .btn-continue { background-color: #1a2538; color: #ffffff; font-weight: 500; padding: 10px 24px; border-radius: 8px; border: none; font-size: 0.95rem; transition: background-color 0.2s; }
        .btn-continue:hover { background-color: #2c3e5d; color: #ffffff; }
    </style>
</head>
<body>

<!-- NAVBAR IGUAL AL DISEÑO -->
<nav class="navbar navbar-expand-lg px-4">
    <div class="container-fluid max-w-7xl">
        <a class="navbar-brand" href="#">LockerHub</a>

        <div class="collapse navbar-collapse justify-content-center">
            <ul class="navbar-nav">
                <li class="nav-item mx-3"><a class="nav-link" href="#">Inicio</a></li>
                <li class="nav-item mx-3"><a class="nav-link active" href="#">Solicitud</a></li>
            </ul>
        </div>

        <div class="d-flex align-items-center">
            <i class="bi bi-gear header-icon"></i>
            <i class="bi bi-box-arrow-right header-icon me-4"></i>

            <div class="user-info d-none d-md-block">
                <div class="user-name">${sessionScope.usuario.nombres}</div>
                <div class="user-id">ID: ${sessionScope.usuario.matricula}</div>
            </div>
            <div class="avatar-circle">
                <!-- Icono genérico si no hay iniciales disponibles -->
                <i class="bi bi-person-fill"></i>
            </div>
        </div>
    </div>
</nav>

<!-- CONTENIDO PRINCIPAL -->
<div class="container mt-5" style="max-width: 1100px;">
    <div class="row gx-4">

        <!-- COLUMNA IZQUIERDA -->
        <div class="col-lg-4 mb-4">
            <div class="card p-4 p-xl-5 h-100 bg-white">
                <h3 class="card-title-main mb-3">Solicitud de Locker</h3>
                <p class="text-muted mb-5" style="font-size: 0.95rem; line-height: 1.6;">Optimiza tu día en el campus. Solicita un espacio seguro para tus pertenencias en solo dos pasos.</p>

                <div class="step-container">
                    <div class="step-circle step-active">1</div>
                    <div>
                        <div class="step-title">Información Personal</div>
                        <div class="step-desc">Confirmación de datos e ID del casillero.</div>
                    </div>
                </div>

                <div class="step-container mb-0" style="opacity: 0.6;">
                    <div class="step-circle step-inactive">2</div>
                    <div>
                        <div class="step-title" style="color: #6b7280;">Finalizar</div>
                        <div class="step-desc">Términos y condiciones.</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- COLUMNA DERECHA -->
        <div class="col-lg-8">
            <div class="card p-4 p-xl-5 bg-white">
                <div class="d-flex align-items-center mb-4 pb-2 border-bottom">
                    <i class="bi bi-person-badge text-primary fs-4 me-2" style="color: #1a2538 !important;"></i>
                    <h5 class="form-section-title mb-0">Paso 1: Identificación Estudiantil</h5>
                </div>

                <!-- FORMULARIO CORREGIDO AL BACKEND -->
                <form action="${pageContext.request.contextPath}/solicitud-locker" method="POST">

                    <!-- Fila 1: Nombre y Matrícula -->
                    <div class="row mb-4">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <label class="form-label">Nombre Completo</label>
                            <input type="text" class="custom-input" value="${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidoPaterno}" readonly />
                            <span class="sync-text"><i class="bi bi-lock-fill"></i> Dato sincronizado con servicios universitarios</span>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Matrícula / ID</label>
                            <input type="text" class="custom-input" value="${sessionScope.usuario.matricula}" readonly />
                        </div>
                    </div>

                    <!-- Fila 2: Carrera (Visual, omitida en backend) y Cuatrimestre -->
                    <div class="row mb-4">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <label class="form-label">Carrera</label>
                            <!-- No lleva atributo "name", el backend lo ignora -->
                            <input type="text" class="custom-input" value="Sincronizado" readonly />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Cuatrimestre</label>
                            <input type="number" name="cuatrimestre" class="custom-input" placeholder="Ej. 4" min="1" max="11" required />
                        </div>
                    </div>

                    <!-- Fila 3: Grupo y Edificio -->
                    <div class="row mb-4 pb-2">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <label class="form-label">Grupo</label>
                            <input type="text" name="grupo" class="custom-input" placeholder="Ej. A, B, C" maxlength="1" required style="text-transform: uppercase;" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Docencia / Edificio</label>
                            <select name="idEdificio" class="custom-input" required>
                                <option value="" disabled selected>Selecciona...</option>
                                <option value="1">TALLER PESADO 1</option>
                                <option value="2">DOCENCIA 1</option>
                                <option value="3">DOCENCIA 2</option>
                                <option value="4">DOCENCIA 3</option>
                                <option value="5">DOCENCIA 4</option>
                            </select>
                        </div>
                    </div>

                    <!-- Parametros Ocultos -->
                    <input type="hidden" name="idPeriodoCuatri" value="1" />

                    <!-- Botón Enviar -->
                    <div class="d-flex justify-content-end mt-2 pt-3 border-top">
                        <button type="submit" class="btn-continue">
                            Continuar <i class="bi bi-arrow-right ms-1"></i>
                        </button>
                    </div>

                </form>
            </div>
        </div>

    </div>
</div>

<!-- Scripts Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>