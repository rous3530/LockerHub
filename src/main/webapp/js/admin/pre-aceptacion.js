// Estado global del flujo
let estadoSeleccion = {
    estudianteId: null,
    casilleroId: null,
    casilleroCodigo: null
};

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

// 3. Modal Asignar Casillero (Modificado para cargar dinámicamente)
function abrirModalAsignar(id, nombre, matricula, carrera) {
    estadoSeleccion.estudianteId = id;
    estadoSeleccion.casilleroId = null;
    estadoSeleccion.casilleroCodigo = null;

    document.getElementById('modalEstudianteNombre').innerText = nombre;
    document.getElementById('modalEstudianteMatricula').innerText = matricula;
    document.getElementById('modalEstudianteCarrera').innerText = carrera;

    const labelSeleccionado = document.getElementById('lblSeleccionado');
    if (labelSeleccionado) labelSeleccionado.innerText = 'Ninguno';

    const lockerTexto = document.getElementById('lockerSeleccionadoTexto');
    if (lockerTexto) lockerTexto.innerText = 'Ninguno';

    const btnConfirmar = document.getElementById('btnConfirmarAsignacion');
    if (btnConfirmar) btnConfirmar.disabled = true;

    // Limpiar inputs de filtro al abrir
    document.getElementById('buscarLockerInput').value = '';
    document.getElementById('filtroEdificio').value = '';
    document.getElementById('filtroPiso').value = '';

    // Cargar todos los lockers disponibles inicialmente o limpiar la grid
    const grid = document.getElementById('lockersGrid');
    grid.innerHTML = '<div class="text-center text-muted p-4 w-100">Selecciona un edificio para ver los casilleros disponibles.</div>';

    abrirModal('modalAsignar');
}

// Función que consulta al Servlet por Edificio vía Fetch
const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

function filtrarLockersModal() {
    const idEdificio = document.getElementById('filtroEdificio').value;
    const busqueda = document.getElementById('buscarLockerInput').value.toLowerCase();
    const plantaSeleccionada = document.getElementById('filtroPiso').value;
    const grid = document.getElementById('lockersGrid');

    if (!idEdificio) {
        grid.innerHTML = '<div class="text-center text-muted p-4 w-100">Selecciona un edificio.</div>';
        return;
    }

    grid.innerHTML = '<div class="text-center text-muted p-4 w-100">Cargando casilleros...</div>';

    fetch(`${contextPath}/obtener-lockers?idEdificio=${idEdificio}`)
        .then(response => response.json())
        .then(data => {
            grid.innerHTML = '';

            const lockersFiltrados = data.filter(l => {
                const coincideTexto = l.numeroLocker.toLowerCase().includes(busqueda);
                const coincidePlanta = (plantaSeleccionada === "") || (l.piso && l.piso.trim() === plantaSeleccionada);
                return coincideTexto && coincidePlanta;
            });

            if (lockersFiltrados.length === 0) {
                grid.innerHTML = '<div class="text-center text-muted p-4 w-100">No se encontraron casilleros disponibles.</div>';
                return;
            }

            // Dibujar las tarjetas en el grid
            lockersFiltrados.forEach(l => {
                const card = document.createElement('div');
                const estatusLower = (l.estatus || 'disponible').toLowerCase();

                let claseEstatus = 'disponible';
                let textoEstatus = 'Disponible';

                if (estatusLower.includes('ocupado')) {
                    claseEstatus = 'ocupado';
                    textoEstatus = 'Ocupado';
                } else if (estatusLower.includes('mantenimiento')) {
                    claseEstatus = 'mantenimiento';
                    textoEstatus = 'Mantenimiento';
                }

                card.className = `locker-card ${claseEstatus}`;

                card.innerHTML = `
                    <div class="locker-card-header">
                        <span class="locker-title">${l.numeroLocker}</span>
                        <span class="badge-status ${claseEstatus}">${textoEstatus}</span>
                    </div>
                    <div class="locker-card-body">
                        <i class="bi bi-geo-alt"></i> <span>${l.piso}</span>
                    </div>
                `;

                if (claseEstatus !== 'disponible') {
                    card.style.opacity = '0.7';
                    card.style.cursor = 'not-allowed';
                } else {
                    card.onclick = function() {
                        // 1. Remover selección previa de todas las tarjetas
                        document.querySelectorAll('.locker-card').forEach(c => c.classList.remove('selected'));
                        card.classList.add('selected');

                        // 2. Guardar en el objeto global de estado
                        estadoSeleccion.casilleroId = l.idLocker;
                        estadoSeleccion.casilleroCodigo = l.numeroLocker;

                        // 3. Actualizar textos inferiores de forma segura
                        const labelSeleccionado = document.getElementById('lblSeleccionado');
                        if (labelSeleccionado) {
                            labelSeleccionado.innerText = `Locker ${l.numeroLocker} (${l.piso})`;
                        }

                        const lockerTexto = document.getElementById('lockerSeleccionadoTexto');
                        if (lockerTexto) {
                            lockerTexto.innerText = l.numeroLocker;
                        }

                        // 4. Habilitar el botón de confirmación de asignación
                        const btnConfirmar = document.getElementById('btnConfirmarAsignacion');
                        if (btnConfirmar) {
                            btnConfirmar.disabled = false;
                        }

                        // 5. Ejecutar función externa si está definida
                        if (typeof seleccionarLocker === 'function') {
                            seleccionarLocker(l);
                        }
                    };
                }

                grid.appendChild(card);
            });
        })
        .catch(error => {
            console.error("Error al cargar lockers:", error);
            grid.innerHTML = '<div class="text-center text-danger p-4 w-100">Error al cargar los casilleros.</div>';
        });
}

