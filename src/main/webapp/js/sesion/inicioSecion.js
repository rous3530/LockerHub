document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("loginForm");
    const alertContainer = document.getElementById("alertContainer");
    const inputs = form ? form.querySelectorAll("input") : [];

    if (form) {
        // Limpiar mensajes y estados de error al escribir
        inputs.forEach(input => {
            input.addEventListener("input", () => {
                input.classList.remove("is-invalid");
                limpiarAlertaLocal();
            });
        });

        // Validar únicamente campos vacíos o sin formato correcto antes de enviar al Servlet
        form.addEventListener("submit", (e) => {
            limpiarAlertaLocal();

            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();

                // Aplica clases nativas de Bootstrap para mostrar la retroalimentación
                form.classList.add("was-validated");
                mostrarAlerta("Por favor, llena todos los campos requeridos.");
            }
            // Si form.checkValidity() es true, continúa con el POST hacia el Servlet.
        });
    }

    function mostrarAlerta(mensaje) {
        if (alertContainer && !document.querySelector(".alert-danger-custom")) {
            const alertHtml = `
                <div class="alert alert-danger-custom alert-danger d-flex align-items-center justify-content-center gap-2 p-3 mb-4 rounded-3 small fw-semibold">
                    <i class="bi bi-exclamation-circle-fill fs-6 flex-shrink-0"></i>
                    <span>${mensaje}</span>
                </div>
            `;
            alertContainer.innerHTML = alertHtml;
        }
    }

    function limpiarAlertaLocal() {
        if (alertContainer) {
            alertContainer.innerHTML = "";
        }
    }
});