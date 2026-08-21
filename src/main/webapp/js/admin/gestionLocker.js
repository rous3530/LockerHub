// Obtener el contextPath globalmente si se define en la página, o usar vacío
const contextPath = window.contextPath || '';

document.addEventListener('DOMContentLoaded', function () {
    // Inicializar filtros al cargar la página si es necesario
    aplicarFiltros();
});

/**
 * Filtra las tarjetas de casilleros según el texto de búsqueda, el edificio y el piso seleccionados.
 */
function aplicarFiltros() {
    const inputBusqueda = document.getElementById('inputBuscarCasillero').value.toLowerCase().trim();
    const selectEdificio = document.getElementById('selectEdificio').value.toLowerCase();
    const selectPiso = document.getElementById('selectPiso').value.toLowerCase();

    const tarjetas = document.querySelectorAll('.card-locker');
    let contadorVisibles = 0;
    let totalActivos = tarjetas.length;

    tarjetas.forEach(tarjeta => {
        const codigo = tarjeta.getAttribute('data-codigo').toLowerCase();
        const edificio = tarjeta.getAttribute('data-edificio').toLowerCase();
        const piso = tarjeta.getAttribute('data-piso').toLowerCase();

        // Validar coincidencias
        const coincideTexto = codigo.includes(inputBusqueda);

        // Si el select está vacío (opción "Todos"), coincide por defecto; de lo contrario, evalúa coincidencia exacta
        const coincideEdificio = !selectEdificio || edificio === selectEdificio;
        const coincidePiso = !selectPiso || piso === selectPiso;

        if (coincideTexto && coincideEdificio && coincidePiso) {
            tarjeta.style.display = 'block';
            contadorVisibles++;
        } else {
            tarjeta.style.display = 'none';
        }
    });

    // Actualizar el texto del contador inferior dinámicamente
    const textTotalMostrados = document.getElementById('textTotalMostrados');
    if (textTotalMostrados) {
        textTotalMostrados.innerText = `Mostrando ${contadorVisibles} de ${totalActivos} casilleros disponibles`;
    }
}

// Funciones de acción para los botones de las tarjetas
function verDetalles(codigo) {
    alert(`Visualizando detalles del casillero disponible: ${codigo}`);
}

function gestionarCasillero(codigo) {
    alert(`Abriendo panel de gestión para el casillero ocupado: ${codigo}`);
}

function verEstadoMantenimiento(codigo) {
    alert(`Consultando reporte técnico del casillero en mantenimiento: ${codigo}`);
}