<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mx.edu.utez.locker.model.AlumnoDashboardDto" %>
<%@ page import="mx.edu.utez.locker.model.Alumno" %>
<%
    HttpSession sesion = request.getSession(false);
    Alumno alumnoSesion = (sesion != null) ? (Alumno) sesion.getAttribute("usuario") : null;

    // Verificamos si existe el usuario en sesión
    if (sesion == null || alumnoSesion == null) {
        response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
        return;
    }

    AlumnoDashboardDto dashboard = (AlumnoDashboardDto) request.getAttribute("dashboard");

    // Obtenemos los datos dinámicos de la sesión
    String nombre = (dashboard != null && dashboard.getNombreCompleto() != null) ? dashboard.getNombreCompleto() : alumnoSesion.getNombres();
    String matricula = (dashboard != null && dashboard.getMatricula() != null) ? dashboard.getMatricula() : alumnoSesion.getMatricula();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Editar Perfil</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght=300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerAlumno.css">

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .text-navy-brand { color: #1a365d !important; }
        .nav-link-custom { font-weight: 500; color: #64748b; padding: 0.5rem 1rem; text-decoration: none; transition: color 0.2s ease; }
        .nav-link-custom:hover { color: #1a365d; }
        .nav-link-custom.active { color: #1a365d; border-bottom: 2px solid #1a365d; font-weight: 600; }
        .card-profile-edit { background-color: #ffffff; border-radius: 12px; border: 1px solid #e2e8f0; max-width: 880px; margin: 0 auto; }
        .form-label-profile { font-size: 0.9rem; font-weight: 500; color: #334155; margin-bottom: 0.4rem; }
        .form-control-profile { border-radius: 8px; border: 1px solid #cbd5e1; padding: 0.65rem 1rem; color: #1e293b; font-size: 0.95rem; background-color: #ffffff; width: 100%; box-sizing: border-box; }
        .form-control-profile:focus { border-color: #1a365d; box-shadow: 0 0 0 2px rgba(26, 54, 93, 0.1); outline: none; }
        .btn-cancel-profile { border: 1px solid #cbd5e1; background-color: #ffffff; color: #475569; font-weight: 500; padding: 0.6rem 1.75rem; border-radius: 8px; transition: all 0.2s; text-decoration: none; }
        .btn-cancel-profile:hover { background-color: #f8fafc; color: #1e293b; }
        .btn-save-profile { background-color: #1a365d; color: #ffffff; font-weight: 500; padding: 0.6rem 1.75rem; border-radius: 8px; border: none; transition: background-color 0.2s; }
        .btn-save-profile:hover { background-color: #112542; }
        .text-micro { font-size: 0.75rem; }
    </style>
</head>
<body class="bg-page">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-white border-bottom py-2 mb-4">
    <div class="container-fluid px-4">
        <div class="row w-100 align-items-center m-0">
            <div class="col-4 d-flex justify-content-start p-0">
                <a class="navbar-brand d-flex align-items-center fw-bold text-navy-brand m-0" href="#">LockerHub</a>
            </div>
            <div class="col-4 d-flex justify-content-center p-0">
                <div class="d-none d-lg-flex gap-2">
                    <a href="${pageContext.request.contextPath}/views/alumno/inicio.jsp" class="nav-link-custom">Inicio</a>
                    <a href="#" class="nav-link-custom active">Perfil</a>
                </div>
            </div>
            <div class="col-4 d-flex justify-content-end align-items-center p-0">
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

        <!-- Enlace Volver -->
        <div class="mb-3" style="max-width: 880px; margin: 0 auto;">
            <a href="${pageContext.request.contextPath}/views/alumno/inicio.jsp" class="text-decoration-none text-muted small fw-medium d-inline-flex align-items-center gap-1">
                <i class="bi bi-arrow-left"></i> Volver
            </a>
        </div>

        <!-- Manejo de Alertas (Éxito / Error) -->
        <div style="max-width: 880px; margin: 0 auto;">
            <%
                String mensaje = request.getParameter("mensaje");
                String error = request.getParameter("error");
                if ("exito".equals(mensaje)) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ¡Tu perfil ha sido actualizado correctamente!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } else if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> Hubo un problema al actualizar tu perfil. Verifica tu contraseña actual.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
        </div>

        <!-- Tarjeta Principal del Formulario -->
        <div class="card card-profile-edit p-4 mb-5 shadow-sm">
            <h4 class="fw-bold text-navy-brand mb-1 fs-5">Editar Información del Estudiante</h4>
            <p class="text-muted small mb-4">Mantén tus datos institucionales actualizados para facilitar la asignación de casilleros.</p>

            <form action="${pageContext.request.contextPath}/alumno/actualizarPerfil" method="POST">
                <div class="row g-4 mb-4">
                    <!-- Nombre Completo -->
                    <div class="col-md-6">
                        <div class="d-flex flex-column">
                            <label class="form-label-profile">Nombre completo</label>
                            <input type="text" class="form-control-profile" name="nombre" value="<%= nombre != null ? nombre : "" %>" required>
                        </div>
                    </div>

                    <!-- Matrícula -->
                    <div class="col-md-6">
                        <div class="d-flex flex-column">
                            <label class="form-label-profile">Matrícula</label>
                            <input type="text" class="form-control-profile" name="matricula" value="<%= matricula != null ? matricula : "" %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;" title="La matrícula no se puede cambiar">
                        </div>
                    </div>

                    <!-- Carrera -->
                    <div class="col-md-12">
                        <div class="d-flex flex-column">
                            <label class="form-label-profile">Carrera</label>
                            <!-- Sustituye getCarrera() por el método real de tu clase Alumno si se llama distinto -->
                            <input type="text" class="form-control-profile" name="carrera1" value="Ingeniería de Software">
                        </div>
                    </div>

                    <!-- Contraseña Actual -->
                    <div class="col-md-6">
                        <div class="d-flex flex-column">
                            <label class="form-label-profile">Contraseña Actual</label>
                            <input type="password" class="form-control-profile" name="passwordActual" placeholder="Requerida para guardar cambios" required>
                        </div>
                    </div>

                    <!-- Contraseña Nueva -->
                    <div class="col-md-6">
                        <div class="d-flex flex-column">
                            <label class="form-label-profile">Nueva Contraseña</label>
                            <input type="password" class="form-control-profile" name="passwordNueva" placeholder="Déjalo en blanco si no deseas cambiarla">
                        </div>
                    </div>
                </div>

                <hr class="text-muted opacity-25 mb-4">

                <!-- Botones de Acción -->
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/views/alumno/inicio.jsp" class="btn btn-cancel-profile">Cancelar</a>
                    <button type="submit" class="btn btn-save-profile">Guardar Cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>

<footer class="bg-white border-top py-3" style="margin-top: 4rem;">
    <div class="container-fluid px-4 d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
        <span class="text-muted-light text-micro">© 2026 LockerHub University Systems. All rights reserved.</span>
        <div class="d-flex gap-4 text-micro">
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Privacy Policy</a>
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Terms of Service</a>
            <a href="#" class="text-muted-dark text-decoration-none fw-medium">Support</a>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>