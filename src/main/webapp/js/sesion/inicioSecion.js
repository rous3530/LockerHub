document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("loginForm");
    const container = document.querySelector(".login-container");
    const inputs = form.querySelectorAll("input");

    // 1. Escuchar cuando el usuario escribe para limpiar la alerta y el estado verde
    inputs.forEach(input => {
        input.addEventListener("input", () => {
            // Elimina la alerta roja superior si el usuario empieza a corregir los campos
            const alert = document.querySelector(".alert-danger-custom");
            if (alert) {
                alert.remove();
            }

            // Quitamos temporalmente la validación forzada para que no se pongan verdes
            // mientras el usuario está escribiendo después de un error de credenciales
            input.classList.remove("is-invalid");
            form.classList.remove("was-validated");
        });
    });

    if (form && container) {
        form.addEventListener("submit", (e) => {
            e.preventDefault(); // Prevenimos el comportamiento por defecto

            // 2. Validar estructura básica (Campos vacíos o emails mal estructurados)
            if (!form.checkValidity()) {
                e.stopPropagation();
                form.classList.add("was-validated");
                mostrarAlerta("Por favor, rellena todos los campos correctamente o su correo o contraseña estan mal.");
                return;
            }

            // 3. Capturamos los valores reales ingresados
            const emailInput = form.querySelector("input[type='email']");
            const passwordInput = form.querySelector("input[type='password']");

            const emailValue = emailInput.value.toLowerCase();
            const passwordValue = passwordInput.value;

            // ==========================================================================
            // SIMULACIÓN DE CREDENCIALES (Simula tu base de datos)
            // ==========================================================================
            const usuarioValido = (emailValue === "20253ds091@utez.edu.mx" && passwordValue === "123456");
            const adminValido = (emailValue === "admin@utez.edu.mx" && passwordValue === "admin123");

            if (usuarioValido) {
                // Sesión de Alumno Correcta
                window.location.href = "../../views/alumno/index.html";
            } else if (adminValido) {
                // Sesión de Administrador Correcta
                window.location.href = "../../../../../../../../../Downloads/Locker/LockerHub/views/admin/admin.html";
            } else {
                // CREDENCIALES INCORRECTAS: Forzar el color ROJO visual en los campos
                e.stopPropagation();

                // Quitamos la clase general de Bootstrap para que no use sus checks verdes
                form.classList.remove("was-validated");

                // Forzamos manualmente el estado inválido (Rojo) en ambos inputs
                inputs.forEach(input => {
                    input.classList.add("is-invalid");
                });

                // Mostramos el banner de error superior
                mostrarAlerta("Correo o contraseña incorrectos. Por favor, inténtalo de nuevo.");
            }
        }, false);
    }

    // Función auxiliar para renderizar el banner superior sin duplicarlo
    function mostrarAlerta(mensaje) {
        if (!document.querySelector(".alert-danger-custom")) {
            const alertHtml = `
                <div class="alert alert-danger-custom d-flex align-items-center justify-content-center gap-2 p-3 mb-4 rounded-3" 
                     style="background-color: #fce8e6; border: none; color: #c5221f; font-size: 0.85rem; font-weight: 500;">
                    <i class="bi bi-exclamation-circle-fill fs-6 flex-shrink-0"></i>
                    <span class="text-start">${mensaje}</span>
                </div>
            `;
            container.insertAdjacentHTML("afterbegin", alertHtml);
        }
    }
});