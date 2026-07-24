<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Reglamento de Uso</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">
    <!-- Link de respaldo en caso de usar CDN, puedes adaptarlo a tu local -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerAlumno.css">

    <style>
        /* Ajustes estéticos adicionales para igualar exactamente la imagen image_574848.png */
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

        .card-main-regulation {
            background-color: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        /* Banner de Cabecera con patrón decorativo */
        .header-pattern-box {
            background-color: #1a365d;
            border-radius: 16px;
            height: 140px;
            width: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .header-pattern-box::after {
            content: '';
            position: absolute;
            width: 80px;
            height: 80px;
            border: 8px solid rgba(255, 255, 255, 0.15);
            transform: rotate(45deg);
            top: -20px;
            right: -20px;
        }

        .header-pattern-box::before {
            content: '';
            position: absolute;
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255, 255, 255, 0.1);
            transform: rotate(45deg);
            bottom: -10px;
            left: -10px;
        }

        .pattern-lines {
            position: absolute;
            width: 100%;
            height: 100%;
            background: repeating-linear-gradient(
                    45deg,
                    transparent,
                    transparent 10px,
                    rgba(255, 255, 255, 0.05) 10px,
                    rgba(255, 255, 255, 0.05) 20px
            );
        }

        /* Obligaciones del usuario */
        .obligation-item {
            background-color: #f1f5f9;
            border-radius: 10px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            transition: all 0.2s ease;
        }

        .obligation-item:hover {
            border-color: #cbd5e1;
            background-color: #e2e8f0;
        }

        .obligation-num {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2563eb;
            line-height: 1;
        }

        /* Prohibiciones */
        .prohibition-list-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 1rem;
            font-size: 0.95rem;
            color: #475569;
        }

        .prohibition-icon {
            color: #dc2626;
            font-size: 1.15rem;
            flex-shrink: 0;
            margin-top: 2px;
        }

        /* Sanciones */
        .sanction-subcard {
            background-color: #fef2f2;
            border-left: 4px solid #dc2626;
            padding: 1rem;
            border-radius: 4px 8px 8px 4px;
            margin-bottom: 1rem;
        }

        .sanction-subcard.grave {
            background-color: #fffaf0;
            border-left-color: #ea580c;
        }

        .sanction-subcard.material {
            background-color: #f8fafc;
            border-left-color: #64748b;
        }

        /* Sección de Privacidad Inferior */
        .privacy-banner {
            background-color: #e0f2fe;
            border-radius: 16px;
            padding: 2.5rem;
        }

        .privacy-image {
            border-radius: 16px;
            object-fit: cover;
            width: 100%;
            max-height: 220px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.075);
        }

        .text-micro {
            font-size: 0.75rem;
        }
    </style>
</head>
<body class="bg-page">

<!-- Navbar adaptada de image_574848.png -->
<!-- Navbar Corregida y Perfectamente Centrada -->
<nav class="navbar navbar-expand-lg bg-white border-bottom py-2 mb-4">
    <div class="container-fluid px-4">
        <div class="row w-100 align-items-center m-0">

            <!-- Columna Izquierda: Logo -->
            <div class="col-4 d-flex justify-content-start p-0">
                <a class="navbar-brand d-flex align-items-center fw-bold text-navy-brand m-0" href="#">
                    LockerHub
                </a>
            </div>

            <!-- Columna Central: Menú de Navegación Absolutamente Centrado -->
            <div class="col-4 d-flex justify-content-center p-0">
                <div class="d-none d-lg-flex gap-2">
                    <a href="${pageContext.request.contextPath}/views/alumno/inicio.jsp" class="nav-link-custom">Inicio</a>
                    <a href="${pageContext.request.contextPath}/views/alumno/reglamento.jsp" class="nav-link-custom active">Reglamento</a>
                </div>
            </div>

            <!-- Columna Derecha: Opciones y Perfil del Usuario -->
            <div class="col-4 d-flex justify-content-end align-items-center gap-3 p-0">
                <button class="btn btn-link text-muted p-1"><i class="bi bi-gear fs-5"></i></button>
                <button class="btn btn-link text-muted p-1 border-end pe-3" onclick="location.href='${pageContext.request.contextPath}/logout'"><i class="bi bi-box-arrow-right fs-5"></i></button>
                <div class="d-flex align-items-center gap-2 ps-2">
                    <div class="text-end d-none d-sm-block lh-1">
                        <div class="fw-bold text-dark small mb-1">Carlos Mendoza</div>
                        <span class="text-muted text-micro">ID: 2023-0452</span>
                    </div>
                    <img src="https://ui-avatars.com/api/?name=Carlos+Mendoza&background=1a365d&color=fff&size=100" class="rounded-circle border" width="36" height="36" alt="Avatar">
                </div>
            </div>

        </div>
    </div>
