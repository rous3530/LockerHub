// Estado global del flujo
let estadoSeleccion = {
    estudianteId: null,
    casilleroId: null,
    casilleroCodigo: null
};

// Datos simulados de casilleros para la prueba modal
const casillerosSimulados = [
    { id: 101, codigo: 'A-042', edificio: 'Edif. A', piso: 'PB', estado: 'Disponible' },
    { id: 102, codigo: 'A-045', edificio: 'Edif. A', piso: 'PB', estado: 'Disponible' },
    { id: 103, codigo: 'B-102', edificio: 'Edif. B', piso: 'Piso 1', estado: 'Mantenimiento' },
    { id: 104, codigo: 'A-055', edificio: 'Edif. A', piso: 'Piso 1', estado: 'Ocupado' }
];

// 1. Buscador en la tabla principal
function filtrarTabla() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('#preAceptadosTable tbody tr');

    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        row.style.display = text.includes(input) ? '' : 'none';
    });
}

// 2. Modales: Apertura y Cierre
function abrirModal(idModal) {
    document.getElementById(idModal).style.display = 'flex';
}

function cerrarModal(idModal) {
    document.getElementById(idModal).style.display = 'none';
}

// 3. Modal Asignar Casillero
function abrirModalAsignar(id, nombre, matricula, carrera) {
    estadoSeleccion.estudianteId = id;
    estadoSeleccion.casilleroId = null;
    estadoSeleccion.casilleroCodigo = null;

    document.getElementById('modalEstudianteNombre').innerText = nombre;
    document.getElementById('modalEstudianteMatricula').innerText = matricula;
    document.getElementById('modalEstudianteCarrera').innerText = carrera;
    document.getElementById('lockerSeleccionadoTexto').innerText = 'Ninguno';
    document.getElementById('btnConfirmarAsignacion').disabled = true;

    renderizarLockers(casillerosSimulados);
    abrirModal('modalAsignar');
}

function renderizarLockers(lockers) {
    const grid = document.getElementById('lockersGrid');
    grid.innerHTML = '';

    lockers.forEach(l => {
        const card = document.createElement('div');
        card.className = locker-card ${l.estado.toLowerCase()};
        card.innerHTML = `
            <strong>${l.codigo}</strong>
            <small>${l.edificio}, ${l.piso}</small>
            <span class="status-tag">${l.estado}</span>
        `;

        if (l.estado === 'Disponible') {
            card.onclick = () => seleccionarLocker(card, l);
        }

        grid.appendChild(card);
    });
}

function seleccionarLocker(element, locker) {
    document.querySelectorAll('.locker-card').forEach(c => c.classList.remove('selected'));
    element.classList.add('selected');

    estadoSeleccion.casilleroId = locker.id;
    estadoSeleccion.casilleroCodigo = locker.codigo;

    document.getElementById('lockerSeleccionadoTexto').innerText = locker.codigo;
    document.getElementById('btnConfirmarAsignacion').disabled = false;
}

function filtrarLockersModal() {
    const busqueda = document.getElementById('buscarLockerInput').value.toLowerCase();
    const edificio = document.getElementById('filtroEdificio').value;
    const piso = document.getElementById('filtroPiso').value;

    const filtrados = casillerosSimulados.filter(l => {
        const coincideCodigo = l.codigo.toLowerCase().includes(busqueda);
        const coincideEdificio = !edificio || l.edificio === edificio;
        const coincidePiso = !piso || l.piso === piso;
        return coincideCodigo && coincideEdificio && coincidePiso;
    });

    renderizarLockers(filtrados);
}

function confirmarSeleccionLocker() {
    cerrarModal('modalAsignar');
    mostrarAlerta({
        icono: 'ℹ️',
        titulo: 'Confirmar Asignación',
        mensaje: ¿Estás seguro de asignar el casillero ${estadoSeleccion.casilleroCodigo}?,
        botones: `
            <button class="btn btn-secondary" onclick="cerrarModal('modalAlerta')">Cancelar</button>
            <button class="btn btn-primary" onclick="guardarAsignacionBackend()">Confirmar Asignación</button>
        `
});
}

