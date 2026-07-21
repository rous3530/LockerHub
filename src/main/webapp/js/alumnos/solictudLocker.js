// Valida TODOS los campos requeridos antes de avanzar a Paso 2
function validarYContinuar() {
    const campos = [
        { idInput: 'inputNombre', idField: 'fieldNombre' },
        { idInput: 'inputMatricula', idField: 'fieldMatricula' },
        { idInput: 'inputCarrera', idField: 'fieldCarrera' },
        { idInput: 'inputCuatrimestre', idField: 'fieldCuatrimestre' },
        { idInput: 'inputGrupo', idField: 'fieldGrupo' },
        { idInput: 'inputDocencia', idField: 'fieldDocencia' }
    ];

    let hayError = false;

    campos.forEach(campo => {
        const input = document.getElementById(campo.idInput);
        const container = document.getElementById(campo.idField);
        const feedback = container.querySelector('.error-feedback');

        if (!input.value.trim()) {
            hayError = true;
            container.classList.add('has-error');
            if (feedback) feedback.classList.remove('d-none');
        } else {
            container.classList.remove('has-error');
            if (feedback) feedback.classList.add('d-none');
        }
    });

    if (hayError) {
        document.getElementById('alertErrorGlobal').classList.remove('d-none');
        window.scrollTo({ top: 0, behavior: 'smooth' });
        return;
    }

    // Limpia la alerta si todo fue correcto
    document.getElementById('alertErrorGlobal').classList.add('d-none');

    // Avanzar a Paso 2
    document.getElementById('vistaPaso1').classList.add('d-none');
    document.getElementById('vistaPaso2').classList.remove('d-none');

    // Actualizar el Stepper
    const step1 = document.getElementById('stepperPaso1');
    step1.classList.remove('active');
    step1.classList.add('completed');
    document.getElementById('numPaso1').innerHTML = '<i class="bi bi-check"></i>';

    const step2 = document.getElementById('stepperPaso2');
    step2.classList.add('active');
}

// Muestra la confirmación de éxito
function enviarSolicitudFinal() {
    const check = document.getElementById('checkTerminos');
    if (!check.checked) {
        alert("Por favor, acepta los términos y condiciones antes de enviar.");
        return;
    }

    document.getElementById('alertExitoGlobal').classList.remove('d-none');
    window.scrollTo({ top: 0, behavior: 'smooth' });
}