function seleccionarLocker(element, locker) {
    document.querySelectorAll('.locker-card').forEach(c => c.classList.remove('selected'));
    element.classList.add('selected');

    estadoSeleccion.casilleroId = locker.idLocker;
    estadoSeleccion.casilleroCodigo = locker.numeroLocker;

    document.getElementById('lockerSeleccionadoTexto').innerText = locker.numeroLocker;
    document.getElementById('btnConfirmarAsignacion').disabled = false;
}

function confirmarSeleccionLocker() {
    const nombreEstudiante = document.getElementById('modalEstudianteNombre').innerText;

    // Cierra el modal de asignar para evitar el amontonamiento visual
    cerrarModal('modalAsignar');

    // Muestra la alerta de confirmación con Bootstrap Icons
    mostrarAlerta({
        iconoClase: 'bi bi-info-circle-fill text-primary fs-1',
        titulo: 'Confirmar Asignación',
        mensaje: `¿Estás seguro de asignar el casillero ${estadoSeleccion.casilleroCodigo} a ${nombreEstudiante}?`,
        botones: `
            <button class="btn btn-secondary" onclick="cerrarModal('modalAlerta'); abrirModal('modalAsignar');">Cancelar</button>
            <button class="btn btn-primary" onclick="guardarAsignacionBackend()">Confirmar Asignación</button>
        `
    });
}

// 4. Modal Quitar Casillero
function abrirModalQuitarCasillero(id, nombre, casillero) {
    mostrarAlerta({
        iconoClase: 'bi bi-trash-fill text-danger fs-1',
        titulo: '¿Estás seguro de quitar el casillero?',
        mensaje: `¿Estás seguro de quitar la asignación del casillero ${casillero} a ${nombre}? Esta acción dejará el casillero disponible.`,
        botones: `
            <button class="btn btn-secondary" onclick="cerrarModal('modalAlerta')">Cancelar</button>
            <button class="btn btn-danger" onclick="ejecutarQuitarCasillero('${id}')">Confirmar</button>
        `
    });
}

// 5. Modal Quitar de Lista
function abrirModalQuitarLista(id, nombre) {
    mostrarAlerta({
        iconoClase: 'bi bi-exclamation-triangle-fill text-warning fs-1',
        titulo: `¿Estás seguro de quitar a ${nombre}?`,
        mensaje: 'Al quitar esta solicitud ya no se visualizará en el listado de Pre-aceptados.',
        botones: `
            <button class="btn btn-secondary" onclick="cerrarModal('modalAlerta')">Regresar</button>
            <button class="btn btn-danger" onclick="ejecutarQuitarDeLista('${id}')">Quitar</button>
        `
    });
}

