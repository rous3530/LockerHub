// Estado global del modal de reporte
let estudianteSeleccionado = {
    id: null,
    nombre: ''
};

// 1. Buscador en tiempo real
function filtrarTablaAceptados() {
    const input = document.getElementById('searchInput').value.toLowerCase().trim();
    const rows = document.querySelectorAll('#aceptadosTable tbody tr');

    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        row.style.display = text.includes(input) ? '' : 'none';
    });
}

// 2. Apertura del Modal de Reporte
function abrirModalReporte(idEstudiante, nombreEstudiante) {
    estudianteSeleccionado.id = idEstudiante;
    estudianteSeleccionado.nombre = nombreEstudiante;

    // Actualizar elementos del DOM en el modal
    document.getElementById('modalEstudianteId').value = idEstudiante;
    document.getElementById('modalEstudianteNombre').innerText = nombreEstudiante;
    document.getElementById('textoReporte').value = ''; // Limpiar campo previo

    // Mostrar modal con flexbox
    const modal = document.getElementById('modalReporte');
    modal.style.display = 'flex';
}

// 3. Cierre del Modal
function cerrarModalReporte() {
    const modal = document.getElementById('modalReporte');
    modal.style.display = 'none';
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

    // Simulación de respuesta exitosa
    cerrarModalReporte();
    alert(Reporte adjuntado con éxito a ${estudianteSeleccionado.nombre}.);
}

// Cierre de modal al hacer clic en el backdrop oscuro
window.onclick = function(event) {
    const modal = document.getElementById('modalReporte');
    if (event.target === modal) {
        cerrarModalReporte();
    }
};