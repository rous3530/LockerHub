function validarYContinuar() {
    const campos = [
        { inputId: 'inputNombre', fieldId: 'fieldNombre' },
        { inputId: 'inputMatricula', fieldId: 'fieldMatricula' },
        { inputId: 'inputCarrera', fieldId: 'fieldCarrera' },
        { inputId: 'inputCuatrimestre', fieldId: 'fieldCuatrimestre' },
        { inputId: 'inputGrupo', fieldId: 'fieldGrupo' },
        { inputId: 'inputDocencia', fieldId: 'fieldDocencia' },
        { inputId: 'inputCasillero', fieldId: 'fieldCasillero' }
    ];

    let hayError = false;

    campos.forEach(campo => {
        const input = document.getElementById(campo.inputId);
        const fieldContainer = document.getElementById(campo.fieldId);
        const errorFeedback = fieldContainer.querySelector('.error-feedback');

        if (!input.value.trim()) {
            fieldContainer.classList.add('has-error');
            if (errorFeedback) errorFeedback.classList.remove('d-none');
            hayError = true;
        } else {
            fieldContainer.classList.remove('has-error');
            if (errorFeedback) errorFeedback.classList.add('d-none');
        }
    });

    const alertError = document.getElementById('alertErrorGlobal');

    if (hayError) {
        alertError.classList.remove('d-none');
    } else {
        alertError.classList.add('d-none');

        // Ocultar Paso 1 y mostrar Paso 2
        document.getElementById('vistaPaso1').classList.add('d-none');
        document.getElementById('vistaPaso2').classList.remove('d-none');

        // Actualizar el stepper
        document.getElementById('stepperPaso1').classList.remove('active');
        document.getElementById('stepperPaso1').classList.add('completed');
        document.getElementById('stepperPaso2').classList.add('active');
    }
}

function volverPaso1() {
    document.getElementById('vistaPaso2').classList.add('d-none');
    document.getElementById('vistaPaso1').classList.remove('d-none');

    document.getElementById('stepperPaso2').classList.remove('active');
    document.getElementById('stepperPaso1').classList.remove('completed');
    document.getElementById('stepperPaso1').classList.add('active');
}

function enviarSolicitudFinal() {
    // Obtener las referencias del DOM sin anotaciones de tipo TS
    const checkTerminos = document.getElementById('checkTerminos');
    const alertErrorTerminos = document.getElementById('alertErrorTerminos');
    const formSolicitud = document.getElementById('formSolicitud');

    // Validar si la casilla de términos fue marcada
    if (!checkTerminos || !checkTerminos.checked) {
        if (alertErrorTerminos) {
            alertErrorTerminos.classList.remove('d-none');
        }
        return;
    }

    // Ocultar alerta de error si fue marcada
    if (alertErrorTerminos) {
        alertErrorTerminos.classList.add('d-none');
    }

    // Comprobar que el formulario exista y enviarlo al Servlet
    if (formSolicitud) {
        formSolicitud.submit();
    } else {
        console.error("No se encontró el elemento con ID 'formSolicitud'. Verifique el id en el JSP.");
    }
}
function cargarLockersPorEdificio(idEdificio) {
    const selectCasillero = document.getElementById('inputCasillero');
    if (!selectCasillero) return;

    // Resetear el select de casilleros y mostrar estado de carga
    selectCasillero.innerHTML = '<option value="" disabled selected>Cargando casilleros disponibles...</option>';
    selectCasillero.disabled = true;

    if (!idEdificio) return;

    // Petición AJAX al Servlet endpoint
    fetch(contextPath + '/obtener-lockers?idEdificio=' + encodeURIComponent(idEdificio))
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al conectar con el servidor.');
            }
            return response.json();
        })
        .then(lockers => {
            selectCasillero.innerHTML = ''; // Limpiar opciones

            if (lockers.length === 0) {
                selectCasillero.innerHTML = '<option value="" disabled selected>Sin lockers disponibles en este edificio</option>';
                selectCasillero.disabled = true;
            } else {
                let defaultOption = document.createElement('option');
                defaultOption.value = "";
                defaultOption.disabled = true;
                defaultOption.selected = true;
                defaultOption.textContent = "Selecciona un locker disponible...";
                selectCasillero.appendChild(defaultOption);

                lockers.forEach(locker => {
                    let option = document.createElement('option');
                    option.value = locker.idLocker;
                    option.textContent = "Locker #" + locker.numeroLocker;
                    selectCasillero.appendChild(option);
                });

                selectCasillero.disabled = false;
            }
        })
        .catch(error => {
            console.error('Error cargando lockers:', error);
            selectCasillero.innerHTML = '<option value="" disabled selected>Error al obtener lockers</option>';
            selectCasillero.disabled = true;
        });
}