// 6. Validación para "Aceptar Todos" (Casos Borde)
function intentarAceptarTodos() {
    const sinAsignar = Array.from(document.querySelectorAll('#preAceptadosTable tbody tr'))
        .some(tr => tr.innerText.includes('Sin asignar'));

    if (sinAsignar) {
        mostrarAlerta({
            iconoClase: 'bi bi-exclamation-circle-fill text-warning fs-1',
            titulo: 'Acción requerida',
            mensaje: 'Todos los estudiantes tienen que tener un casillero asignado para poder completar la aceptación masiva.',
            botones: '<button class="btn btn-primary" onclick="cerrarModal(\'modalAlerta\')">Entendido</button>'
        });
        return;
    }

    mostrarAlerta({
        iconoClase: 'bi bi-check-circle-fill text-success fs-1',
        titulo: '¿Estás seguro de ACEPTAR a todos los alumnos?',
        mensaje: 'Al confirmar esta acción, todos los estudiantes pre-aceptados serán movidos automáticamente a la lista de aceptados.',
        botones: `
            <button class="btn btn-secondary" onclick="cerrarModal('modalAlerta')">Regresar</button>
            <button class="btn btn-success" onclick="ejecutarAceptarTodosBackend()">Aceptar Todos</button>
        `
    });
}

// Helper para Renderizar Alertas Dinámicas
function mostrarAlerta({ iconoClase, titulo, mensaje, botones }) {
    const contenedorIcono = document.getElementById('alertaIcono');
    if (contenedorIcono) {
        contenedorIcono.innerHTML = `<i class="${iconoClase}"></i>`;
    }
    document.getElementById('alertaTitulo').innerText = titulo;
    document.getElementById('alertaMensaje').innerText = mensaje;
    document.getElementById('alertaBotones').innerHTML = botones;
    abrirModal('modalAlerta');
}

// 7. Peticiones de actualización al backend (Servlets / Controllers)
function guardarAsignacionBackend() {
    cerrarModal('modalAlerta');

    // Enviamos los datos como parámetros de formulario estándar
    const params = new URLSearchParams();
    params.append('idSolicitud', estadoSeleccion.estudianteId);
    params.append('idLocker', estadoSeleccion.casilleroId);

    fetch(`${contextPath}/asignar-locker`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
        .then(response => {
            if (response.ok) {
                location.reload();
            } else {
                alert("No se pudo guardar la asignación en la base de datos.");
            }
        })
        .catch(error => {
            console.error("Error en la petición:", error);
            alert("Error de conexión con el servidor.");
        });
}

function ejecutarQuitarCasillero(idEstudiante) {
    cerrarModal('modalAlerta');
    // fetch(`/api/pre-aceptados/quitar-casillero?id=${idEstudiante}`, { method: 'DELETE' })...
    location.reload();
}

function ejecutarQuitarDeLista(idEstudiante) {
    cerrarModal('modalAlerta');
    // fetch(`/api/pre-aceptados/eliminar?id=${idEstudiante}`, { method: 'DELETE' })...
    location.reload();
}

function ejecutarAceptarTodosBackend() {
    cerrarModal('modalAlerta');

    // Forzamos la ruta completa usando el contextPath existente
    const urlEndpoint = contextPath + "/aceptar-todos";

    fetch(urlEndpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    })
        .then(response => {
            if (response.ok) {
                location.reload();
            } else {
                console.error("El servidor respondió con error:", response.status);
                mostrarAlerta({
                    iconoClase: 'bi bi-x-circle-fill text-danger fs-1',
                    titulo: 'Error del Servidor',
                    mensaje: 'El servidor rechazó la petición (Código ' + response.status + '). Revisa la consola de Java.',
                    botones: '<button class="btn btn-secondary" onclick="cerrarModal(\'modalAlerta\')">Cerrar</button>'
                });
            }
        })
        .catch(error => {
            console.error("Error de red:", error);
        });
}