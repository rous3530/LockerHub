document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("form");
    const container = document.querySelector(".recover-container");

    form.addEventListener("submit", (e) => {
        if (!form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();

            if (!document.querySelector(".alert-danger-custom")) {
                const alertHtml = `
                    <div class="alert alert-danger-custom d-flex align-items-center justify-content-center gap-2 p-3 mb-4 rounded-3" 
                         style="background-color: #fce8e6; border: none; color: #c5221f; font-size: 0.85rem; font-weight: 500;">
                        <i class="bi bi-exclamation-circle-fill fs-6"></i>
                        <span>Error al procesar la solicitud.</span>
                    </div>
                `;
                container.insertAdjacentHTML("afterbegin", alertHtml);
            }
        }
        form.classList.add("was-validated");
    }, false);
});