package mx.edu.utez.locker.model;

import java.util.List;

public class AlumnoDashboardDto {
    private int idAlumno;
    private String matricula;
    private String nombreCompleto;
    private String carrera;
    private String cuatrimestreActual;
    private String grupoActual;

    // Datos del Locker Actual (si tiene uno asignado)
    private String idLocker;
    private String edificio;
    private String piso;
    private String periodoVigente;
    private String estatusLocker; // ej. ACTIVO, PENDIENTE, SIN_LOCKER

    public AlumnoDashboardDto() {}

    // Getters y Setters
    public int getIdAlumno() { return idAlumno; }
    public void setIdAlumno(int idAlumno) { this.idAlumno = idAlumno; }

    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getCarrera() { return carrera; }
    public void setCarrera(String carrera) { this.carrera = carrera; }

    public String getCuatrimestreActual() { return cuatrimestreActual; }
    public void setCuatrimestreActual(String cuatrimestreActual) { this.cuatrimestreActual = cuatrimestreActual; }

    public String getGrupoActual() { return grupoActual; }
    public void setGrupoActual(String grupoActual) { this.grupoActual = grupoActual; }

    public String getIdLocker() { return idLocker; }
    public void setIdLocker(String idLocker) { this.idLocker = idLocker; }

    public String getEdificio() { return edificio; }
    public void setEdificio(String edificio) { this.edificio = edificio; }

    public String getPiso() { return piso; }
    public void setPiso(String piso) { this.piso = piso; }

    public String getPeriodoVigente() { return periodoVigente; }
    public void setPeriodoVigente(String periodoVigente) { this.periodoVigente = periodoVigente; }

    public String getEstatusLocker() { return estatusLocker; }
    public void setEstatusLocker(String estatusLocker) { this.estatusLocker = estatusLocker; }
}