</nav>

<div class="content-wrapper">
    <div class="container-fluid px-4 main-layout" style="max-width: 1200px;">

        <!-- Cabecera / Hero de Reglamento -->
        <div class="card card-custom p-4 mb-4 border-0 bg-transparent">
            <div class="d-flex flex-column flex-md-row align-items-center justify-content-between gap-4">
                <div class="text-center text-md-start">
                    <h1 class="fw-bold text-navy-brand mb-2" style="font-size: 2.8rem; letter-spacing: -0.5px;">Reglamento de Uso</h1>
                    <p class="text-muted mb-0 fs-5" style="max-width: 650px; line-height: 1.5;">
                        Normas y lineamientos para garantizar un servicio de casilleros seguro, eficiente y ordenado para toda la comunidad universitaria.
                    </p>
                </div>
                <div class="header-pattern-box d-none d-md-flex">
                    <div class="pattern-lines"></div>
                    <i class="bi bi-file-earmark-ruled text-white fs-1 opacity-75"></i>
                </div>
            </div>
        </div>

        <!-- Seccion 1: Obligaciones del Usuario (Full Width Card) -->
        <div class="card card-main-regulation p-4 mb-4">
            <div class="d-flex align-items-center gap-2 mb-4 border-bottom pb-3">
                <i class="bi bi-shield-check text-navy-brand fs-4"></i>
                <h3 class="fw-bold text-navy-brand m-0 fs-4">Obligaciones del Usuario</h3>
            </div>

            <div class="row g-3">
                <!-- Obligación 1 -->
                <div class="col-12">
                    <div class="obligation-item d-flex flex-column flex-sm-row gap-3 align-items-sm-start">
                        <div class="obligation-num">01</div>
                        <div>
                            <h5 class="fw-bold text-navy-brand mb-1" style="font-size: 1.05rem;">Mantenimiento y Limpieza</h5>
                            <p class="text-muted mb-0">El estudiante debe mantener el interior y exterior del casillero en perfectas condiciones de limpieza e higiene.</p>
                        </div>
                    </div>
                </div>
                <!-- Obligación 2 -->
                <div class="col-12">
                    <div class="obligation-item d-flex flex-column flex-sm-row gap-3 align-items-sm-start">
                        <div class="obligation-num">02</div>
                        <div>
                            <h5 class="fw-bold text-navy-brand mb-1" style="font-size: 1.05rem;">Cierre de Seguridad</h5>
                            <p class="text-muted mb-0">Es responsabilidad única del usuario asegurar el cierre correcto del compartimento tras cada uso mediante el sistema digital.</p>
                        </div>
                    </div>
                </div>
                <!-- Obligación 3 -->
                <div class="col-12">
                    <div class="obligation-item d-flex flex-column flex-sm-row gap-3 align-items-sm-start">
                        <div class="obligation-num">03</div>
                        <div>
                            <h5 class="fw-bold text-navy-brand mb-1" style="font-size: 1.05rem;">Reporte de Fallas</h5>
                            <p class="text-muted mb-0">Cualquier anomalía técnica o daño estructural debe ser reportado inmediatamente a través del portal LockerHub.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Seccion 2: Prohibiciones y Sanciones (2 columnas) -->
        <div class="row g-4 mb-4">

            <!-- Columna Prohibiciones -->
            <div class="col-lg-6">
                <div class="card card-main-regulation p-4 h-100">
                    <div class="d-flex align-items-center gap-2 mb-4 border-bottom pb-3">
                        <i class="bi bi-slash-circle text-danger fs-4"></i>
                        <h3 class="fw-bold text-navy-brand m-0 fs-4">Prohibiciones Estrictas</h3>
                    </div>

                    <div class="prohibition-list-item">
                        <i class="bi bi-check-circle-fill prohibition-icon"></i>
                        <span>Almacenar sustancias inflamables, tóxicas, explosivas o de procedencia ilícita.</span>
                    </div>
                    <div class="prohibition-list-item">
                        <i class="bi bi-check-circle-fill prohibition-icon"></i>
                        <span>El almacenamiento de alimentos perecederos o cualquier material que genere malos olores.</span>
                    </div>
                    <div class="prohibition-list-item">
                        <i class="bi bi-check-circle-fill prohibition-icon"></i>
                        <span>Transferir o subarrendar el uso del casillero a terceros bajo ninguna circunstancia.</span>
                    </div>
                    <div class="prohibition-list-item">
                        <i class="bi bi-check-circle-fill prohibition-icon"></i>
                        <span>Realizar modificaciones físicas, pintar o adherir calcomanías permanentes al casillero.</span>
                    </div>
                </div>
            </div>

            <!-- Columna Régimen de Sanciones -->
            <div class="col-lg-6">
                <div class="card card-main-regulation p-4 h-100">
                    <div class="d-flex align-items-center gap-2 mb-4 border-bottom pb-3">
                        <i class="bi bi-exclamation-triangle text-navy-brand fs-4"></i>
                        <h3 class="fw-bold text-navy-brand m-0 fs-4">Régimen de Sanciones</h3>
                    </div>

                    <!-- Falta Leve -->
                    <div class="sanction-subcard">
                        <div class="fw-bold text-danger mb-1" style="font-size: 0.9rem;">Faltas Leves</div>
                        <p class="text-muted mb-0 small">Amonestación por escrito y suspensión del servicio por 7 días naturales.</p>
                    </div>

                    <!-- Falta Grave -->
                    <div class="sanction-subcard">
                        <div class="fw-bold text-danger mb-1" style="font-size: 0.9rem;">Faltas Graves</div>
                        <p class="text-muted mb-0 small">Pérdida definitiva del derecho de uso del locker y reporte al expediente académico.</p>
                    </div>

                    <!-- Daño Material -->
                    <div class="sanction-subcard">
                        <div class="fw-bold text-danger mb-1" style="font-size: 0.9rem;">Daños Materiales</div>
                        <p class="text-muted mb-0 small">El estudiante deberá cubrir el costo total de la reparación o reposición del bien dañado.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Seccion 3: Privacidad y Seguridad (Banner Azul Inferior) -->
        <div class="card border-0 privacy-banner mb-4">
            <div class="row align-items-center g-4">
                <div class="col-md-7">
                    <h3 class="fw-bold text-navy-brand mb-3" style="font-size: 1.8rem;">Privacidad y Seguridad</h3>
                    <p class="text-muted mb-0 fs-5" style="line-height: 1.6;">
                        La universidad se reserva el derecho de inspección de los casilleros en presencia del usuario o ante situaciones de emergencia que comprometan la seguridad del campus.
                    </p>
                </div>
                <div class="col-md-5">
                    <!-- Imagen de casilleros / pasillo moderno -->
                    <img src="${pageContext.request.contextPath}/img/lockers.png" class="privacy-image" alt="Pasillo de casilleros universitarios">
                </div>
            </div>
        </div>

    </div>
</div>

<footer class="bg-white border-top py-3 mt-auto">
    <div class="container-fluid px-4 d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
        <span class="text-muted-light text-micro">© 2024 LockerHub - Portal Universitario</span>
        <div class="d-flex gap-4 text-micro">
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Términos y Condiciones</a>
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Política de Privacidad</a>
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Soporte Técnico</a>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>