// 4. Modal Quitar Casillero
function abrirModalQuitarCasillero(id, nombre, casillero) {
    mostrarAlerta({
        icono: '🗑️',
        titulo: '¿Estás seguro de quitar el casillero?',
        mensaje: ¿Estás seguro de quitar la asignación del casillero ${casillero} a ${nombre}? Esta acción dejará el casillero disponible.,
        botones: `
            <button class="btn btn-secondary" onclick="cerrarModal('modalAlerta')">Cancelar</button>
            <button class="btn btn-danger" onclick="ejecutarQuitarCasillero('${id}')">Confirmar</button>
        `
});
}

// 5. Modal Quitar de Lista
function abrirModalQuitarLista(id, nombre) {
    mostrarAlerta({
        icono: '⚠️',
        titulo: ¿Estás seguro de quitar a ${nombre}?,
        mensaje: 'Al quitar esta solicitud ya no se visualizará en el listado de Pre-aceptados.',
        botones: `
            <button class="btn btn-secondary" onclick="cerrarModal('modalAlerta')">Regresar</button>
            <button class="btn btn-danger" onclick="ejecutarQuitarDeLista('${id}')">Quitar</button>
        `
});
}

// 6. Validación para "Aceptar Todos" (Casos Borde)
function intentarAceptarTodos() {
    // Ejemplo de validación: comprobar si hay filas con "Sin asignar"
    const sinAsignar = Array.from(document.querySelectorAll('#preAceptadosTable tbody tr'))
        .some(tr => tr.innerText.includes('Sin asignar'));

    if (sinAsignar) {
        mostrarAlerta({
            icono: '⚠️',
            titulo: 'Acción requerida',
            mensaje: 'Todos los estudiantes tienen que tener un casillero asignado para poder completar la aceptación masiva.',
            botones: <button class="btn btn-primary" onclick="cerrarModal('modalAlerta')">Entendido</button>
        });
        return;
    }

    mostrarAlerta({
        icono: '✅',
        titulo: '¿Estás seguro de ACEPTAR a todos los alumnos?',
        mensaje: 'Al confirmar esta acción, todos los estudiantes pre-aceptados serán movidos automáticamente a la lista de aceptados.',
        botones: `
            <button class="btn btn-secondary" onclick="cerrarModal('modalAlerta')">Regresar</button>
            <button class="btn btn-success" onclick="ejecutarAceptarTodosBackend()">Aceptar Todos</button>
        `
    });
}

// Helper para Renderizar Alertas Dinámicas
function mostrarAlerta({ icono, titulo, mensaje, botones }) {
    document.getElementById('alertaIcono').innerText = icono;
    document.getElementById('alertaTitulo').innerText = titulo;
    document.getElementById('alertaMensaje').innerText = mensaje;
    document.getElementById('alertaBotones').innerHTML = botones;
    abrirModal('modalAlerta');
}

// 7. Peticiones de actualización al backend (Servlets / Controllers)
function guardarAsignacionBackend() {
    cerrarModal('modalAlerta');
    // fetch('/api/pre-aceptados/asignar', { method: 'POST', body: JSON.stringify(estadoSeleccion) })...
    location.reload();
}

function ejecutarQuitarCasillero(idEstudiante) {
    cerrarModal('modalAlerta');
    // fetch(/api/pre-aceptados/quitar-casillero?id=${idEstudiante}, { method: 'DELETE' })...
    location.reload();
}

function ejecutarQuitarDeLista(idEstudiante) {
    cerrarModal('modalAlerta');
    // fetch(/api/pre-aceptados/eliminar?id=${idEstudiante}, { method: 'DELETE' })...
    location.reload();
}

function ejecutarAceptarTodosBackend() {
    cerrarModal('modalAlerta');
    // fetch('/api/pre-aceptados/aceptar-todos', { method: 'POST' })...
    location.reload();
}