// Estado global del modal de reporte
let estudianteSeleccionado = {
    id: null,
    nombre: ''
};

// 1. Buscador en tiempo real adaptado a la estructura de filas
function filtrarTablaAceptados() {
    const input = document.getElementById('searchInput').value.toLowerCase().trim();
    const rows = document.querySelectorAll('.item-row');
    let visibles = 0;

    rows.forEach(row => {
        const nombre = row.querySelector('.student-name') ? row.querySelector('.student-name').innerText.toLowerCase() : '';
        const matricula = row.querySelector('.student-matricula') ? row.querySelector('.student-matricula').innerText.toLowerCase() : '';

        if (nombre.includes(input) || matricula.includes(input)) {
            row.style.display = 'flex';
            visibles++;
        } else {
            row.style.display = 'none';
        }
    });

    // Control de estado vacío (si no hay coincidencias)
    const emptyState = document.getElementById('emptyState');
    if (emptyState) {
        if (visibles === 0) {
            emptyState.classList.remove('d-none');
        } else {
            emptyState.classList.add('d-none');
        }
    }
}

// 2. Apertura del Modal de Reporte
function abrirModalReporte(idEstudiante, nombreEstudiante) {
    estudianteSeleccionado.id = idEstudiante;
    estudianteSeleccionado.nombre = nombreEstudiante;

    // Actualizar elementos del DOM en el modal
    document.getElementById('modalEstudianteId').value = idEstudiante;
    document.getElementById('modalEstudianteNombre').innerText = nombreEstudiante;
    document.getElementById('textoReporte').value = ''; // Limpiar campo previo

    // Mostrar modal usando la instancia de Bootstrap configurada en el JSP
    if (typeof modalReporteInstance !== 'undefined' && modalReporteInstance !== null) {
        modalReporteInstance.show();
    } else {
        const modal = document.getElementById('modalReporte');
        if (modal) modal.style.display = 'flex';
    }
}

// 3. Cierre del Modal
function cerrarModalReporte() {
    if (typeof modalReporteInstance !== 'undefined' && modalReporteInstance !== null) {
        modalReporteInstance.hide();
    } else {
        const modal = document.getElementById('modalReporte');
        if (modal) modal.style.display = 'none';
    }
}

// 4. Envío de Formulario / Adjuntar Reporte al Backend
function adjuntarReporte(event) {
    event.preventDefault();

    const id = document.getElementById('modalEstudianteId').value;
    const reporteTexto = document.getElementById('textoReporte').value.trim();

    if (!reporteTexto) {
        alert('Por favor, escribe un motivo o detalle para el reporte.');
        return;
    }

    const payload = {
        estudianteId: id,
        reporte: reporteTexto
    };

    console.log('Enviando reporte al servidor:', payload);

    // Petición AJAX (Fetch) lista para conectar con el Servlet / Controlador Java
    /*
    fetch('/api/aceptados/adjuntar-reporte', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(payload)
    })
    .then(response => {
        if (response.ok) {
            cerrarModalReporte();
            alert('Reporte adjuntado correctamente.');
        } else {
            alert('Error al adjuntar el reporte.');
        }
    })
    .catch(error => console.error('Error:', error));
    */

    // Simulación de respuesta exitosa con interpolación correcta (comillas invertidas)
    cerrarModalReporte();
    alert(`Reporte adjuntado con éxito a ${estudianteSeleccionado.nombre}.`);
}

// Cierre de modal al hacer clic en el backdrop oscuro
window.onclick = function(event) {
    const modal = document.getElementById('modalReporte');
    if (event.target === modal) {
        cerrarModalReporte();
    }
};