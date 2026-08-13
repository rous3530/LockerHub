package mx.edu.utez.locker.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Solicitud implements Serializable {
    private int idSolicitud;
    private Timestamp fechaSolicitud;
    private String estatusSolicitud;
    private int idAlumno;
    private Integer idAdmin; // Puede ser null al registrarse
    private int idPeriodoCuatri;
    private int idEdificio;
    private String grupoActual;
    private String cuatriActual;

    public Solicitud() {}

    public Solicitud(int idSolicitud, Timestamp fechaSolicitud, String estatusSolicitud, int idAlumno,
                     Integer idAdmin, int idPeriodoCuatri, int idEdificio, String grupoActual, String cuatriActual) {
        this.idSolicitud = idSolicitud;
        this.fechaSolicitud = fechaSolicitud;
        this.estatusSolicitud = estatusSolicitud;
        this.idAlumno = idAlumno;
        this.idAdmin = idAdmin;
        this.idPeriodoCuatri = idPeriodoCuatri;
        this.idEdificio = idEdificio;
        this.grupoActual = grupoActual;
        this.cuatriActual = cuatriActual;
    }

    // Getters y Setters
    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

    public Timestamp getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(Timestamp fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }

    public String getEstatusSolicitud() { return estatusSolicitud; }
    public void setEstatusSolicitud(String estatusSolicitud) { this.estatusSolicitud = estatusSolicitud; }

    public int getIdAlumno() { return idAlumno; }
    public void setIdAlumno(int idAlumno) { this.idAlumno = idAlumno; }

    public Integer getIdAdmin() { return idAdmin; }
    public void setIdAdmin(Integer idAdmin) { this.idAdmin = idAdmin; }

    public int getIdPeriodoCuatri() { return idPeriodoCuatri; }
    public void setIdPeriodoCuatri(int idPeriodoCuatri) { this.idPeriodoCuatri = idPeriodoCuatri; }

    public int getIdEdificio() { return idEdificio; }
    public void setIdEdificio(int idEdificio) { this.idEdificio = idEdificio; }

    public String getGrupoActual() { return grupoActual; }
    public void setGrupoActual(String grupoActual) { this.grupoActual = grupoActual; }

    public String getCuatriActual() { return cuatriActual; }
    public void setCuatriActual(String cuatriActual) { this.cuatriActual = cuatriActual; }
}