document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("form");
    const container = document.querySelector(".register-container");

    form.addEventListener("submit", (e) => {
        // Simulamos la validación nativa de Bootstrap
        if (!form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();

            // Evitamos duplicar la alerta si ya existe
            if (!document.querySelector(".alert-danger-custom")) {
                const alertHtml = `
                    <div class="alert alert-danger-custom d-flex align-items-center justify-content-center gap-2 p-3 mb-4 rounded-3" 
                         style="background-color: #fce8e6; border: none; color: #c5221f; font-size: 0.85rem; font-weight: 500;">
                        <i class="bi bi-exclamation-circle-fill fs-6"></i>
                        <span>Por favor, corrige los errores en el formulario.</span>
                    </div>
                `;
                // Inserta la alerta justo al inicio del contenedor (arriba del título)
                container.insertAdjacentHTML("afterbegin", alertHtml);
            }
        }

        form.classList.add("was-validated");
    }, false);

    // Lógica opcional para cambiar el icono de ver/ocultar contraseña
    const togglePassword = document.querySelector(".end-icon");
    const passwordInput = document.querySelector("input[type='password']");

    if (togglePassword && passwordInput) {
        togglePassword.addEventListener("click", () => {
            const icon = togglePassword.querySelector("i");
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                icon.classList.replace("bi-eye", "bi-eye-slash");
            } else {
                passwordInput.type = "password";
                icon.classList.replace("bi-eye-slash", "bi-eye");
            }
        });
    }
});