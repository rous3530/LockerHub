document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("loginForm");
    // CORRECCIÓN: Ahora busca la clase correcta que tienes en tu JSP
    const container = document.querySelector(".register-container");
    const inputs = form ? form.querySelectorAll("input") : [];

    if (form && container) {

        // 1. Escuchar cuando el usuario escribe para limpiar alertas y estados de error
        inputs.forEach(input => {
            input.addEventListener("input", () => {
                // Elimina la alerta roja superior si existe
                const alert = document.querySelector(".alert-danger-custom");
                if (alert) {
                    alert.remove();
                }

                // Quitamos el estado inválido al escribir
                input.classList.remove("is-invalid");
                form.classList.remove("was-validated");
            });
        });

        // 2. Manejador de Submit
        form.addEventListener("submit", (e) => {
            e.preventDefault(); // Evitamos que recargue la página

            // Limpiar alertas previas para evitar duplicidad
            const alertPrevio = document.querySelector(".alert-danger-custom");
            if (alertPrevio) {
                alertPrevio.remove();
            }

            // Validar estructura básica (HTML5 Validation)
            if (!form.checkValidity()) {
                e.stopPropagation();
                form.classList.add("was-validated");
                mostrarAlerta("Por favor, rellena todos los campos requeridos correctamente.");
                return;
            }

            // 3. Capturamos los valores reales de los inputs
            const emailInput = form.querySelector("input[type='email']");
            const passwordInput = form.querySelector("input[type='password']");

            if (!emailInput || !passwordInput) return;

            const emailValue = emailInput.value.trim().toLowerCase();
            const passwordValue = passwordInput.value;

            // SIMULACIÓN DE CREDENCIALES
            const usuarioValido = (emailValue === "20253ds091@utez.edu.mx" && passwordValue === "123456");
            const adminValido = (emailValue === "admin@utez.edu.mx" && passwordValue === "admin123");

            if (usuarioValido) {
                // Sesión de Alumno - Redirige a la vista correspondiente
                window.location.href = "/Locker_war_exploded/views/alumno/inicio.jsp";
            } else if (adminValido) {
                // Sesión de Administrador
                window.location.href = "/Locker_war_exploded/views/admin/inicio.jsp";
            } else {
                // CREDENCIALES INCORRECTAS
                e.stopPropagation();
                form.classList.remove("was-validated");

                // Forzamos manualmente el estado inválido (Rojo) en los inputs
                inputs.forEach(input => {
                    input.classList.add("is-invalid");
                });

                // Mostramos el banner de error superior
                mostrarAlerta("Correo o contraseña incorrectos. Por favor, inténtalo de nuevo.");
            }
        });
    } else {
        console.error("No se encontró el formulario (#loginForm) o el contenedor (.register-container) en el DOM.");
    }

    // Función auxiliar para renderizar el banner superior sin duplicarlo
    function mostrarAlerta(mensaje) {
        if (!document.querySelector(".alert-danger-custom") && container) {
            const alertHtml = `
                <div class="alert alert-danger-custom d-flex align-items-center justify-content-center gap-2 p-3 mb-4 rounded-3" 
                     style="background-color: #fce8e6; border: none; color: #c5221f; font-size: 0.85rem; font-weight: 500; width: 100%;">
                    <i class="bi bi-exclamation-circle-fill fs-6 flex-shrink-0"></i>
                    <span class="text-start">${mensaje}</span>
                </div>
            `;
            // Insertar el banner al principio de la tarjeta
            container.insertAdjacentHTML("afterbegin", alertHtml);
        }
    }
});