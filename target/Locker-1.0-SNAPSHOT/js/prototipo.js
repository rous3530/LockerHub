document.getElementById('btnIniciarSesion').addEventListener('click', function(event) {
    // Previene que la página se recargue por el comportamiento del formulario
    event.preventDefault();

    // Aquí en el futuro verificarás el correo y contraseña...

    // Redirecciona a la vista de administrador
    window.location.href = "../admin/admin.html";
});