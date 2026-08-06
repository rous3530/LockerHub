/**
 * Lógica de interacción para la vista de Solicitudes (Admin)
 */

let estudianteSeleccionadoId = null;

/**
 * Muestra el Modal de Confirmación para Rechazar
 */
function confirmarRechazo(matricula, nombreEstudiante) {
    estudianteSeleccionadoId = matricula;

    // Actualizar texto del modal con el nombre correspondiente
    const titleElement = document.getElementById('modalRechazarTitle');
    if (titleElement) {
        titleElement.innerText = "¿Estás seguro de RECHAZAR a ${nombreEstudiante}?";
    }

    // Mostrar modal mediante Bootstrap JS API
    const modalElement = document.getElementById('modalRechazar');
    const modalInstance = new bootstrap.Modal(modalElement);
    modalInstance.show();
}

// Configurar evento de click en el botón "RECHAZAR" dentro del Modal
document.addEventListener('DOMContentLoaded', () => {
    const btnConfirmar = document.getElementById('btnConfirmarRechazo');
    if (btnConfirmar) {
        btnConfirmar.addEventListener('click', () => {
            if (estudianteSeleccionadoId) {
                ejecutarAccionRechazo(estudianteSeleccionadoId);
            }
        });
    }
});

/**
 * Elimina la fila de la tabla tras confirmar rechazo
 */
function ejecutarAccionRechazo(matricula) {
    // Cerrar modal
    const modalElement = document.getElementById('modalRechazar');
    const modalInstance = bootstrap.Modal.getInstance(modalElement);
    if (modalInstance) {
        modalInstance.hide();
    }

    // Ocultar la fila procesada
    const row = document.getElementById(row-${matricula});
    if (row) {
        row.remove();
    }

    verificarEstadoTabla();
}

/**
 * Pre-aprueba a un estudiante y despliega la alerta verde de éxito
 */
function preAprobar(matricula, nombreEstudiante) {
    // 1. Mostrar la alerta de éxito verde arriba
    const alertSuccess = document.getElementById('alertSuccess');
    const alertMessage = document.getElementById('alertSuccessMessage');

    if (alertSuccess && alertMessage) {
        alertMessage.innerText = Estudiante ${nombreEstudiante} agregado a pre-aprobados exitosamente;
        alertSuccess.classList.remove('d-none');

        // Auto ocultar después de 4 segundos
        setTimeout(() => {
            cerrarAlertaExito();
        }, 4000);
    }

    // 2. Remover la fila de la tabla
    const row = document.getElementById(row-${matricula});
    if (row) {
        row.remove();
    }

    verificarEstadoTabla();
}

/**
 * Cierra manualmente la alerta verde
 */
function cerrarAlertaExito() {
    const alertSuccess = document.getElementById('alertSuccess');
    if (alertSuccess) {
        alertSuccess.classList.add('d-none');
    }
}

/**
 * Evalúa si quedan filas en la tabla; si está vacía muestra el Empty State
 */
function verificarEstadoTabla() {
    const tableBody = document.getElementById('tableBody');
    const emptyState = document.getElementById('emptyState');
    const filasVisibles = tableBody.querySelectorAll('.table-row');

    if (filasVisibles.length === 0) {
        if (emptyState) emptyState.classList.remove('d-none');
    }
}

/**
 * Filtro de búsqueda rápida en la tabla
 */
function filtrarTabla() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('#tableBody .table-row');

    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        if (text.includes(input)) {
            row.style.display = 'flex';
        } else {
            row.style.display = 'none';
        }
    });
}