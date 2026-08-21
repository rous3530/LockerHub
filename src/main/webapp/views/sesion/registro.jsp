<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="mx.edu.utez.locker.dao.DaoCarrera" %>
<%@ page import="mx.edu.utez.locker.model.Carrera" %>
<%@ page import="java.util.List" %>
<%
    DaoCarrera daoCarrera = new DaoCarrera();
    List<Carrera> listaCarreras = daoCarrera.obtenerTodas();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LockerHub - Registro</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css">
</head>
<body class="bg-light" style="min-height: 100vh; display: flex; flex-direction: column;">

<nav class="navbar navbar-dark bg-navy py-2 shadow-sm">
    <div class="container d-flex align-items-center justify-content-between">
        <a class="navbar-brand fw-bold fs-5 mb-0" href="#">LockerHub</a>
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-white text-decoration-none small opacity-75">Inicio</a>
            <a href="${pageContext.request.contextPath}/views/sesion/registro.jsp" class="text-white text-decoration-underline small fw-bold">Registro</a>
        </div>
    </div>
</nav>

<div class="container d-flex flex-grow-1 justify-content-center align-items-center py-5">
    <div class="register-container p-5 shadow-sm text-center" style="max-width: 500px; width: 100%;">

        <h2 class="fw-bold text-navy h3 mb-2">Registro</h2>
        <p class="text-muted small mb-4">Crea tu cuenta institucional para gestionar tus lockers.</p>

        <!-- Mensajes de feedback según status de la URL -->
        <% if ("error".equals(request.getParameter("status"))) { %>
        <div class="alert alert-danger d-flex align-items-center justify-content-center gap-2 p-3 mb-4 rounded-3 small fw-semibold">
            <i class="bi bi-exclamation-circle-fill fs-6"></i>
            <span>Ocurrió un error al registrar la cuenta. Intenta de nuevo.</span>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/registro-alumno" method="POST" id="formRegistro" novalidate>

            <!-- Matrícula -->
            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Matrícula</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                    <input type="text"
                           name="matricula"
                           id="inputMatricula"
                           class="form-control"
                           placeholder="Ej. 20253ds001"
                           maxlength="10"
                           minlength="10"
                           pattern="^[a-zA-Z0-9]{10}$"
                           title="La matrícula debe contener exactamente 10 caracteres alfanuméricos"
                           required>
                    <div class="invalid-feedback">La matrícula debe tener exactamente 10 caracteres alfanuméricos (sin símbolos ni espacios).</div>
                </div>
            </div>

            <!-- Nombres -->
            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Nombre(s)</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text"
                           name="nombres"
                           id="inputNombres"
                           class="form-control solo-letras"
                           placeholder="Ej. Juan"
                           pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$"
                           title="Ingresa solo letras y espacios"
                           required>
                    <div class="invalid-feedback">Solo se permiten letras y espacios en este campo.</div>
                </div>
            </div>

            <!-- Apellido Paterno -->
            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Apellido Paterno</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text"
                           name="apellidoPaterno"
                           id="inputApellidoPaterno"
                           class="form-control solo-letras"
                           placeholder="Pérez"
                           pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$"
                           title="Ingresa solo letras y espacios"
                           required>
                    <div class="invalid-feedback">Solo se permiten letras y espacios en este campo.</div>
                </div>
            </div>

            <!-- Apellido Materno -->
            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Apellido Materno</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text"
                           name="apellidoMaterno"
                           id="inputApellidoMaterno"
                           class="form-control solo-letras"
                           placeholder="Gómez"
                           pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]*$"
                           title="Ingresa solo letras y espacios">
                    <div class="invalid-feedback">Solo se permiten letras y espacios en este campo.</div>
                </div>
            </div>

            <!-- Carrera -->
            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Carrera</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-journal-bookmark"></i></span>
                    <select name="idCarrera" class="form-select" required>
                        <option value="" disabled selected>Selecciona tu carrera</option>
                        <% if (listaCarreras != null) {
                            for (Carrera carrera : listaCarreras) { %>
                        <option value="<%= carrera.getIdCarrera() %>"><%= carrera.getNombre() %></option>
                        <%  }
                        } %>
                    </select>
                    <div class="invalid-feedback">Selecciona una carrera de la lista.</div>
                </div>
            </div>

            <!-- Correo Institucional -->
            <div class="text-start mb-3">
                <label class="form-label text-secondary small fw-semibold mb-1">Correo Institucional</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-at"></i></span>
                    <input type="text"
                           name="correo"
                           class="form-control"
                           placeholder="usuario@utez.edu.mx"
                           pattern="^[a-zA-Z0-9._%+-]+@utez\.edu\.mx$"
                           title="Debe ser un correo institucional que termine en @utez.edu.mx"
                           required>
                    <div class="invalid-feedback">El correo debe terminar strictly con @utez.edu.mx.</div>
                </div>
            </div>

            <!-- Contraseña -->
            <div class="text-start mb-4">
                <label class="form-label text-secondary small fw-semibold mb-1">Contraseña</label>
                <div class="input-group custom-input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" id="inputContrasena" name="contrasena" class="form-control has-end-icon" placeholder="••••••••" required minlength="8" pattern="(?=.*\d)(?=.*[A-Za-z]).{8,}" title="Debe contener al menos 8 caracteres, una letra y un número">
                    <span class="input-group-text end-icon" id="togglePassword" style="cursor: pointer;"><i class="bi bi-eye"></i></span>
                    <div class="invalid-feedback">La contraseña debe tener al menos 8 caracteres, incluir letras y números.</div>
                </div>
            </div>

            <button type="submit" class="btn btn-navy w-100 py-2.5 fw-semibold d-flex align-items-center justify-content-center gap-2 mb-4 rounded-3">
                Registrarse <i class="bi bi-arrow-right fs-5"></i>
            </button>

            <hr class="text-muted opacity-25 my-4">

            <p class="mb-0 small text-secondary">
                ¿Ya tienes una cuenta? <a href="${pageContext.request.contextPath}/views/sesion/IniciarSesion.jsp" class="text-navy fw-bold text-decoration-none">Inicia sesión aquí</a>
            </p>
        </form>

    </div>
</div>

<footer class="bg-white py-4 border-top mt-auto">
    <div class="container text-muted" style="font-size: 0.75rem;">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                <span class="fw-semibold text-dark">LockerHub</span> &nbsp; | &nbsp; <a href="#" class="text-muted text-decoration-none">Privacy Policy</a> &nbsp; <a href="#" class="text-muted text-decoration-none">Terms of Service</a> &nbsp; <a href="#" class="text-muted text-decoration-none">Help Center</a>
            </div>
            <div class="col-md-6 text-center text-md-end">
                © 2026 LockerHub University Services
            </div>
        </div>
    </div>
</footer>

<%
    String error = request.getParameter("error");
    if ("sin_permiso".equals(error)) {
%>
<div class="alert alert-danger alert-dismissible fade show text-center py-2 small" role="alert">
    <i class="bi bi-exclamation-triangle-fill me-1"></i> No tienes permiso para ver esta página. Inicia sesión para continuar.
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<%
    }
%>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/sesion/registro.js"></script>

<!-- Script de filtrado dinámico para Matrícula -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const inputMatricula = document.getElementById('inputMatricula');
        if (inputMatricula) {
            inputMatricula.addEventListener('input', function () {
                // Elimina símbolos/espacios y restringe a un máximo de 10 caracteres
                this.value = this.value.replace(/[^a-zA-Z0-9]/g, '').slice(0, 10);
            });
        }
    });
</script>
</body>
</html>