// Funciones de acción para los botones de las tarjetas
// Obtener el contextPath globalmente si se define en la página, o usar vacío
const contextPath = window.contextPath || '';

document.addEventListener('DOMContentLoaded', function () {
    // Inicializar filtros al cargar la página si es necesario
    aplicarFiltros();
});

/**
 * Filtra las tarjetas de casilleros según el texto de búsqueda, el estado, el edificio y el piso seleccionados.
 */
function aplicarFiltros() {
    const inputBusqueda = document.getElementById('inputBuscarCasillero').value.toLowerCase().trim();
    const selectEstado = document.getElementById('selectEstado').value.toLowerCase();
    const selectEdificio = document.getElementById('selectEdificio').value.toLowerCase();
    const selectPiso = document.getElementById('selectPiso').value.toLowerCase();

    // Seleccionamos las tarjetas usando la clase correcta definida en tu JSP
    const tarjetas = document.querySelectorAll('.card-locker-wrapper');
    let contadorVisibles = 0;
    let totalActivos = tarjetas.length;

    tarjetas.forEach(tarjeta => {
        const codigo = tarjeta.getAttribute('data-codigo').toLowerCase();
        const edificio = tarjeta.getAttribute('data-edificio').toLowerCase();
        const piso = tarjeta.getAttribute('data-piso').toLowerCase();
        const estado = (tarjeta.getAttribute('data-estado') || '').toLowerCase();

        // Validar coincidencias
        const coincideTexto = codigo.includes(inputBusqueda);

        // Si el select está vacío (opción "Todos"), coincide por defecto
        const coincideEstado = !selectEstado || estado === selectEstado;
        const coincideEdificio = !selectEdificio || edificio === selectEdificio;
        const coincidePiso = !selectPiso || piso === selectPiso;

        if (coincideTexto && coincideEstado && coincideEdificio && coincidePiso) {
            tarjeta.style.display = 'block';
            contadorVisibles++;
        } else {
            tarjeta.style.display = 'none';
        }
    });

    // Actualizar el texto del contador inferior dinámicamente si existe el elemento
    const textTotalMostrados = document.getElementById('textTotalMostrados');
    if (textTotalMostrados) {
        textTotalMostrados.innerText = `Mostrando ${contadorVisibles} de ${totalActivos} casilleros disponibles`;
    }
}

/**
 * Abre el modal interactivo de gestión adaptado a los datos de la tarjeta seleccionada.
 */
function abrirModalGestion(codigo, edificio, piso, estado, nombreAlumno, matriculaAlumno) {
    console.log("--- ABRIENDO MODAL ---");
    console.log("Código:", codigo);
    console.log("Estado:", estado);
    console.log("Nombre Alumno:", nombreAlumno);
    console.log("Matrícula Alumno:", matriculaAlumno);

    // 1. Asignar textos básicos
    document.getElementById("modalCodigoCasillero").innerText = codigo;
    document.getElementById("inputCodigoCasillero").value = codigo;
    document.getElementById("modalEdificio").innerText = edificio;
    document.getElementById("modalPiso").innerText = piso;

    // 2. Gestionar la sección del alumno asignado
    const seccionAlumno = document.getElementById("seccionAlumno");

    if (estado && estado.toUpperCase() === "OCUPADO" && nombreAlumno && nombreAlumno !== "null" && nombreAlumno !== "Sin asignar" && nombreAlumno.trim() !== "") {
        document.getElementById("modalNombreAlumno").innerText = nombreAlumno;
        document.getElementById("modalMatriculaAlumno").innerText = matriculaAlumno;
        seccionAlumno.classList.remove("d-none"); // Muestra el cuadro
    } else {
        seccionAlumno.classList.add("d-none");    // Oculta el cuadro
    }

    document.getElementById("selectNuevoEstado").value = estado;

    // 3. Abrir el modal limpiando cualquier backdrop duplicado
    document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
    var modalElement = document.getElementById('modalGestionCasillero');
    var myModal = bootstrap.Modal.getOrCreateInstance(modalElement);
    myModal.show();
}

// Limpieza automática al cerrar
document.addEventListener('DOMContentLoaded', function () {
    const modalEl = document.getElementById('modalGestionCasillero');
    if (modalEl) {
        modalEl.addEventListener('hidden.bs.modal', function () {
            document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
            document.body.classList.remove('modal-open');
            document.body.style.removeProperty('overflow');
            document.body.style.removeProperty('padding-right');
        });
    }
});
// Actualizadas para leer correctamente los atributos de la tarjeta y respetar el orden de la función principal
function verDetalles(codigo) {
    const tarjeta = document.querySelector(`[data-codigo="${codigo}"]`);
    if (tarjeta) {
        abrirModalGestion(
            codigo,
            tarjeta.dataset.edificio,
            tarjeta.dataset.piso,
            tarjeta.dataset.estado,
            tarjeta.dataset.alumno,
            tarjeta.dataset.matricula
        );
    }
}

function gestionarCasillero(codigo) {
    verDetalles(codigo);
}

function verEstadoMantenimiento(codigo) {
    verDetalles(codigo);
}

/**
 * Libera el casillero del alumno actual cambiando su estado a DISPONIBLE y enviando el formulario.
 */
function liberarCasilleroAlumno() {
    if (confirm("¿Estás seguro de quitarle el casillero a este alumno? El casillero quedará disponible.")) {
        document.getElementById('selectNuevoEstado').value = 'DISPONIBLE';
        document.getElementById('formGestionCasillero').submit();
    }
}